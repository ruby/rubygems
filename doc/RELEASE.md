# Release

## Release guidelines

**tl;dr**: Majors about once per three or four years, minor releases about once per year, and both types require all features to be complete and fully documented, patches for any committed bugfix.

Patch (bugfix) releases should generally be cut as soon as possible. A patch release for a single bugfix PR is totally okay.

Minor (feature) releases can be cut anytime at least one new feature is ready, but don't have to be. Minor version releases must update their major version's man pages and docs website as needed, and should each have their own "What's new?" section.

Major (breaking) version releases should be cut no more than once per three or four years, and must include a new section of the docs website dedicated to that major version. Ideally, major releases will happen after a Ruby version loses support in February or March, to help us stay in sync with Ruby versions supported by the Ruby core team.

Breaking changes other than dropping support for old Ruby versions should be avoided whenever possible, but may be included in major releases. In general, breaking changes should include at least one major version (and one year elapsed) with a deprecation warning before the breaking change takes effect.

### User experience guidelines

The experience of using RubyGems and Bundler should not include surprises. If users are surprised, we did something wrong, and we should fix it. There are no user errors, only UX design failures. Warnings should always include actionable instructions to resolve them. Errors should include instructions, helpful references, or other information to help users attempt to debug.

Changing existing behavior is also surprising. If reducing user surprise will result in a backwards-incompatible change, that change should include at least one major version of deprecation warning before the breaking change is made.

## Release Process

### Permissions

You'll need the following environment variables set to release RubyGems and Bundler:

* AWS_PROFILE: to be able to push RubyGems zip files to s3 so that they appear at RubyGems [download page]. This profile is provided by AWS SSO credentials that is managed by Ruby Central.

* GITHUB_RELEASE_PAT: A [GitHub PAT] with repo permissions, in order to push GitHub releases and to use the GitHub API for changelog generation.

[download page]: https://rubygems.org/pages/download
[GitHub PAT]: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token

### Recommendations for security releases

*   Obtain CVE numbers as needed from HackerOne or GitHub.
*   Agree on a release date with ruby-core, so patches can be backported to older Ruby versions as needed.
*   Avoid releasing security updates on Fridays, so platform services don't have to work on weekends.
*   Continue with the regular release process below.

### Branching

Bundler releases are synchronized with rubygems releases at the moment. That means that releases for both share the same stable branch, and they should generally happen together.

The current conventional naming for stable branches is `x+1.y`, where `x.y` is the version of `bundler` that will be released. This is because `rubygems-x+1.y` will be released at the same time.

For example, `rubygems-3.2.0` and `bundler-2.2.0` were both released from the `3.2` stable branch.

Once a stable branch has been cut from `master`, changes for that minor release series are only made _intentionally_, via patch releases. That is to say, changes to `master` by default _won't_ make their way into the current stable branch, and development on `master` will be targeting the next minor or major release.

There is a `bin/rake prepare_release[<target_rubygems_version>]` rake task that helps with creating a release. It takes a single argument, the _exact rubygems release_ being made (e.g.  `3.2.3` when releasing bundler `2.2.3`). This task checks out the appropriate stable branch (`3.2`, for example), grabs all merged but unreleased PRs from both bundler & rubygems from GitHub that are compatible with the target release level, and then cherry-picks those changes (and only those changes) to a new branch based off the stable branch. Then bumps the version in all version files, updates the changelog to include all backported changes and commits that change on top of the cherry-picks.

