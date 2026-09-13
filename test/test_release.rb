# frozen_string_literal: true

require "tmpdir"

require_relative "../tool/release"
require_relative "rubygems/helper"

class ReleaseTest < Test::Unit::TestCase
  def test_pull_requests_from_maps_a_listing_record_to_the_fields_the_changelog_uses
    pull = release.send(:pull_requests_from, listing([record]), "master since 2026-01-01").first

    assert_equal 9852, pull.number
    assert_equal "PR_kwDOAAlets8AAAABBxIb1Q", pull.node_id
    assert_equal "Let the gem and bundle cooldown settings cover each other", pull.title
    assert_equal "https://github.com/ruby/rubygems/pull/9852", pull.html_url
    assert_equal ["bundler: bug fix"], pull.labels.map(&:name)
    assert_equal Time.utc(2026, 9, 4, 2, 23, 29), pull.merged_at
    assert_equal [Release::User.new("Hiroshi SHIBATA", "hsbt")], pull.authors
    assert_equal "0602168df08a985b635ea24fb80f9048465f9530", pull.merge_commit_sha
  end

  def test_pull_requests_from_falls_back_to_the_login_when_the_author_has_no_name
    json = listing([record("author" => { "login" => "someone", "name" => "" })])

    pull = release.send(:pull_requests_from, json, "master since 2026-01-01").first

    assert_equal [Release::User.new(nil, "someone")], pull.authors
  end

  def test_pull_requests_from_credits_an_app_account_under_the_login_its_commits_carry
    json = listing([record("author" => { "login" => "app/dependabot", "name" => "", "is_bot" => true })])

    pull = release.send(:pull_requests_from, json, "master since 2026-01-01").first

    assert_equal [Release::User.new(nil, "dependabot[bot]")], pull.authors
  end

  def test_credit_commit_authors_credits_them_after_the_pull_request_author
    pull = release.send(:pull_requests_from, listing([record]), "master since 2026-01-01").first

    credit(pull, [[github_author("Jenny Shen", "jenshenny")], [github_author("Gira Chawda", "girachawda")]])

    assert_equal [
      Release::User.new("Hiroshi SHIBATA", "hsbt"),
      Release::User.new("Jenny Shen", "jenshenny"),
      Release::User.new("Gira Chawda", "girachawda"),
    ], pull.authors
  end

  def test_credit_commit_authors_skips_an_author_with_no_github_account
    pull = release.send(:pull_requests_from, listing([record]), "master since 2026-01-01").first

    credit(pull, [[{ "name" => "License Update", "user" => nil }]])

    assert_equal [Release::User.new("Hiroshi SHIBATA", "hsbt")], pull.authors
  end

  def test_credit_commit_authors_names_an_account_with_no_profile_name_from_its_commit
    pull = release.send(:pull_requests_from, listing([record]), "master since 2026-01-01").first

    credit(pull, [[{ "name" => "  Ali Firas  ", "user" => { "login" => "thesmartshadow", "name" => nil } }]])

    assert_equal [
      Release::User.new("Hiroshi SHIBATA", "hsbt"),
      Release::User.new("Ali Firas", "thesmartshadow"),
    ], pull.authors
  end

  def test_pull_requests_from_refuses_a_truncated_listing
    json = listing(Array.new(Release::MERGED_PULL_REQUEST_LIMIT) { record })

    error = assert_raise(RuntimeError) do
      release.send(:pull_requests_from, json, "master since 2026-01-01")
    end

    assert_include error.message, "truncated"
  end

  def test_pull_requests_from_skips_a_pull_request_whose_merge_commit_is_gone
    json = listing([record, record("number" => 1, "mergeCommit" => nil)])

    pulls = release.send(:pull_requests_from, json, "master since 2026-01-01")

    assert_equal [9852], pulls.map(&:number)
  end

  def test_pull_requests_merged_into_keeps_only_the_ones_whose_merge_commit_landed
    in_a_repo_with_two_commits do |first, second|
      json = listing([
        record("number" => 1, "mergeCommit" => { "oid" => second }),
        record("number" => 2, "mergeCommit" => { "oid" => first }),
      ])
      pulls = release.send(:pull_requests_from, json, "master since 2026-01-01")

      release.stub(:merged_pull_requests, pulls) do
        assert_equal [1], release.send(:pull_requests_merged_into, "master", first, second).map(&:number)
      end
    end
  end

  def test_pull_requests_merged_into_fails_when_the_range_does_not_resolve
    error = assert_raise(RuntimeError) do
      release.send(:pull_requests_merged_into, "master", "no-such-ref-for-a-test", "HEAD")
    end

    assert_include error.message, "no-such-ref-for-a-test..HEAD"
  end

  def test_merged_pull_requests_fails_when_the_bounding_ref_does_not_resolve
    error = assert_raise(RuntimeError) do
      release.send(:merged_pull_requests, "master", "no-such-ref-for-a-test")
    end

    assert_include error.message, "no-such-ref-for-a-test"
  end

  private

  # A minor release, so that the constructor derives the previous release tag
  # from the version instead of shelling out to `git describe`.
  def release
    @release ||= Release.new("4.1.0")
  end

  # `pull_requests_merged_into` resolves its range against the working
  # directory, and CI checks out with no history to resolve one against.
  def in_a_repo_with_two_commits
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        git("init")
        git("commit", "--allow-empty", "-m", "first")
        first = `git rev-parse HEAD`.strip
        git("commit", "--allow-empty", "-m", "second")

        yield first, `git rev-parse HEAD`.strip
      end
    end
  end

  def git(*args)
    system(
      "git", "-c", "user.name=Release Test", "-c", "user.email=test@example.com", "-c", "commit.gpgsign=false",
      *args, out: IO::NULL, err: IO::NULL, exception: true
    )
  end

  def listing(records)
    JSON.dump(records)
  end

  def credit(pull, commits)
    node = {
      "number" => pull.number,
      "commits" => { "nodes" => commits.map {|authors| { "commit" => { "authors" => { "nodes" => authors } } } } },
    }

    release.send(:credit_commit_authors, [pull], [node])
  end

  def github_author(name, login)
    { "name" => name, "user" => { "login" => login, "name" => name } }
  end

  def record(overrides = {})
    {
      "number" => 9852,
      "id" => "PR_kwDOAAlets8AAAABBxIb1Q",
      "title" => "Let the gem and bundle cooldown settings cover each other",
      "url" => "https://github.com/ruby/rubygems/pull/9852",
      "labels" => [{ "name" => "bundler: bug fix" }],
      "mergedAt" => "2026-09-04T02:23:29Z",
      "author" => { "login" => "hsbt", "name" => "Hiroshi SHIBATA" },
      "mergeCommit" => { "oid" => "0602168df08a985b635ea24fb80f9048465f9530" },
    }.merge(overrides)
  end
end
