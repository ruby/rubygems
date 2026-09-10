# frozen_string_literal: true

require "json"
require "time"

require_relative "changelog"

class Release
  # The pull request data the release tooling consumes, built from a
  # `gh pr list` record so that no per pull request API call is needed.
  Label = Struct.new(:name)
  User = Struct.new(:name, :login)
  PullRequest = Struct.new(:number, :node_id, :title, :html_url, :labels, :merged_at, :authors, :merge_commit_sha)

  # `gh pr list` refuses to return more than this many results and truncates
  # silently once a window holds more, so a listing that reaches the cap is
  # refused rather than cut from a partial one.
  MERGED_PULL_REQUEST_LIMIT = 1000

  # Pull requests whose commits are read in one query. Every commit and every
  # author a query can reach counts against a node budget, and a query over
  # that budget is rejected rather than answered partially.
  COMMIT_AUTHOR_BATCH_SIZE = 100

  COMMIT_AUTHORS_QUERY = <<~GRAPHQL
    query($ids: [ID!]!) {
      nodes(ids: $ids) {
        ... on PullRequest {
          number
          commits(first: 100) {
            nodes { commit { authors(first: 10) { nodes { name user { login name } } } } }
          }
        }
      }
    }
  GRAPHQL

  module GithubAPI
    def gh_client
      @gh_client ||= begin
        require "octokit"
        Octokit::Client.new(access_token: ENV["GITHUB_RELEASE_PAT"])
      end
    end
  end

  # Version bumping for one of the two libraries, plus the per-library
  # changelog Release#changelogs cuts on the 4.0 and earlier release branches.
  # That changelog is built at construction time, before `prepare!` checks out
  # the release branch, so its `.changelog.yml` comes from master, the only
  # config listing both libraries' labels.
  module SubRelease
    attr_reader :version, :changelog, :version_files

    def bump_versions!
      version_files.each do |version_file|
        version_contents = File.read(version_file)
        unless version_contents.sub!(/^(.*VERSION = )"#{Gem::Version::VERSION_PATTERN}"/i, "\\1#{version.to_s.dump}")
          raise "Failed to update #{version_file}, is it in the expected format?"
        end
        File.open(version_file, "w") {|f| f.write(version_contents) }
      end
    end
  end

  class Bundler
    include SubRelease

    def initialize(version)
      @version = Gem::Version.new(version)
      @changelog = Changelog.for_bundler(version)
      # Bundler's version file was flattened to lib/bundler/version.rb on
      # master, but stays at bundler/lib/bundler/version.rb on the 4.0 and
      # earlier release branches. The release task loads this tool from the
      # default branch and bumps versions after switching to the release
      # branch, so the real path is resolved lazily in #version_files against
      # the release branch working tree.
      @version_file_candidates = [
        File.expand_path("../lib/bundler/version.rb", __dir__),
        File.expand_path("../bundler/lib/bundler/version.rb", __dir__),
      ]
    end

    def version_files
      [@version_file_candidates.find {|candidate| File.exist?(candidate) } || @version_file_candidates.first]
    end
  end

  class Rubygems
    include SubRelease

    def initialize(version)
      @version = Gem::Version.new(version)
      @version_files = [File.expand_path("../lib/rubygems.rb", __dir__)]
      @changelog = Changelog.for_rubygems(version)
    end
  end

  include GithubAPI

  attr_reader :changelog

  def self.install_dependencies!
    system(
      { "RUBYOPT" => "-I#{File.expand_path("../lib", __dir__)}" },
      File.expand_path("../bin/bundle", __dir__),
      "install",
      "--gemfile=#{File.expand_path("bundler/release_gems.rb", __dir__)}",
      exception: true
    )

    Gem.clear_paths
  end

  #
  # Accepts the version of the rubygems library to be released
  #
  def initialize(version)
    segments = Gem::Version.new(version).segments

    @level = segments[2] != 0 ? :patch : :minor_or_major
    @prerelease = segments.size > 3

    @stable_branch = segments[0, 2].join(".")
    @previous_stable_branch = @level == :minor_or_major ? "#{segments[0]}.#{segments[1] - 1}" : @stable_branch
    @previous_stable_branch = "3.7" if @stable_branch == "4.0"

    @previous_release_tag = if @level == :minor_or_major
      if @prerelease
        `git describe --tags --abbrev=0`.strip
      else
        "v#{@previous_stable_branch}.0"
      end
    else
      "v#{@stable_branch}.0"
    end

    # The most recent release on this line. For patch releases it bounds the
    # search for backport PRs merged straight onto the stable branch since then.
    @last_release_tag = @level == :patch ? "v#{@stable_branch}.#{segments[2] - 1}" : @previous_release_tag

    rubygems_version = segments.join(".").gsub(/([a-z])\.(\d)/i, '\1\2')
    @rubygems = Rubygems.new(rubygems_version)

    bundler_version = segments.join(".").gsub(/([a-z])\.(\d)/i, '\1\2')
    @bundler = Bundler.new(bundler_version)

    @changelog = Changelog.for_release(rubygems_version)

    @release_branch = "release/#{version}"
  end

  def prepare!
    # `--abbrev-ref` reports the literal "HEAD" on a detached HEAD, which would
    # make the checkouts below silently do nothing.
    initial_branch = `git symbolic-ref --quiet --short HEAD`.strip
    initial_branch = `git rev-parse HEAD`.strip if initial_branch.empty?

    # Refresh the upstream refs first so the release is cut from the latest
    # origin state. A stale local `master` or stable branch would otherwise
    # silently drop PRs merged after the last local fetch.
    system("git", "fetch", "--prune", "origin", exception: true)

    check_git_state!

    unless @prerelease
      create_if_not_exist_and_switch_to(@stable_branch, from: "origin/master")
      system("git", "push", "origin", @stable_branch, exception: true) if @level == :minor_or_major && !ENV["DRYRUN"]
    end

    base_branch = if @level == :minor_or_major && @prerelease
      "master"
    else
      @stable_branch
    end

    # The ref the release branch is cut from. Patch releases and prereleases
    # branch straight off the upstream ref so a stale local copy can't leave
    # commits behind; a new stable branch was just created locally above.
    release_base = if @level == :minor_or_major
      @prerelease ? "origin/master" : @stable_branch
    else
      "origin/#{@stable_branch}"
    end
    create_if_not_exist_and_switch_to(@release_branch, from: release_base)

    changelog_branch_empty = false

    begin
      cherry_pick_pull_requests if @level == :patch

      cut_changelogs_and_bump_versions

      system("git", "push", exception: true) unless ENV["DRYRUN"]

      gh_client.create_pull_request(
        "ruby/rubygems",
        base_branch,
        @release_branch,
        "Prepare RubyGems #{@rubygems.version} and Bundler #{@bundler.version}",
        release_pull_request_body
      ) unless ENV["DRYRUN"]

      # Regenerated from the same pull requests, not cherry-picked. See SubRelease.
      unless @prerelease
        create_if_not_exist_and_switch_to("cherry_pick_changelogs", from: "origin/master")

        cut_changelog!

        if system("git", "diff", "--quiet")
          puts "Changelog on master already matches the regenerated section, skipping its pull request."
          changelog_branch_empty = true
        else
          system("git", "commit", "-am", changelog_commit_message, exception: true)
          system("git", "push", exception: true) unless ENV["DRYRUN"]

          gh_client.create_pull_request(
            "ruby/rubygems",
            "master",
            "cherry_pick_changelogs",
            "Changelog for RubyGems #{@rubygems.version} and Bundler #{@bundler.version}",
            "Changelog for future RubyGems #{@rubygems.version} and Bundler #{@bundler.version}, regenerated on master from the pull requests included in the release."
          ) unless ENV["DRYRUN"]
        end
      end
    rescue StandardError, LoadError
      # A half-written changelog would follow the checkout onto the initial
      # branch and trip the clean tree check on the next run.
      system("git", "checkout", "--", ".")
      system("git", "checkout", initial_branch)
      raise
    end

    # Leaves the operator where they started, and off the branches the cleanup
    # documented in doc/RELEASE.md deletes, since git refuses to delete the
    # branch that is checked out.
    system("git", "checkout", initial_branch, exception: true)

    # An unused branch left behind here would block the next run in `check_git_state!`.
    system("git", "branch", "-D", "cherry_pick_changelogs", exception: true) if changelog_branch_empty
  end

  def check_git_state!
    git_dir = `git rev-parse --absolute-git-dir`.strip
    errors = []

    if File.exist?(File.join(git_dir, "index.lock"))
      errors << "#{git_dir}/index.lock exists. A previous git process may have crashed. Remove it if no git process is running."
    end

    if File.exist?(File.join(git_dir, "CHERRY_PICK_HEAD"))
      errors << "A cherry-pick is in progress. Run `git cherry-pick --abort` to cancel it."
    end

    if File.exist?(File.join(git_dir, "rebase-merge")) || File.exist?(File.join(git_dir, "rebase-apply"))
      errors << "A rebase is in progress. Run `git rebase --abort` to cancel it."
    end

    # The release commits use `git commit -am` and the changelog short-circuit in
    # `prepare!` reads `git diff` over the whole tree, so unrelated local changes
    # would be committed as part of the release.
    unless system("git", "diff", "--quiet") && system("git", "diff", "--cached", "--quiet")
      errors << "The working tree has uncommitted changes. Commit or stash them before running this task."
    end

    branches = [@release_branch]
    branches << "cherry_pick_changelogs" unless @prerelease
    existing = branches.select {|b| system("git", "rev-parse", "--verify", "refs/heads/#{b}", out: IO::NULL, err: IO::NULL) }
    unless existing.empty?
      errors << "Release branches already exist: #{existing.join(", ")}. Please delete them before running this task."
    end

    existing_remote = branches.select {|b| system("git", "rev-parse", "--verify", "refs/remotes/origin/#{b}", out: IO::NULL, err: IO::NULL) }
    unless existing_remote.empty?
      errors << "Release branches already exist on origin: #{existing_remote.map {|b| "origin/#{b}" }.join(", ")}. `git checkout` would silently base work on them instead of the intended branch. Delete them from origin, or run `git fetch --prune origin` if they are already gone."
    end

    # A stale local stable branch, such as one left behind by an earlier DRYRUN
    # run, would be reused and pushed instead of being cut from origin/master.
    if @level == :minor_or_major && !@prerelease
      local_stable = system("git", "rev-parse", "--verify", "refs/heads/#{@stable_branch}", out: IO::NULL, err: IO::NULL)
      remote_stable = system("git", "rev-parse", "--verify", "refs/remotes/origin/#{@stable_branch}", out: IO::NULL, err: IO::NULL)

      if local_stable && !remote_stable
        errors << "Local branch #{@stable_branch} exists but origin/#{@stable_branch} does not. Delete the local branch so the release cuts it from origin/master."
      end
    end

    raise errors.join("\n") unless errors.empty?
  end

  def create_if_not_exist_and_switch_to(branch, from:)
    system("git", "checkout", branch, exception: true, err: IO::NULL)
  rescue StandardError
    system("git", "checkout", "-b", branch, from, exception: true)
  end

  def cherry_pick_pull_requests
    prs = relevant_pull_requests
    raise "No unreleased PRs were found. Make sure to tag them with appropriate labels so that they are selected for backport." unless prs.any?

    # Dedicated backport PRs target the stable branch directly, so they are
    # already on the release branch and only need a changelog entry, not
    # another cherry-pick.
    prs = prs.reject {|pr| already_on_stable_branch?(pr) }

    puts "The following unreleased prs were found:\n#{prs.map {|pr| "* #{pr.html_url}" }.join("\n")}"

    prs.each do |pr|
      args = cherry_pick_args_for(pr)
      next if system("git", "cherry-pick", "-x", *args)

      warn <<~MSG

        Cherry-picking #{pr.html_url} failed. Opening a new shell to fix the errors manually. You can do the following now:

        * If you'd like to include that PR in the release, fix conflicts manually, run `git add . && git cherry-pick --continue` once done, and if it succeeds, run `exit 0` to resume the release preparation.
        * If you don't want to include that PR in the release, run `git cherry-pick --abort` and then `exit 0` to skip it and resume.
        * To abort the entire release preparation, run `exit 1`.

      MSG

      unless system(ENV["SHELL"] || "zsh")
        system("git", "cherry-pick", "--abort")
        raise "Failed to resolve conflicts, resetting original state"
      end
    end
  end

  # Builds the `git cherry-pick` arguments for a PR by detecting which merge
  # strategy GitHub used. PRs merged with "Create a merge commit" are picked
  # with `-m 1` against the merge commit. PRs merged with "Squash and merge"
  # produce a single commit, which is picked directly. PRs merged with
  # "Rebase and merge" produce N linear commits ending at `merge_commit_sha`,
  # so we cherry-pick the full range to avoid silently dropping commits.
  def cherry_pick_args_for(pr)
    sha = pr.merge_commit_sha
    parents = `git rev-list --parents -n 1 #{sha}`.strip.split.drop(1)

    if parents.size >= 2
      ["-m", "1", sha]
    else
      pr_commits = gh_client.pull_request_commits("ruby/rubygems", pr.number)

      if pr_commits.size > 1 && rebase_merged?(sha, pr_commits)
        ["#{sha}~#{pr_commits.size}..#{sha}"]
      else
        [sha]
      end
    end
  end

  def rebase_merged?(sha, pr_commits)
    n = pr_commits.size
    master_subjects = `git log -n #{n} --format=%s #{sha}`.lines.map(&:strip).reverse
    pr_subjects = pr_commits.map {|c| c.commit.message.lines.first.strip }
    master_subjects == pr_subjects
  end

  def cut_changelogs_and_bump_versions
    system("git", "branch", "#{@release_branch}-bkp")

    cut_changelog!
    system("git", "commit", "-am", changelog_commit_message, exception: true)

    @bundler.bump_versions!
    system("bin/rake", "version:update_locked_bundler", exception: true)
    system("git", "commit", "-am", "Bump Bundler version to #{@bundler.version}", exception: true)

    @rubygems.bump_versions!
    system("git", "commit", "-am", "Bump Rubygems version to #{@rubygems.version}", exception: true)
  rescue StandardError
    system("git", "reset", "--hard", "#{@release_branch}-bkp")

    raise
  ensure
    system("git", "branch", "-D", "#{@release_branch}-bkp")
  end

  def cut_changelog!
    changelogs.each do |changelog, entry|
      changelog.cut!(relevant_pull_requests, extra_entry: entry)
    end
  end

  # Creates the single GitHub release covering both RubyGems and Bundler,
  # attached to the unified v#{version} tag.
  def create_for_github!
    tag = "v#{@rubygems.version}"

    options = {
      name: tag,
      body: @changelog.release_notes.join("\n").strip,
      prerelease: @prerelease,
    }
    options[:target_commitish] = @stable_branch unless @prerelease

    gh_client.create_release "ruby/rubygems", tag, **options
  end

  private

  def changelogs
    if legacy_layout?
      [[@bundler.changelog, nil], [@rubygems.changelog, extra_entry]]
    else
      [[@changelog, extra_entry]]
    end
  end

  def legacy_layout?
    File.exist?(File.expand_path("../bundler/CHANGELOG.md", __dir__))
  end

  def changelog_commit_message
    "Changelog for RubyGems and Bundler version #{@rubygems.version}"
  end

  def extra_entry
    "Installs bundler #{@bundler.version} as a default gem"
  end

  def release_pull_request_body
    lines = relevant_pull_requests.map {|pr| "* #{pr.title} [##{pr.number}](#{pr.html_url})" }
    lines.join("\n")
  end

  def relevant_pull_requests
    @relevant_pull_requests ||= begin
      pulls = unreleased_pull_requests.select {|pull| @changelog.labelled?(pull) }.sort_by(&:merged_at)
      add_commit_authors!(pulls)
      pulls
    end
  end

  # A changelog entry credits everyone who committed to the pull request, not
  # only whoever opened it. A listing as wide as the one below cannot carry
  # commits, so they are read here instead, in batches and only for the pull
  # requests that reach the changelog.
  def add_commit_authors!(pulls)
    pulls.each_slice(COMMIT_AUTHOR_BATCH_SIZE) do |batch|
      ids = batch.flat_map {|pull| ["-F", "ids[]=#{pull.node_id}"] }

      json = IO.popen(["gh", "api", "graphql", "-f", "query=#{COMMIT_AUTHORS_QUERY}", *ids], &:read)
      raise "Failed to list the commits of #{batch.map(&:number).join(", ")}" unless Process.last_status.success?

      credit_commit_authors(batch, JSON.parse(json).dig("data", "nodes"))
    end
  end

  def credit_commit_authors(pulls, nodes)
    by_number = pulls.to_h {|pull| [pull.number, pull] }

    nodes.each do |node|
      pull = by_number[node["number"]]
      pull.authors += commit_authors_of(node)
    end
  end

  # Only the authors GitHub resolved to an account. A commit made under an
  # address no account carries names whoever configured that clone, which in
  # practice is a machine account or a local alias rather than a contributor.
  def commit_authors_of(node)
    node.dig("commits", "nodes").flat_map {|commit| commit.dig("commit", "authors", "nodes") }.filter_map do |author|
      user = author["user"]
      next unless user

      # An account carrying no profile name is credited under its commit name.
      name = (user["name"] || author["name"]).to_s.strip

      User.new(name.empty? ? nil : name, user["login"])
    end
  end

  # Pull requests included in this release. `mergeCommit.oid` is the commit a
  # pull request leaves on its base branch under every merge strategy, so
  # intersecting one listing with the local history answers "is this one
  # included?" exactly, in place of a search per commit.
  def unreleased_pull_requests
    @unreleased_pull_requests ||= begin
      head = @level == :minor_or_major ? "HEAD" : "origin/master"
      pulls = pull_requests_merged_into("master", @previous_release_tag, head)

      # Dedicated backport PRs target the stable branch instead of master, so
      # the listing above cannot see them and their changelog entries would
      # otherwise be dropped from the release.
      pulls += pull_requests_merged_into(@stable_branch, @last_release_tag, "origin/#{@stable_branch}") if @level == :patch

      pulls.reject! {|pull| released_commit_shas.include?(pull.merge_commit_sha) } if @level == :patch

      pulls
    end
  end

  # Runs a git command whose failure the caller handles itself, so git's own
  # diagnosis stays out of the output. The array form keeps this off the
  # shell, where a redirect would not be portable.
  def git_quietly(*args)
    IO.popen(["git", *args], err: IO::NULL, &:read)
  end

  def pull_requests_merged_into(base, from, to)
    commits = git_quietly("rev-list", "#{from}..#{to}")
    raise "Failed to list the commits in #{from}..#{to}" unless Process.last_status.success?

    reachable = Set.new(commits.split("\n"))

    merged_pull_requests(base, from).select {|pull| reachable.include?(pull.merge_commit_sha) }
  end

  # The date bound is deliberately loose. It bounds the query, not the result.
  def merged_pull_requests(base, since_ref)
    committed_at = git_quietly("log", "-1", "--format=%cI", since_ref).strip
    raise "Failed to resolve #{since_ref}" unless Process.last_status.success?

    since = (Time.iso8601(committed_at) - 86_400).utc.strftime("%Y-%m-%d")

    json = `gh pr list --repo ruby/rubygems --state merged --base #{base} --search 'merged:>=#{since}' --limit #{MERGED_PULL_REQUEST_LIMIT} --json number,id,title,labels,mergeCommit,mergedAt,author,url`
    raise "Failed to list pull requests merged into #{base} since #{since}" unless Process.last_status.success?

    pull_requests_from(json, "#{base} since #{since}")
  end

  def pull_requests_from(json, window)
    records = JSON.parse(json)

    if records.size >= MERGED_PULL_REQUEST_LIMIT
      raise "More than #{MERGED_PULL_REQUEST_LIMIT} pull requests were merged into #{window}, so the listing is truncated. Split the query into narrower date ranges."
    end

    # GitHub reports no merge commit for a pull request whose merge commit is
    # gone, and a commit that is gone is never reachable.
    records.reject {|record| record["mergeCommit"].nil? }.map {|record| build_pull_request(record) }
  end

  def build_pull_request(record)
    author = record["author"]
    # `gh` reports a missing author name as an empty string, while the changelog
    # entry template expects to fall back to the login when there is none.
    name = author["name"]
    # `gh` writes an app account's login as `app/<name>`, while the commits of
    # that account carry the `<name>[bot]` form, so the two records of one
    # account only meet once this is rewritten.
    login = author["login"]
    login = "#{login.delete_prefix("app/")}[bot]" if author["is_bot"]

    PullRequest.new(
      record["number"],
      record["id"],
      record["title"],
      record["url"],
      record["labels"].map {|label| Label.new(label["name"]) },
      Time.iso8601(record["mergedAt"]),
      [User.new(name.to_s.empty? ? nil : name, login)],
      record["mergeCommit"]["oid"]
    )
  end

  # True when the PR's merged commit is already reachable from the release
  # branch, e.g. a backport PR merged straight onto the stable branch rather
  # than cherry-picked from master.
  def already_on_stable_branch?(pr)
    system("git", "merge-base", "--is-ancestor", pr.merge_commit_sha, "HEAD", out: IO::NULL, err: IO::NULL)
  end

  # Source SHAs already cherry-picked onto the stable branch, derived from the
  # `(cherry picked from commit X)` footer that `git cherry-pick -x` records.
  # When the footer references a merge commit (PRs merged with "Create a merge
  # commit", picked with `-m 1`), also include the individual PR commits the
  # merge introduced, so that a pull request is recognized as released no
  # matter which of its commits the footer names.
  def released_commit_shas
    @released_commit_shas ||= begin
      log = `git log --format=%B #{@previous_release_tag}..origin/#{@stable_branch}`
      shas = Set.new
      log.scan(/cherry picked from commit ([0-9a-f]+)/).flatten.each do |sha|
        shas << sha
        parents = git_quietly("rev-list", "--parents", "-n", "1", sha).strip.split.drop(1)
        next unless parents.size >= 2
        shas.merge(`git log --format=%H #{parents[0]}..#{parents[1]}`.split("\n"))
      end
      shas
    end
  end
end