Note that this task requires all user facing pull requests to be tagged with specific labels. See [Merging a PR](PULL_REQUESTS.md#merging-a-pr) for details.

Also note that when this task cherry-picks, the strategy depends on how the PR was merged on GitHub. PRs merged with "Create a merge commit" are cherry-picked using `git cherry-pick -m 1 MERGE_COMMIT_SHA` against the merge commit. PRs merged with "Squash and merge" are cherry-picked directly against their single commit. PRs merged with "Rebase and merge" are cherry-picked as a range covering all of the rebased commits, so that none of them is silently dropped.

After running the task, you'll have a release branch ready to be merged into the stable branch. You'll want to open a PR from this branch into the stable branch and provided CI is green, you can go ahead, merge the PR and run release tasks as specified below from the updated stable branch.

### Automatic changelog and backport generation

PR labels and titles are used to automatically generate changelogs for patch and minor releases.

When releasing, a changelog generation script goes through all PRs that have never made it into a release, and selects only the ones with specific labels as detailed in the `.changelog.yml` file. Those particular PRs get backported to the stable branch and included in the release changelog. Labels of the same library must all map to the same section, because the release task refuses a PR whose labels for one library point at different changelog sections.

RubyGems and Bundler share a single `CHANGELOG.md`. From 4.0.0 on, a release section groups its entries under a `### RubyGems` and a `### Bundler` heading, so a PR labelled for both libraries is listed under both. A library with no entries of its own gets no heading. A minor release leaves out the entries a library already carried in a lower release still listed in the file, and says so under that library's heading.

The 4.0 release branch still keeps a separate `bundler/CHANGELOG.md`, and the release task cuts both changelogs there, so the reviewer of a 4.0.x release PR has to check both. `prepare_release` builds the changelog objects before it checks out the release branch, so even a 4.0.x release goes through master's tooling and master's `.changelog.yml`. Re-running `rake generate_changelog` from the release branch, as described under Release below, runs that branch's own tooling and configuration instead.

If PRs don't have a proper label, they won't be backported to patch releases.

If you want a PR to be backported to a patch level release, but don't want to include it in the changelog, you can use the special `rubygems: skip changelog` and `bundler: skip changelog` labels. For example, this is useful when backporting a PR generates conflicts that are solved by backporting another PR with no user visible changes. You can use these special labels to also backport the other PR and not get any conflicts.

### Breaking changes

Bundler cares a lot about preserving compatibility. As a result, changes that break backwards compatibility should (whenever this is possible) include a feature release that is backwards compatible, and issue warnings for all options and behaviors that will change.

We only release major breaking changes when incrementing the _major_ version of Bundler and RubyGems. However, experience shows that almost every single part of Bundler and RubyGems is depended on by someone in ways hard to anticipate. So if we were strict about breaking changes we'd need to hold on from making progress a lot, or continuously increment the major version, emptying "really major" versions from their meaning. Because of this, we also may release "small" breaking changes in minor releases. "Small" here means that we expect them to affect only very few users in rare cases.

### Steps for patch releases

#### Preparation

*   Confirm all PRs that you want backported are properly tagged with `rubygems: <type>` or `bundler: <type>` labels at GitHub.
*   Confirm to set `AWS_PROFILE` and `GITHUB_RELEASE_PAT` environment variables.

#### Release

*   Run `DRYRUN=1 bin/rake prepare_release[<target_rubygems_version>]` to verify that everything is working as expected. The dry run still creates the `release/<target_rubygems_version>` and `cherry_pick_changelogs` branches locally, so delete them with `git branch -D release/<target_rubygems_version> cherry_pick_changelogs` before the real run, which otherwise stops with "Release branches already exist". A prerelease never creates `cherry_pick_changelogs`, and a run that found nothing to open a changelog pull request for deletes it on its own, so the error about that branch missing can be ignored.
*   Run `bin/rake prepare_release[<target_rubygems_version>]`, this will:
    *  Create a PR to the stable branch with the backports included in the release.
    *  Generate the changelog and version bumps. It will also create a PR that adds the release section to the changelog on master.
*   If you need to make any manual changes, do so in the release PR created above and re-run `rake generate_changelog[<target_rubygems_version>]` to update the changelog and run `git rebase -i` as needed. `prepare_release` leaves you on the branch you started from, so run `git checkout release/<target_rubygems_version>` before the re-run. Re-running rebuilds that version section from the pull requests and discards manual edits to it, so hand edits to the changelog belong after the last re-run. Finally, force push the release PR branch.
*   Once CI passes, merge the release PR, switch to the stable branch and pull the PR just merged.
*   Release `rubygems` with `bin/rake release`.
*   Release `bundler` with `bin/rake bundler:release`.

#### Post-release

* Merge the changelog PR created above into master. `prepare_release` skips that pull request when master already contains an identical section, and says so on its output.

### Steps for minor and major releases

#### Preparation

*   Confirm all PRs that you want listed in changelogs are properly tagged with `rubygems: <type>` or `bundler: <type>` labels at GitHub.
*   Confirm to set `AWS_PROFILE` and `GITHUB_RELEASE_PAT` environment variables.

#### Release

*   Run `DRYRUN=1 rake prepare_release[4.0.0.beta3]` to verify that everything is working as expected. It leaves the `release/4.0.0.beta3` branch behind, so delete it before the real run, which otherwise stops with "Release branches already exist".
*   Run `rake prepare_release[4.0.0.beta3]`, this will:
    * Create the release branch like `release/4.0.0.beta3`.
    * Bump up version number at `lib/rubygems.rb` and `lib/bundler/version.rb`.
    * Run `rake version:update_locked_bundler`.
    * Run `rake generate_changelog[4.0.0.beta3]`.
    * Push the release branch and open a PR to the stable or master branch
*   Run `DRYRUN=1 rake release` to verify that everything is working as expected. And confirm to CI passes on the release PR.
*   Release `rubygems` with `bin/rake release`, this will:
    * Run `rake check_deprecations` and package `rubygems-update` gem.
    * Tag the release like `v4.0.0.beta3` and push the tag to GitHub.
    * Push `rubygems-update-4.0.0.beta3` to RubyGems.org.
    * Upload RubyGems tgz and zip files to s3 and create a single GitHub release covering both RubyGems and Bundler.
    * Update the guides website and blog posts of rubygems.org.
*   Release `bundler` with `bin/rake bundler:release`.
    * Package `bundler` gem and run `rake man:check`.
    * Push `bundler-4.0.0.beta3` to RubyGems.org. No separate tag or GitHub release is created for Bundler.

#### Post-release

*   Merge the changelog PR created above into master. That PR is only created for a final release, because a prerelease adds its changelog section to master through the release PR itself. It is also skipped when master already contains an identical section.

The following changes are needed to prepare for the next development cycle:

*   Replace version numbers with the next ".dev" version.
*   Run `rake version:update_locked_bundler`, and push that change to the master PR.
*   Once CI passes, merge the release PR, switch to  the stable branch and pull the PR just merged.
