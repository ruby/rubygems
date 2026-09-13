# frozen_string_literal: true

require "tmpdir"
require_relative "../tool/changelog"
require_relative "../tool/release"
require_relative "rubygems/helper"

class ChangelogTest < Test::Unit::TestCase
  Label = Struct.new(:name)
  User = Struct.new(:name, :login)
  PullRequest = Struct.new(:number, :title, :labels, :merged_at, :authors, :html_url)

  def setup
    @changelog = Changelog.for_release("9.9.0")
  end

  def test_format_header
    Time.stub :now, Time.new(2020, 1, 1) do
      assert_match %r{^##\s*[\d.a-zA-Z]+\s*/\s*\d{4}-\d{2}-\d{2}\s*$}, @changelog.send(:format_header)
    end
  end

  def test_labels_of_both_libraries_list_the_entry_under_both
    assert_equal({ "rubygems" => "Features:", "bundler" => "Features:" },
                 @changelog.sections_for(pull(1, "rubygems: feature", "bundler: feature")))
  end

  def test_labels_of_both_libraries_may_point_at_different_sections
    assert_equal({ "rubygems" => "Features:", "bundler" => "Bug fixes:" },
                 @changelog.sections_for(pull(1, "rubygems: feature", "bundler: bug fix")))
  end

  def test_skip_changelog_drops_only_its_own_library
    assert_equal({ "bundler" => "Bug fixes:" },
                 @changelog.sections_for(pull(1, "rubygems: skip changelog", "bundler: bug fix")))
  end

  def test_labels_for_different_sections_of_one_library_are_rejected
    error = assert_raise(RuntimeError) { @changelog.sections_for(pull(1, "rubygems: feature", "rubygems: bug fix")) }
    assert_include error.message, "rubygems labels for different changelog sections"
  end

  def test_a_label_whose_library_has_no_heading_is_rejected
    config = Psych.load_file(File.expand_path("../.changelog.yml", __dir__))
    config["changelog_label_mapping"]["newlib: bug fix"] = "Bug fixes:"

    Psych.stub(:load_file, config) do
      error = assert_raise(RuntimeError) { Changelog.for_release("9.9.0") }
      assert_include error.message, "No library_headings entry in .changelog.yml for newlib"
    end
  end

  def test_a_patch_level_label_with_no_mapping_is_rejected
    config = Psych.load_file(File.expand_path("../.changelog.yml", __dir__))
    config["patch_level_labels"] << "rubygems: typo"

    Psych.stub(:load_file, config) do
      error = assert_raise(RuntimeError) { Changelog.for_release("9.9.0") }
      assert_include error.message, "No changelog_label_mapping entry in .changelog.yml for rubygems: typo"
    end
  end

  def test_unreleased_notes_split_the_sections_by_library
    pulls = [
      pull(1, "rubygems: bug fix"),
      pull(2, "bundler: feature"),
      pull(3, "rubygems: feature", "bundler: feature"),
      pull(4, "bundler: bug fix"),
    ]

    notes = @changelog.unreleased_notes_for(pulls, extra_entry: "Installs bundler 9.9.0 as a default gem")

    assert_equal ["### RubyGems", "#### Features:", "#### Enhancements:", "#### Bug fixes:",
                  "### Bundler", "#### Features:", "#### Bug fixes:"], notes.grep(/^#/)

    rubygems = library_notes(notes, "### RubyGems")
    assert_equal [3], entry_numbers(rubygems, "#### Features:")
    assert_equal [1], entry_numbers(rubygems, "#### Bug fixes:")
    assert_include rubygems, "* Installs bundler 9.9.0 as a default gem."

    bundler = library_notes(notes, "### Bundler")
    assert_equal [3, 2], entry_numbers(bundler, "#### Features:")
    assert_equal [4], entry_numbers(bundler, "#### Bug fixes:")
  end

  def test_unreleased_notes_of_a_per_library_changelog_have_no_library_heading
    notes = Changelog.for_bundler("9.9.0").unreleased_notes_for([pull(1, "bundler: feature")], extra_entry: nil)

    assert_equal ["### Features:"], notes.grep(/^#/)
  end

  def test_entry_leaves_the_author_empty_when_the_pull_request_has_none
    changed = pull(1, "rubygems: bug fix")
    changed.authors = [User.new(nil, nil)]

    notes = @changelog.unreleased_notes_for([changed], extra_entry: nil)

    assert_include notes, "* Change 1. Pull request [#1](https://github.com/ruby/rubygems/pull/1) by "
  end

  def test_entry_credits_everyone_who_committed_to_the_pull_request
    changed = pull(1, "rubygems: bug fix")
    changed.authors += [User.new("Someone Else", "else"), User.new("A Third", "third")]

    notes = @changelog.unreleased_notes_for([changed], extra_entry: nil)

    assert_include notes, "* Change 1. Pull request [#1](https://github.com/ruby/rubygems/pull/1) by Someone, Someone Else and A Third"
  end

  def test_entry_credits_an_author_recorded_under_two_names_once
    changed = pull(1, "rubygems: bug fix")
    changed.authors += [User.new("Someone Else", "else"), User.new("The Someone", "Someone")]

    notes = @changelog.unreleased_notes_for([changed], extra_entry: nil)

    assert_include notes, "* Change 1. Pull request [#1](https://github.com/ruby/rubygems/pull/1) by Someone and Someone Else"
  end

  def test_entry_credits_an_author_committing_under_two_accounts_as_the_main_one
    changed = pull(1, "rubygems: bug fix")
    changed.authors = [User.new("Jean byroot Boussier", "casperisfine"), User.new("Jean Boussier", "byroot")]

    notes = @changelog.unreleased_notes_for([changed], extra_entry: nil)

    assert_include notes, "* Change 1. Pull request [#1](https://github.com/ruby/rubygems/pull/1) by Jean Boussier"
  end

  def test_entry_credits_a_sub_account_under_its_own_name_when_the_main_one_is_absent
    changed = pull(1, "rubygems: bug fix")
    changed.authors = [User.new("Jean byroot Boussier", "casperisfine")]

    notes = @changelog.unreleased_notes_for([changed], extra_entry: nil)

    assert_include notes, "* Change 1. Pull request [#1](https://github.com/ruby/rubygems/pull/1) by Jean byroot Boussier"
  end

  def test_entry_drops_bot_authors_from_the_credits
    changed = pull(1, "rubygems: bug fix")
    changed.authors += [User.new("Claude Opus 5", "claude"), User.new("dependabot[bot]", "dependabot[bot]")]

    notes = @changelog.unreleased_notes_for([changed], extra_entry: nil)

    assert_include notes, "* Change 1. Pull request [#1](https://github.com/ruby/rubygems/pull/1) by Someone"
  end

  def test_entry_of_a_pull_request_only_bots_worked_on_credits_its_author
    changed = pull(1, "rubygems: bug fix")
    changed.authors = [User.new(nil, "dependabot[bot]"), User.new("Claude Opus 5", "claude")]

    notes = @changelog.unreleased_notes_for([changed], extra_entry: nil)

    assert_include notes, "* Change 1. Pull request [#1](https://github.com/ruby/rubygems/pull/1) by dependabot[bot]"
  end

  def test_entry_folds_a_newline_in_a_title_into_one_line
    changed = pull(1, "rubygems: bug fix")
    changed.title = "Break out\n## 9.8.0 / 2019-01-01"

    notes = @changelog.unreleased_notes_for([changed], extra_entry: nil)

    assert_equal 1, notes.count {|line| line.start_with?("* ") }
    assert_empty notes.grep(/^## /)
  end

  def test_entry_copies_a_title_with_substitution_syntax_verbatim
    title = "Handle \\0 and %pull_request_author in titles"
    changed = pull(1, "rubygems: bug fix")
    changed.title = title

    notes = @changelog.unreleased_notes_for([changed], extra_entry: nil)

    assert_include notes, "* #{title}. Pull request [#1](https://github.com/ruby/rubygems/pull/1) by Someone"
  end

  def test_cut_keeps_the_preamble_and_the_released_sections
    changelog = <<~CHANGELOG
      # Changelog

      Older history lives elsewhere.

      ## 9.8.0 / 2019-01-01

      ### Bundler

      #### Features:

      * Old feature.
    CHANGELOG

    assert_equal <<~CHANGELOG, cut(changelog, "9.9.0", pull(1, "bundler: feature"))
      # Changelog

      Older history lives elsewhere.

      ## 9.9.0 / 2020-01-01

      ### Bundler

      #### Features:

      * Change 1. Pull request [#1](https://github.com/ruby/rubygems/pull/1) by Someone

      ## 9.8.0 / 2019-01-01

      ### Bundler

      #### Features:

      * Old feature.
    CHANGELOG
  end

  def test_cut_keeps_a_newer_release_line_and_replaces_an_earlier_cut_of_the_same_version
    changelog = <<~CHANGELOG
      # Changelog

      ## 10.0.0.beta1 / 2019-12-01

      ### RubyGems

      #### Features:

      * Beta feature.

      ## 9.9.1 / 2019-11-01

      ### RubyGems

      #### Bug fixes:

      * Stale entry.

      ## 9.9.0 / 2019-01-01

      ### RubyGems

      #### Features:

      * Old feature.
    CHANGELOG

    assert_equal <<~CHANGELOG, cut(changelog, "9.9.1", pull(1, "rubygems: bug fix"))
      # Changelog

      ## 9.9.1 / 2020-01-01

      ### RubyGems

      #### Bug fixes:

      * Change 1. Pull request [#1](https://github.com/ruby/rubygems/pull/1) by Someone

      ## 10.0.0.beta1 / 2019-12-01

      ### RubyGems

      #### Features:

      * Beta feature.

      ## 9.9.0 / 2019-01-01

      ### RubyGems

      #### Features:

      * Old feature.
    CHANGELOG
  end

  def test_cut_of_a_final_release_replaces_its_prerelease_sections_and_skips_what_patch_releases_shipped
    changelog = <<~CHANGELOG
      # Changelog

      ## 9.9.0.beta2 / 2019-12-01

      ### RubyGems

      #### Features:

      * Beta 2 feature.

      ## 9.8.1 / 2019-11-15

      ### Bundler

      #### Bug fixes:

      * Change 2. Pull request [#2](https://github.com/ruby/rubygems/pull/2) by Someone

      ## 9.9.0.beta1 / 2019-11-01

      ### RubyGems

      #### Features:

      * Change 1. Pull request [#1](https://github.com/ruby/rubygems/pull/1) by Someone
    CHANGELOG

    pulls = [pull(1, "rubygems: feature"), pull(2, "bundler: bug fix"), pull(3, "rubygems: feature")]

    assert_equal <<~CHANGELOG, cut(changelog, "9.9.0", *pulls)
      # Changelog

      ## 9.9.0 / 2020-01-01

      ### RubyGems

      #### Features:

      * Change 3. Pull request [#3](https://github.com/ruby/rubygems/pull/3) by Someone
      * Change 1. Pull request [#1](https://github.com/ruby/rubygems/pull/1) by Someone

      ### Bundler

      Changes already released in 9.8.x are not repeated here.

      ## 9.8.1 / 2019-11-15

      ### Bundler

      #### Bug fixes:

      * Change 2. Pull request [#2](https://github.com/ruby/rubygems/pull/2) by Someone
    CHANGELOG
  end

  def test_cut_of_a_final_release_only_skips_the_library_that_already_shipped_the_entry
    changelog = <<~CHANGELOG
      # Changelog

      ## 9.8.1 / 2019-11-15

      ### Bundler

      #### Bug fixes:

      * Change 1. Pull request [#1](https://github.com/ruby/rubygems/pull/1) by Someone
    CHANGELOG

    assert_equal <<~CHANGELOG, cut(changelog, "9.9.0", pull(1, "bundler: bug fix", "rubygems: feature"))
      # Changelog

      ## 9.9.0 / 2020-01-01

      ### RubyGems

      #### Features:

      * Change 1. Pull request [#1](https://github.com/ruby/rubygems/pull/1) by Someone

      ### Bundler

      Changes already released in 9.8.x are not repeated here.

      ## 9.8.1 / 2019-11-15

      ### Bundler

      #### Bug fixes:

      * Change 1. Pull request [#1](https://github.com/ruby/rubygems/pull/1) by Someone
    CHANGELOG
  end

  def test_cut_ignores_a_release_header_with_no_version
    changelog = <<~CHANGELOG
      # Changelog

      ###{" "}

      ### RubyGems

      #### Bug fixes:

      * Change 1. Pull request [#1](https://github.com/ruby/rubygems/pull/1) by Someone
    CHANGELOG

    cut = cut(changelog, "9.9.0", pull(1, "rubygems: bug fix"))

    assert_not_include cut, "are not repeated here."
    assert_include cut, "* Change 1. Pull request [#1](https://github.com/ruby/rubygems/pull/1) by Someone"
  end

  def test_cut_names_the_already_released_lines_in_version_order
    changelog = <<~CHANGELOG
      # Changelog

      ## 9.10.1 / 2019-12-01

      ### RubyGems

      #### Bug fixes:

      * Change 1. Pull request [#1](https://github.com/ruby/rubygems/pull/1) by Someone

      ## 9.9.1 / 2019-11-01

      ### RubyGems

      #### Bug fixes:

      * Change 2. Pull request [#2](https://github.com/ruby/rubygems/pull/2) by Someone
    CHANGELOG

    cut = cut(changelog, "9.11.0", pull(1, "rubygems: bug fix"), pull(2, "rubygems: bug fix"))

    assert_include cut, "Changes already released in 9.9.x, 9.10.x are not repeated here."
  end

  def test_cut_of_a_patch_release_keeps_entries_listed_under_a_newer_line
    changelog = <<~CHANGELOG
      # Changelog

      ## 10.0.0.beta1 / 2019-12-01

      ### RubyGems

      #### Features:

      * Change 1. Pull request [#1](https://github.com/ruby/rubygems/pull/1) by Someone
    CHANGELOG

    assert_equal <<~CHANGELOG, cut(changelog, "9.9.1", pull(1, "rubygems: bug fix"))
      # Changelog

      ## 9.9.1 / 2020-01-01

      ### RubyGems

      #### Bug fixes:

      * Change 1. Pull request [#1](https://github.com/ruby/rubygems/pull/1) by Someone

      ## 10.0.0.beta1 / 2019-12-01

      ### RubyGems

      #### Features:

      * Change 1. Pull request [#1](https://github.com/ruby/rubygems/pull/1) by Someone
    CHANGELOG
  end

  def test_cut_of_a_patch_release_keeps_entries_listed_under_an_older_line
    changelog = <<~CHANGELOG
      # Changelog

      ## 9.8.1 / 2019-12-01

      ### RubyGems

      #### Bug fixes:

      * Change 1. Pull request [#1](https://github.com/ruby/rubygems/pull/1) by Someone
    CHANGELOG

    assert_equal <<~CHANGELOG, cut(changelog, "9.9.1", pull(1, "rubygems: bug fix"))
      # Changelog

      ## 9.9.1 / 2020-01-01

      ### RubyGems

      #### Bug fixes:

      * Change 1. Pull request [#1](https://github.com/ruby/rubygems/pull/1) by Someone

      ## 9.8.1 / 2019-12-01

      ### RubyGems

      #### Bug fixes:

      * Change 1. Pull request [#1](https://github.com/ruby/rubygems/pull/1) by Someone
    CHANGELOG
  end

  def test_cut_of_a_per_library_changelog_with_no_entries_leaves_a_single_blank_line
    changelog = <<~CHANGELOG
      # Changelog

      ## 9.8.0 / 2019-01-01

      ### Features:

      * Old feature.
    CHANGELOG

    assert_equal <<~CHANGELOG, cut(changelog, "9.9.0", pull(1, "rubygems: feature"), library: "bundler")
      # Changelog

      ## 9.9.0 / 2020-01-01

      ## 9.8.0 / 2019-01-01

      ### Features:

      * Old feature.
    CHANGELOG
  end

  private

  def cut(changelog, version, *pulls, library: nil)
    Dir.mktmpdir do |dir|
      file = File.join(dir, "CHANGELOG.md")
      File.write(file, changelog)

      Time.stub :now, Time.new(2020, 1, 1) do
        Changelog.new(file, version, library: library).cut!(pulls)
      end

      File.read(file)
    end
  end

  def pull(number, *labels)
    PullRequest.new(
      number,
      "Change #{number}",
      labels.map {|label| Label.new(label) },
      Time.at(number),
      [User.new("Someone", "someone")],
      "https://github.com/ruby/rubygems/pull/#{number}"
    )
  end

  def library_notes(notes, heading)
    notes.drop(notes.index(heading) + 1).take_while {|line| !line.start_with?("### ") }
  end

  def entry_numbers(notes, section)
    notes.drop(notes.index(section) + 1).take_while {|line| !line.start_with?("#") }.filter_map {|line| line[/#(\d+)\]/, 1]&.to_i }
  end
end

class ChangelogHeaderTest < Test::Unit::TestCase
  def setup
    @header = ChangelogHeader.from_config
  end

  def test_release_date
    Time.stub :now, Time.new(2020, 1, 1) do
      assert_equal "2020-01-01", @header.release_date
    end
  end

  def test_render_stamps_the_header_with_the_release_date
    Time.stub :now, Time.new(2020, 1, 1) do
      assert_equal "## 9.9.9 / #{@header.release_date}", @header.render("9.9.9")
    end
  end
end

class ReleaseChangelogTest < Test::Unit::TestCase
  def test_per_library_changelogs_are_built_before_the_release_branch_is_checked_out
    release = Release.new("9.9.9")

    bundler = release.instance_variable_get(:@bundler).instance_variable_get(:@changelog)
    rubygems = release.instance_variable_get(:@rubygems).instance_variable_get(:@changelog)

    assert_instance_of Changelog, bundler
    assert_instance_of Changelog, rubygems
  end

  def test_per_library_changelogs_only_carry_their_own_labels
    labels = Changelog.for_bundler("9.9.0").send(:changelog_label_mapping).keys

    refute_empty labels
    assert labels.all? {|label| label.start_with?("bundler: ") }, labels.inspect
  end

  def test_changelogs_cuts_one_per_library_on_the_legacy_layout
    release = Release.new("9.9.9")

    release.stub(:legacy_layout?, true) do
      assert_equal [
        [release.instance_variable_get(:@bundler).changelog, nil],
        [release.instance_variable_get(:@rubygems).changelog, "Installs bundler 9.9.9 as a default gem"],
      ], release.send(:changelogs)
    end
  end

  def test_changelogs_cuts_the_unified_changelog_otherwise
    release = Release.new("9.9.9")

    release.stub(:legacy_layout?, false) do
      assert_equal [[release.changelog, "Installs bundler 9.9.9 as a default gem"]], release.send(:changelogs)
    end
  end
end

class ReleaseGitStateTest < Test::Unit::TestCase
  def test_check_git_state_accepts_a_clean_working_tree
    in_git_repo do
      assert_nothing_raised { Release.new("9.9.9").check_git_state! }
    end
  end

  def test_check_git_state_rejects_a_dirty_working_tree
    in_git_repo do
      release = Release.new("9.9.9")

      File.write("README.md", "unstaged\n")
      assert_include assert_raise(RuntimeError) { release.check_git_state! }.message, "uncommitted changes"

      git "add", "README.md"
      assert_include assert_raise(RuntimeError) { release.check_git_state! }.message, "uncommitted changes"
    end
  end

  def test_check_git_state_rejects_a_stable_branch_that_is_only_local
    in_git_repo do
      git "branch", "9.9"

      error = assert_raise(RuntimeError) { Release.new("9.9.0").check_git_state! }
      assert_include error.message, "Local branch 9.9 exists but origin/9.9 does not"
    end
  end

  def test_check_git_state_accepts_a_local_stable_branch_for_a_patch_release
    in_git_repo do
      git "branch", "9.9"

      assert_nothing_raised { Release.new("9.9.1").check_git_state! }
    end
  end

  private

  def in_git_repo
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        git "init", "--quiet"
        File.write("README.md", "\n")
        git "add", "README.md"
        git "commit", "--quiet", "-m", "Initial commit"

        yield
      end
    end
  end

  def git(*args)
    system(
      "git",
      "-c", "init.defaultBranch=master",
      "-c", "user.name=Release Test",
      "-c", "user.email=release@example.com",
      "-c", "commit.gpgsign=false",
      "-c", "core.hooksPath=/dev/null",
      "-c", "commit.template=",
      *args,
      exception: true
    )
  end
end
