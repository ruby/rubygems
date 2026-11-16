# ruby/rubygems Policies

This document is an attempt to record the policies and processes that are used to govern this project--it's not fixed or permanent, and will likely evolve as events warrant.

## Our Goals

0. Treat everyone like a valuable human being, worthy of respect and empathy. No exceptions.
1. Strive to empower users, the Ruby developers who use RubyGems and Bundler. For example, there is no such thing as user error, only insufficient UX design.
2. Strive to empower contributors, as long as it does not harm users. For example, potential contributors should be able to set up a complete development and testing environment with a single command.
3. Strive to empower maintainers, as long as it does not harm contributors or users. For example, automating issue triage to reduce repetitive work for maintainers, as long as users with problems are not worse off.

These policies are intended to be examples of how to apply these goals, and we realize that we can't possibly cover every edge case or loophole. In any case where policies turn out to conflict with these goals, the goals should win.

## Issue guidelines

Anyone is welcome to open an issue, or comment on an issue. Issue comments without useful content (like “me too”) may be removed.

Opening an issue to ask for help may eventually get you help, but chances are help will arrive faster if you post on [Stack Overflow](https://stackoverflow.com)

Issues will be handled as soon as possible, which may take some time. Including a script that can be used to reproduce your issue is a great way to help maintainers help you. If you can, writing a failing test for your issue is even more helpful.

## Contribution and pull request guidelines

Contributions to RubyGems are made via GitHub pull requests, which must be
approved by a project committer other than the author. To approve a PR, a
maintainer can use GitHub's PR review feature. After that, if the original author
is happy to merge the PR, they can press the merge button.

Anyone is welcome to [contribute](../CONTRIBUTING.md). Contributed code will be released under the same license as the existing codebase.

Pull requests must have passing tests to be merged. Code changes must also include tests for the new behavior. Squashing commits is not required.

Every pull request should explain:

1. The problem being solved
2. Why that problem is happening
3. What changes to fix that problem are included in the PR, and
4. Why that implementation was chosen out of the possible options.

## Long-Term Support

### Ruby Version Support

Both RubyGems and Bundler support Ruby versions for as long as the Ruby team supports them, as [listed here](https://www.ruby-lang.org/en/downloads/branches/). When a Ruby version reaches end-of-life, the following minor release of RubyGems/Bundler will drop backwards compatibility with that Ruby version.

We also support the latest stable versions of JRuby and TruffleRuby, and constantly evaluate changes in Ruby implementation usage to potentially support more implementations.

### Version Support and Releases

The team ships features and bugfixes for the latest minor version. From 4.0 on, older minor series also get bug fixes, documentation fixes and security fixes backported from the main branch.

Security releases will be made for RubyGems and Bundler versions that were included in a currently-supported Ruby release. For example, if a version was shipped with a Ruby release, it will receive security fixes until that Ruby version reaches end-of-life.

We generally release bugfixes from the main branch. Releases of the latest minor version may mix bug fixes and new features, while older series get only the fixes above.

These policies are not a guarantee that any particular fix will be backported. Instead, this is a way for us to set an upper limit on the versions of Ruby, RubyGems, and Bundler that we have to consider while making changes. Without the limit, the number of versions grows exponentially over time and quickly becomes overwhelming, which leads to maintainer burnout. We want to avoid that.

### Backwards Compatibility

We strive for backwards compatibility. Infrastructure should be as unsurprising as possible, so if something worked in version 1.x, it should continue to work in 1.y and 1.z. Changes in major versions (e.g., 1.x to 2.x) may not maintain full backwards compatibility. We may not always get it right, and there may be extenuating circumstances that force us into choosing between different kinds of breakage, but compatibility is very important to us.

In general, this is what we consider as "public API":

* The `gem` and `bundle` CLIs. Flags and commands will never be removed without
  deprecation, but we may change the specific output of certain commands without
  notice, unless a `--parseable` or equivalent flag is given. Don't rely on
  empty error output when checking success, since progress
  may be logged to stderr. Instead, check the exit status of the command.

* The documented Gemfile DSL (both methods and their options).

* The lockfile format. We may introduce slight changes in new lockfiles, but
  we'll keep being able to read what we previously generated and we'll keep it
  the same by default and instead provide explicit tools to upgrade existing
  lockfiles to new formats.

* Any documented methods in the RubyGems and Bundler namespaces, like
  `Bundler.with_original_env` and similar.

* Actual APIs meant to be used by other libraries, like the plugin API.

* Entrypoints different from the CLI, like `bundler/setup` or
  `bundler/inline`.

We will never intentionally break any of the above in patch or minor releases.

Internal classes and their methods (public or private) are not considered public
API, but we are aware that they are used in many places. So we try
not to break internal functionality that may be used by others, including proactively
using code search tools in public code. That said, we may not always be able to
avoid breaking things, and we may even intentionally introduce this kind of
"breakage" in a minor release if we deem it affects very few users or edge
cases. So be aware when using internals and ideally get in touch with us
before doing so, so that we can help find the right APIs.

## Discussing large changes

Large changes often benefit from being written out more completely, read by others, and discussed. [GitHub Discussions](https://github.com/ruby/rubygems/discussions) is the preferred place for that to happen.

## Committer Access

Committers may lose their commit privileges if they are inactive for longer than 12 months. Committer permission may be restored upon request by having a pull request merged.

This is designed to improve project maintainability by requiring committers to maintain familiarity with current development activity and to improve security by preventing idle committers from having their commit permissions compromised or exposed.

Always create pull requests rather than pushing directly to the primary branch. Try to get code review and merge approval from someone other than yourself whenever possible.

Contributors who have contributed regularly for more than six months (or implemented a completely new feature for a minor release) are eligible to join the maintainer team. Unless vetoed by an existing maintainer, these contributors will be asked to join the maintainer team. If they accept, new maintainers will be given permissions to view maintainer playbooks, accept pull requests, and release new versions.

## Enforcement guidelines

First off, these policies and their enforcement are subsidiary to the [code of conduct](https://github.com/ruby/rubygems/blob/master/CODE_OF_CONDUCT.md) in any case where they conflict. The first priority is treating human beings with respect and empathy, and figuring out project guidelines and sticking to them will always come after that.

When it comes to carrying out our own policies, we're all regular humans trying to do the best we can. There will probably be times when we don't stick to our policies or goals. If you notice a discrepancy between real-life actions and these policies and goals, please bring it up! We want to make sure that our actions and our policies line up, and that our policies exemplify our goals.

Policies are not set in stone, and may be revised if policy violations are found to be in the spirit of the project goals. Likewise, actions that violate the spirit of the project goals will be considered policy violations, and enforcement action will be taken. We're not interested in rules-lawyering, and we will take action when needed to ensure that everyone feels safe and included.

Please report policy violations by email to conduct@rubygems.org. Anyone violating a policy or goal is expected to cooperate with the team (and the reporter, if they request it) to resolve the issue in a way that follows the project goals.

## Team changes

### Adding a new team member

Interested in adding someone to the team? Here's the process.

1. An existing team member nominates a potential team member to the rest of the team.
2. The existing team reaches consensus about whether to invite the potential member.
3. The nominator asks the potential member if they would like to join the team.
4. The nominator also sends the candidate a link to [POLICIES](POLICIES.md) as an orientation for being on the team.
5. If the potential member accepts:
    - Add them to the [maintainers list][team]

### Removing a team member

When team members choose to retire, here's how to remove someone from the team.

- Remove them from the [maintainers list][team]

## Changing These Policies

These policies were set in order to reduce the burden of maintenance and to keep
committers current with existing development and policies. RubyGems work is
primarily volunteer-driven which limits the ability to provide long-term
support. By joining [Ruby Central](https://rubycentral.org/#/portal/signup) you
can help extend support for older RubyGems versions.

[team]: https://guides.rubygems.org/contributing/#core-projects
