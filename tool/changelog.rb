# frozen_string_literal: true

require "psych"

# Renders release headers from `header_template` in `.changelog.yml`.
class ChangelogHeader
  def self.from_config(config = Psych.load_file(File.expand_path("../.changelog.yml", __dir__)))
    new(config["header_template"], config["release_date_format"])
  end

  def initialize(template, date_format)
    @template = template
    @date_format = date_format
  end

  def render(version)
    @template.gsub(/%new_version|%release_date/) do |placeholder|
      placeholder == "%new_version" ? version.to_s : release_date
    end
  end

  def release_date
    Time.now.strftime(@date_format)
  end

  def section_token
    @section_token ||= @template.match(/^(\S+\s+)/)[1]
  end
end

class ChangelogEntry
  attr_reader :title, :template, :labels, :pull_request

  def initialize(title, template, labels:, pull_request: nil)
    @title = title
    @template = template
    @labels = labels
    @pull_request = pull_request
  end

  def updated_at
    return Time.at(0) unless pull_request

    pull_request.merged_at
  end

  def html_url
    return unless pull_request

    pull_request.html_url
  end
end

class Changelog
  def self.for_release(version)
    new("../CHANGELOG.md", version)
  end

  # The per-library layout of the 4.0 and earlier branches. See Release::SubRelease.
  def self.for_rubygems(version)
    new("../CHANGELOG.md", version, library: "rubygems")
  end

  def self.for_bundler(version)
    new("../bundler/CHANGELOG.md", version, library: "bundler")
  end

  def initialize(file, version, library: nil)
    @version = Gem::Version.new(version)
    @file = File.expand_path(file, __dir__)
    @library = library
    @config = Psych.load_file(File.expand_path("../.changelog.yml", __dir__))
    @level = @version.segments[2] != 0 ? :patch : :minor_or_major

    validate_config!
  end

  def release_notes
    current_version_title = "#{release_section_token}#{version}"

    current_version_index = lines.find_index {|line| line.strip =~ /^#{current_version_title}($|\b)/ }
    unless current_version_index
      raise "Update the changelog for the last version (#{version})"
    end
    current_version_index += 1
    previous_version_lines = lines[current_version_index.succ...-1]
    previous_version_index = current_version_index + (
      previous_version_lines.find_index {|line| line.start_with?(release_section_token) } ||
      lines.count
    )

    lines[current_version_index..previous_version_index]
  end

  def release_notes_for_blog
    release_notes
  end

  def change_types_for_blog
    headings = change_types.map {|section| section_heading(section) }

    types = release_notes.
      select {|line| headings.include?(line) }.
      map {|line| line.downcase.tr("^a-z ", "").strip }.
      uniq

    last_change_type = types.pop

    if types.empty?
      types = +""
    else
      types = types.join(", ") << " and "
    end

    types << last_change_type
  end

  def cut!(included_pull_requests, extra_entry: nil)
    retained = retained_sections
    dropped = drop_already_released(included_pull_requests, retained)

    full_new_changelog = [
      *preamble,
      format_header,
      "",
      *unreleased_notes_for(included_pull_requests, extra_entry: extra_entry, dropped: dropped),
      *retained,
    ].join("\n") + "\n"

    File.write(@file, full_new_changelog)
  end

  def unreleased_notes_for(included_pull_requests, extra_entry:, dropped: {})
    entries = prepare_entries(included_pull_requests, extra_entry)

    return library_notes(entries, @library, dropped) if @library

    library_headings.flat_map do |library, heading|
      notes = library_notes(entries, library, dropped)
      next [] if notes.empty?

      ["### #{heading}", "", *notes]
    end
  end

  def labelled?(pull)
    changelog_labels.intersect?(pull.labels.map(&:name))
  end

  # A pull request labelled for both libraries is listed under both, the way
  # the per-library changelogs listed it before they were merged. Within one
  # library, a `skip changelog` label next to a sectioned one just means the
  # other library's entry is the one.
  def sections_for(change)
    relevant_labels = change.labels.map(&:name) & changelog_labels

    relevant_labels.group_by {|label| label.split(": ").first }.filter_map do |library, labels|
      sections = labels.map {|label| changelog_label_mapping[label] }.uniq
      sections.delete(nil) if sections.size > 1
      unless sections.size == 1
        raise "#{change.html_url} has #{library} labels for different changelog sections: #{labels.join(", ")}"
      end

      [library, sections.first] if sections.first
    end.to_h
  end

  private

  attr_reader :version

  # Three tables in `.changelog.yml` have to agree on the same label names.
  # Where they do not, the release carries the pull request and then drops its
  # entry, or quietly stops backporting it, without saying anything. Check the
  # raw tables rather than the reader, which the per-library layout filters.
  def validate_config!
    mapping = @config["changelog_label_mapping"]

    missing = mapping.keys.map {|label| label.split(": ").first }.uniq - library_headings.keys
    raise "No library_headings entry in .changelog.yml for #{missing.join(", ")}" unless missing.empty?

    unknown = patch_level_labels - mapping.keys
    raise "No changelog_label_mapping entry in .changelog.yml for #{unknown.join(", ")}" unless unknown.empty?
  end

  def format_header
    header.render(version)
  end

  def format_entry_for(entry)
    pull = entry.pull_request

    substitutions = { "%title" => entry.title }
    if pull
      substitutions["%pull_request_number"] = pull.number.to_s
      substitutions["%pull_request_url"] = pull.html_url
      substitutions["%pull_request_authors"] = credits_for(pull)
    end

    # An entry is one line. A newline in a title or a display name would start
    # a second one, and `## ` at its head would read as a release header.
    substitutions.transform_values! {|value| value.to_s.gsub(/\s*\n\s*/, " ") }

    new_entry = entry.template.gsub(Regexp.union(substitutions.keys), substitutions)

    new_entry = wrap(new_entry, entry_wrapping, 2) if entry_wrapping

    new_entry
  end

  # Everyone who committed to the pull request, not only whoever opened it, so
  # that work several people shared is not credited to one of them. A pull
  # request a bot opened and committed to on its own keeps the bot, since
  # dropping it would leave the entry crediting nobody.
  def credits_for(pull)
    credited = pull.authors.reject {|author| excluded_credit?(author) }
    credited = pull.authors.take(1) if credited.empty?

    names = names_of(credited)
    last = names.pop

    names.empty? ? last.to_s : "#{names.join(", ")} and #{last}"
  end

  # One person can commit under more than one name, and under more than one
  # account, so the account they are credited as decides who is on the entry
  # already. They keep the place they were first credited in, but are named
  # as that account, rather than as whichever one the entry reached first.
  def names_of(authors)
    authors.group_by {|author| credited_account(author) }.map do |account, recorded|
      author = recorded.find {|candidate| candidate.login.to_s.downcase == account } || recorded.first

      author.name || author.login
    end
  end

  def credited_account(author)
    login = author.login.to_s.downcase

    credit_aliases.fetch(login, login)
  end

  def excluded_credit?(author)
    login = author.login.to_s

    login.end_with?("[bot]") || excluded_credit_logins.any? {|excluded| excluded.casecmp?(login) }
  end

  def wrap(text, length, indent)
    result = []
    work = text.dup

    while work.length > length
      if work =~ /^(.{0,#{length}})[ \n]/o
        result << $1
        work.slice!(0, $&.length)
      else
        result << work.slice!(0, length)
      end
    end

    result << work unless work.empty?
    result = result.reduce(String.new) do |acc, elem|
      acc << "\n" << " " * indent unless acc.empty?
      acc << elem
    end
    result
  end

  def prepare_entries(pulls, extra_entry)
    entries = pulls.map do |pull|
      ChangelogEntry.new(
        pull.title.strip.delete_suffix(".").tap {|s| s[0] = s[0].upcase },
        entry_template,
        labels: pull.labels,
        pull_request: pull
      )
    end

    entries << ChangelogEntry.new(
      extra_entry,
      extra_entry_template,
      labels: [Struct.new(:name).new(extra_entry_label)]
    ) if extra_entry

    entries
  end

  def notes_for(sections)
    sections.flat_map do |section, entries|
      [section_heading(section), "", *entries.reverse_each.map {|entry| format_entry_for(entry) }, ""]
    end
  end

  def group_by_section(entries, library, shipped = nil)
    grouped_entries = entries.
      reject {|entry| shipped&.key?(entry.pull_request&.number) }.
      sort_by(&:updated_at).
      group_by {|entry| sections_for(entry)[library] }

    grouped_entries.delete(nil)

    grouped_entries.sort_by {|section, _entries| change_types.index(section) }.to_h
  end

  # The unified changelog nests the change types under a library heading. The
  # per-library changelogs of the 4.0 and earlier branches have no library
  # level, so their change types stay one level up.
  def section_heading(section)
    @library ? "### #{section}" : "#### #{section}"
  end

  def relevant_changelog_label_mapping
    if @level == :patch
      changelog_label_mapping.slice(*patch_level_labels)
    else
      changelog_label_mapping
    end
  end

  def changelog_labels
    relevant_changelog_label_mapping.keys
  end

  def change_types
    relevant_changelog_label_mapping.values.compact.uniq
  end

  def preamble
    lines.take_while {|line| !line.start_with?(release_section_token) }
  end

  # Released sections stay in place, so the section can be regenerated on a
  # re-run or on master underneath a newer release line. Only an earlier cut
  # of this version goes, and, for a final release, the prereleases it wraps up.
  def retained_sections
    sections = lines.drop(preamble.size).slice_before {|line| line.start_with?(release_section_token) }
    kept = sections.reject {|section| superseded?(section_version(section.first)) }.flatten
    kept.pop while kept.last == ""
    kept
  end

  # A minor release lists everything merged since the previous line was cut,
  # which includes what that line's patch releases already shipped. Those
  # entries stay under the patch release only, with a note saying so. The
  # check is per library, so a pull request labelled for both still gets the
  # entry for whichever library has not carried it yet.
  def drop_already_released(pulls, retained)
    return {} unless @level == :minor_or_major

    shipped = shipped_by_library(retained)

    pulls.each_with_object({}) do |pull, dropped|
      sections_for(pull).each_key do |library|
        released_version = shipped.dig(library, pull.number)
        next unless released_version

        (dropped[library] ||= {})[pull.number] = released_version
      end
    end
  end

  def library_notes(entries, library, dropped)
    shipped = dropped[library]

    [*already_released_note(shipped), *notes_for(group_by_section(entries, library, shipped))]
  end

  def already_released_note(shipped)
    return [] unless shipped&.any?

    [already_released_template.gsub("%released_in") { release_lines_for(shipped.values).join(", ") }, ""]
  end

  def shipped_by_library(retained)
    retained.slice_before {|line| line.start_with?(release_section_token) }.each_with_object({}) do |section, shipped|
      released_version = section_version(section.first)
      next unless released_version && released_version < version

      library_bodies(section).each do |library, body|
        body.join("\n").scan(/\[#(\d+)\]\(/).flatten.each do |number|
          (shipped[library] ||= {})[number.to_i] ||= released_version
        end
      end
    end
  end

  # Sections cut before the changelogs were merged carry no library heading,
  # so everything in them counts for every library.
  def library_bodies(section)
    headings = library_headings.to_h {|library, heading| ["### #{heading}", library] }
    current = nil

    bodies = section.each_with_object({}) do |line, split|
      current = headings.fetch(line) { line.start_with?("### ") ? nil : current }
      (split[current] ||= []) << line if current
    end

    bodies.empty? ? library_headings.transform_values { section } : bodies
  end

  # Sorted as versions rather than as strings, so 4.9.x comes before 4.10.x.
  def release_lines_for(versions)
    versions.map {|released_version| Gem::Version.new(released_version.segments[0, 2].join(".")) }.uniq.sort.map {|line| "#{line}.x" }
  end

  def superseded?(candidate)
    return false unless candidate

    candidate == version || (!version.prerelease? && candidate.prerelease? && candidate.release == version)
  end

  # `Gem::Version.new(nil)` is version 0 rather than an error, so a header with
  # no version at all has to be rejected before it reaches the constructor.
  def section_version(header)
    candidate = header.delete_prefix(release_section_token).split.first
    return unless candidate

    Gem::Version.new(candidate)
  rescue ArgumentError
    nil
  end

  # Read on every call because the release task cuts the same changelog on
  # the release branch and then again on master.
  def lines
    File.read(@file).split("\n")
  end

  def release_section_token
    header.section_token
  end

  def header
    @header ||= ChangelogHeader.from_config(@config)
  end

  def entry_template
    @config["entry_template"]
  end

  def extra_entry_template
    @config["extra_entry"]["template"]
  end

  def extra_entry_label
    @config["extra_entry"]["label"]
  end

  def already_released_template
    @config["already_released_template"]
  end

  def excluded_credit_logins
    @config["excluded_credit_logins"]
  end

  def credit_aliases
    @credit_aliases ||= @config["credit_aliases"].flat_map do |account, logins|
      logins.map {|login| [login.downcase, account.downcase] }
    end.to_h
  end

  def library_headings
    @config["library_headings"]
  end

  def entry_wrapping
    @config["entry_wrapping"]
  end

  def changelog_label_mapping
    mapping = @config["changelog_label_mapping"]
    return mapping unless @library

    mapping.select {|label, _section| label.start_with?("#{@library}: ") }
  end

  def patch_level_labels
    @config["patch_level_labels"]
  end
end
