# Submitting Pull Requests

Before you submit a pull request, please remember to do the following:

1. Check your code format and style
2. Run the test suite
3. Use a meaningful commit message without tags

## Code formatting

Make sure the code formatting and styling adheres to the guidelines. We use RuboCop for this. Lack of formatting adherence will result in automatic GitHub Actions build failures.

      $ bin/rake rubocop

## Tests

Prior to submitting your PR, please run the test suite:

      $ bin/parallel_rspec

If you are unable to run the entire test suite, please run the unit test suite and at least the integration specs related to the command or domain of Bundler that your code changes relate to.

Ex. For a pull request that changes something with `bundle update`, you might run:

      $ bin/rspec spec/bundler
      $ bin/rspec spec/commands/update_spec.rb

## Commit messages

Please ensure that the commit messages included in the pull request __do not__ have the following:
  - `@tag` GitHub user or team references (ex. `@hsbt`)
  - `#id` references to issues or pull requests (ex. `#43` or `rubygems/guides#12`)

If you want to use these mechanisms, please instead include them in the pull request description. This prevents multiple notifications or references being created on commit rebases or pull request/branch force pushes.

Additionally, do not use `[ci skip]` or `[skip ci]` mechanisms in your pull request titles/descriptions or commit messages. Every potential commit and pull request should run through Bundler's CI system. This applies to all changes/commits (ex. even a change to just documentation or the removal of a comment).

## Merging a PR

Bundler requires all CI status checks to pass before a PR can me merged. So make
sure that's the case before merging.

Also, bundler manages the changelog automatically using information from merged
PRs. So, if a PR has user visible changes that should be included in a future
release, make sure the following information is accurate:

* The PR has a good descriptive title. That will be the wording for the
  corresponding changelog entry.

* The PR has an accurate label. If a PR is to be included in the changelog since
  it has user visible changes, the label must be one of the following:

  * "rubygems: feature" / "bundler: feature"
  * "rubygems: performance" / "bundler: performance"
  * "rubygems: enhancement" / "bundler: enhancement"
  * "rubygems: bug fix" / "bundler: bug fix"
  * "rubygems: security" / "bundler: security"
  * "rubygems: breaking change" / "bundler: breaking change"
  * "rubygems: deprecation" / "bundler: deprecation"
  * "rubygems: documentation" / "bundler: documentation"

  A PR labelled for both libraries is listed under both, so the two labels do
  not have to be of the same category. A "skip changelog" label for one library
  leaves the entry under the other library only.

  Each label indicates the section in the changelog that the PR will take for
  its library, and the labels are also automatically used by our release tasks
  for backporting. Two category labels for the same library must map to the
  same section, or a minor or major release stops. A patch release only looks
  at the patch level labels, so a label outside that set is ignored there
  instead of clashing. A "skip changelog" label next to a category label for
  the same library is allowed, and the category label wins.
  The labels that should be backported only to patch level releases, and to
  either patch level or minor releases can be configured in the `.changelog.yml`
  file.

  If for some reason you need a PR to be backported to a stable branch, but it
  doesn't have any user visible changes, apply the "rubygems: skip changelog" or
  "bundler: skip changelog" label to it so that our release scripts know about
  that.

Finally, don't forget to review the changes in detail. Make sure you try them
locally if they are not trivial and make sure you request changes and ask as
many questions as needed until you are convinced that including the changes into
bundler is a strict improvement and will not make things regress in any way.
