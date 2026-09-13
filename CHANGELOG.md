# Changelog

Bundler's changelog before 4.0.0, when it was versioned separately from RubyGems, is in [doc/CHANGELOG-bundler-2.x.md](https://github.com/ruby/rubygems/blob/master/doc/CHANGELOG-bundler-2.x.md).

## 4.1.0.beta1 / 2026-09-09

### RubyGems

Changes already released in 4.0.x are not repeated here.

#### Features:

* Add content addressable gems support. Pull request [#9773](https://github.com/ruby/rubygems/pull/9773) by Jenny Shen, Harriet Oughton and Gira Chawda
* Let the gem and bundle cooldown settings cover each other. Pull request [#9852](https://github.com/ruby/rubygems/pull/9852) by Hiroshi SHIBATA
* Rubygems: Add PQC ML-DSA support for cryptographically signed gems workflow. Pull request [#9697](https://github.com/ruby/rubygems/pull/9697) by Jun Aruga, Kazuki Yamaguchi and Hiroshi SHIBATA
* Preserve non-UTF-8 legacy gem metadata. Pull request [#9835](https://github.com/ruby/rubygems/pull/9835) by Stanislav (Stas) Katkov
* Add an opt-in OS credential store for gem and bundler credentials. Pull request [#9671](https://github.com/ruby/rubygems/pull/9671) by Hiroshi SHIBATA
* Add --cooldown to gem install, update and outdated. Pull request [#9734](https://github.com/ruby/rubygems/pull/9734) by Hiroshi SHIBATA
* Adopt the compact index for gem commands. Pull request [#9606](https://github.com/ruby/rubygems/pull/9606) by Hiroshi SHIBATA
* Replace Molinillo with PubGrub for dependency resolution. Pull request [#9402](https://github.com/ruby/rubygems/pull/9402) by Matt Larraz and Colby Swandale
* Replace the rubygems-specific lockfile parser with Bundler's parser. Pull request [#9564](https://github.com/ruby/rubygems/pull/9564) by Hiroshi SHIBATA
* Remove pessimistic versioning in gem command output. Pull request [#9550](https://github.com/ruby/rubygems/pull/9550) by Jeremy Evans
* Change Gem::Version#approximate_recommendation to be optimistic. Pull request [#9537](https://github.com/ruby/rubygems/pull/9537) by Jeremy Evans
* Add `--no-build-extension` and `--no-install-plugin` options to gem install. Pull request [#9473](https://github.com/ruby/rubygems/pull/9473) by Hiroshi SHIBATA
* Push with auto-attestation. Pull request [#9325](https://github.com/ruby/rubygems/pull/9325) by Hiroshi SHIBATA
* Implement yaml parser written by pure ruby instead of Psych. Pull request [#9352](https://github.com/ruby/rubygems/pull/9352) by Hiroshi SHIBATA
* Honor concurrent_downloads from .gemrc in Gem::ConfigFile. Pull request [#9339](https://github.com/ruby/rubygems/pull/9339) by Andrii Furmanets
* Add support for custom error response from external registries. Pull request [#9270](https://github.com/ruby/rubygems/pull/9270) by Luis J. Gonzalez
* Add global gem cache shared by RubyGems and Bundler. Pull request [#9230](https://github.com/ruby/rubygems/pull/9230) by Anthony Panozzo
* Write gem files atomically. Pull request [#9154](https://github.com/ruby/rubygems/pull/9154) by Eileen

#### Performance:

* Remove `verify_gz`. Pull request [#9093](https://github.com/ruby/rubygems/pull/9093) by Eileen

#### Enhancements:

* Normalize absolute symlink targets during gem extraction. Pull request [#9860](https://github.com/ruby/rubygems/pull/9860) by Hiroshi SHIBATA
* Installs bundler 4.1.0.beta1 as a default gem.

#### Breaking changes:

* Stop installing native extension build logs. Pull request [#9700](https://github.com/ruby/rubygems/pull/9700) by Hiroshi SHIBATA
* Remove Gem::BasicSpecification#datadir and check minor-release deprecation horizons. Pull request [#9842](https://github.com/ruby/rubygems/pull/9842) by Hiroshi SHIBATA
* Raise an error when building a gem that has a self reference. Pull request [#9392](https://github.com/ruby/rubygems/pull/9392) by Edouard CHIN
* Revert `DEFAULT_INSTALL_EXTENSION_IN_LIB` and warn `require_relative` with C ext. Pull request [#9390](https://github.com/ruby/rubygems/pull/9390) by Hiroshi SHIBATA
* Remove deprecated and unused `Gem::List`. Pull request [#9161](https://github.com/ruby/rubygems/pull/9161) by Hiroshi SHIBATA

### Bundler

Changes already released in 4.0.x are not repeated here.

#### Features:

* Add content addressable gems support. Pull request [#9773](https://github.com/ruby/rubygems/pull/9773) by Jenny Shen, Harriet Oughton and Gira Chawda
* Let the gem and bundle cooldown settings cover each other. Pull request [#9852](https://github.com/ruby/rubygems/pull/9852) by Hiroshi SHIBATA
* Add a `prune` setting to drop rebuildable install artifacts. Pull request [#9815](https://github.com/ruby/rubygems/pull/9815) by Hiroshi SHIBATA
* Add an opt-in OS credential store for gem and bundler credentials. Pull request [#9671](https://github.com/ruby/rubygems/pull/9671) by Hiroshi SHIBATA
* Fetch Bundler metadata through Gem::Request instead of net-http-persistent. Pull request [#9786](https://github.com/ruby/rubygems/pull/9786) by Hiroshi SHIBATA
* Reuse RubyGems' compact index client in Bundler. Pull request [#9753](https://github.com/ruby/rubygems/pull/9753) by Hiroshi SHIBATA
* Reuse RubyGems' vendored PubGrub in Bundler. Pull request [#9752](https://github.com/ruby/rubygems/pull/9752) by Hiroshi SHIBATA
* Use RubyGems' YAML serializer in Bundler. Pull request [#9751](https://github.com/ruby/rubygems/pull/9751) by Hiroshi SHIBATA
* Reuse RubyGems' vendored SecureRandom in Bundler. Pull request [#9651](https://github.com/ruby/rubygems/pull/9651) by Hiroshi SHIBATA
* Reuse RubyGems' vendored URI in Bundler. Pull request [#9650](https://github.com/ruby/rubygems/pull/9650) by Hiroshi SHIBATA
* Fix two issues by including the ruby platform variants in the lock file. Pull request [#9556](https://github.com/ruby/rubygems/pull/9556) by Randy Stauner
* Fix plugin installation from gemfile. Pull request [#6957](https://github.com/ruby/rubygems/pull/6957) by Cody Cutrer, Diogo Fernandes and Hiroshi SHIBATA
* Add plugin hooks for Gemfile evaluation and source fetching. Pull request [#9488](https://github.com/ruby/rubygems/pull/9488) by Hiroshi SHIBATA, Cody Cutrer and Marv
* Use optimistic version constraints in bundle gem output. Pull request [#9533](https://github.com/ruby/rubygems/pull/9533) by Jeremy Evans
* Extend Gemfile `override` DSL with `:all` target and metadata fields (Phase 2). Pull request [#9530](https://github.com/ruby/rubygems/pull/9530) by Hiroshi SHIBATA
* Switch bundle add to use optimistic versioning by default. Pull request [#9526](https://github.com/ruby/rubygems/pull/9526) by Jeremy Evans
* Add Gemfile `override` DSL for version constraints (Phase 1). Pull request [#9517](https://github.com/ruby/rubygems/pull/9517) by Hiroshi SHIBATA
* Add `--no-build-extension` and `--no-install-plugin` options to gem install. Pull request [#9473](https://github.com/ruby/rubygems/pull/9473) by Hiroshi SHIBATA
* Include detailed dependencies when gemfile and lockfile are conflicts. Pull request [#9332](https://github.com/ruby/rubygems/pull/9332) by Hiroshi SHIBATA
* Implement relative path handling for plugin paths. Pull request [#9299](https://github.com/ruby/rubygems/pull/9299) by Hiroshi SHIBATA
* Bundler/inline: perform installation from a forked child. Pull request [#7941](https://github.com/ruby/rubygems/pull/7941) by Jean Boussier and Hiroshi SHIBATA
* Add global gem cache shared by RubyGems and Bundler. Pull request [#9230](https://github.com/ruby/rubygems/pull/9230) by Anthony Panozzo
* Update custom errors with Exception#full_message. Pull request [#8488](https://github.com/ruby/rubygems/pull/8488) by neimadTL

#### Performance:

* Use separate Bundler download and installation workers. Pull request [#9777](https://github.com/ruby/rubygems/pull/9777) by Joshua Young
* Cache a shared git source only once per command. Pull request [#9689](https://github.com/ruby/rubygems/pull/9689) by Hiroshi SHIBATA

#### Enhancements:

* Reject Bundler redirects that downgrade https to http. Pull request [#9859](https://github.com/ruby/rubygems/pull/9859) by Hiroshi SHIBATA

#### Bug fixes:

* Expand the git source gemspec path before the chdir. Pull request [#9845](https://github.com/ruby/rubygems/pull/9845) by Hiroshi SHIBATA

#### Breaking changes:

* Remove external tool version checks from `bundle env`. Pull request [#9593](https://github.com/ruby/rubygems/pull/9593) by Hiroshi SHIBATA
* Bundler: ignore patchlevel kwarg in ruby DSL. Pull request [#6023](https://github.com/ruby/rubygems/pull/6023) by Takuya N and Hiroshi SHIBATA
* Unify RubyGems and Bundler documentation. Pull request [#9237](https://github.com/ruby/rubygems/pull/9237) by Hiroshi SHIBATA

#### Deprecations:

* Rename the no_prune setting to keep_outdated_cache. Pull request [#9816](https://github.com/ruby/rubygems/pull/9816) by Hiroshi SHIBATA

## 4.0.20 / 2026-09-02

### RubyGems

#### Enhancements:

* Print a release notes link instead of the whole changelog on `gem update --system`. Pull request [#9794](https://github.com/ruby/rubygems/pull/9794) by hsbt
* Installs bundler 4.0.20 as a default gem.

#### Bug fixes:

* Only coerce exact true and false gemrc values to booleans. Pull request [#9822](https://github.com/ruby/rubygems/pull/9822) by hsbt
* Make the gem CLI work under RUBY_BOX=1. Pull request [#9810](https://github.com/ruby/rubygems/pull/9810) by hsbt

#### Documentation:

* Document and test all available gemrc configuration keys. Pull request [#9568](https://github.com/ruby/rubygems/pull/9568) by junaruga

### Bundler

#### Enhancements:

* Avoid duplicate relative path prefix in bundle exec. Pull request [#9596](https://github.com/ruby/rubygems/pull/9596) by samuel-williams-shopify
* Follow renamed default branch in git sources. Pull request [#9813](https://github.com/ruby/rubygems/pull/9813) by hsbt
* Bundler::Source::Git: avoid re-fetching the repo. Pull request [#9806](https://github.com/ruby/rubygems/pull/9806) by byroot
* Show the newest out-of-cooldown version in bundle outdated. Pull request [#9803](https://github.com/ruby/rubygems/pull/9803) by hsbt

#### Bug fixes:

* Error out when `bundle init --gemspec` gets no specification. Pull request [#9818](https://github.com/ruby/rubygems/pull/9818) by hsbt
* Fix relative gemspec paths being expanded twice. Pull request [#9814](https://github.com/ruby/rubygems/pull/9814) by hsbt
* Fix gemspec evaluation under Ruby::Box. Pull request [#9809](https://github.com/ruby/rubygems/pull/9809) by hsbt
* Fix release date extraction for the current changelog header format. Pull request [#9767](https://github.com/ruby/rubygems/pull/9767) by meganemura
* Resolve globbed entries literally in Gem::Util.glob_files_in_dir. Pull request [#9802](https://github.com/ruby/rubygems/pull/9802) by hsbt
* Preserve native extensions during implicit clean. Pull request [#9800](https://github.com/ruby/rubygems/pull/9800) by sjh9714

#### Documentation:

* Clarify :path expectations and cross-link platform docs in man pages. Pull request [#9724](https://github.com/ruby/rubygems/pull/9724) by hsbt

## 4.0.19 / 2026-08-20

### RubyGems

#### Enhancements:

* Reject SafeMarshal collection lengths longer than the remaining input. Pull request [#9756](https://github.com/ruby/rubygems/pull/9756) by hsbt
* Installs bundler 4.0.19 as a default gem.

#### Bug fixes:

* Fix gem uninstall --user-install crash when GEM_HOME does not exist. Pull request [#9749](https://github.com/ruby/rubygems/pull/9749) by hsbt

#### Documentation:

* Document SPDX license handling for license= and licenses=. Pull request [#9766](https://github.com/ruby/rubygems/pull/9766) by hsbt

### Bundler

#### Enhancements:

* Validate the platform field in Gem::Installer#verify_spec. Pull request [#9780](https://github.com/ruby/rubygems/pull/9780) by hsbt
* Restrict UserDefined handling to explicit class set for Gem::SafeMashal. Pull request [#9770](https://github.com/ruby/rubygems/pull/9770) by jackorp
* Filter git command output against the configured URI. Pull request [#9778](https://github.com/ruby/rubygems/pull/9778) by hsbt
* Summarize cooldown-skipped versions at the end of install, update, and lock. Pull request [#9762](https://github.com/ruby/rubygems/pull/9762) by hsbt

#### Bug fixes:

* Make repeated bundle lock options accumulate. Pull request [#9748](https://github.com/ruby/rubygems/pull/9748) by hsbt
* Fail instead of warning when frozen mode can't update the lockfile. Pull request [#9750](https://github.com/ruby/rubygems/pull/9750) by hsbt
* Fix wrong $LOAD_PATH for gems installed in the same process. Pull request [#9784](https://github.com/ruby/rubygems/pull/9784) by hsbt

#### Documentation:

* Fix auto-clean default version in bundle config docs. Pull request [#9783](https://github.com/ruby/rubygems/pull/9783) by hsbt
* Correct Bundler 5 default path documentation. Pull request [#9771](https://github.com/ruby/rubygems/pull/9771) by alloutflo

## 4.0.18 / 2026-08-05

### RubyGems

#### Enhancements:

* Check the resolved parent directory before extracting old format gems. Pull request [#9755](https://github.com/ruby/rubygems/pull/9755) by hsbt
* Installs bundler 4.0.18 as a default gem.

#### Bug fixes:

* Call Kernel.format explicitly in Gem::Deprecate wrapper. Pull request [#9714](https://github.com/ruby/rubygems/pull/9714) by hsbt

#### Documentation:

* Point bundler.io URLs at guides.rubygems.org. Pull request [#9737](https://github.com/ruby/rubygems/pull/9737) by hsbt

### Bundler

#### Enhancements:

* Don't mask install errors when no Gemfile can be located. Pull request [#9757](https://github.com/ruby/rubygems/pull/9757) by hsbt
* Warn when duplicate source declarations conflict on cooldown. Pull request [#9736](https://github.com/ruby/rubygems/pull/9736) by hsbt
* Redact URI userinfo from settings names in Bundler User-Agent. Pull request [#9716](https://github.com/ruby/rubygems/pull/9716) by hsbt
* Validate gem name before building compact index cache paths. Pull request [#9717](https://github.com/ruby/rubygems/pull/9717) by hsbt

#### Bug fixes:

* Fail `bundle check` when frozen mode needs lockfile changes. Pull request [#9715](https://github.com/ruby/rubygems/pull/9715) by hsbt
* Skip empty checksum values in compact index metadata. Pull request [#9713](https://github.com/ruby/rubygems/pull/9713) by hsbt

#### Security:

* Add --cooldown flag to bundle lock and bundle cache. Pull request [#9725](https://github.com/ruby/rubygems/pull/9725) by hsbt

#### Documentation:

* Point bundler.io URLs at guides.rubygems.org. Pull request [#9737](https://github.com/ruby/rubygems/pull/9737) by hsbt
* Document Bundler checksum behavior for default gems. Pull request [#9735](https://github.com/ruby/rubygems/pull/9735) by p-linnane
* List missing subcommands in bundle(1) UTILITIES section. Pull request [#9721](https://github.com/ruby/rubygems/pull/9721) by hsbt
* Document pessimistic operator and eval_gemfile in gemfile(5). Pull request [#9719](https://github.com/ruby/rubygems/pull/9719) by hsbt

## 4.0.17 / 2026-07-22

### RubyGems

#### Enhancements:

* Validate spec name before writing to the spec cache. Pull request [#9690](https://github.com/ruby/rubygems/pull/9690) by hsbt
* Installs bundler 4.0.17 as a default gem.

#### Bug fixes:

* Unquote Gem.ruby when spawning it as a separate argv element. Pull request [#9695](https://github.com/ruby/rubygems/pull/9695) by hsbt
* Escape glob metacharacters in install paths when globbing. Pull request [#9687](https://github.com/ruby/rubygems/pull/9687) by hsbt
* Preserve Windows editor paths in gem open and bundle open. Pull request [#9694](https://github.com/ruby/rubygems/pull/9694) by hsbt
* Preserve Windows paths in MAKE and rake environment variables. Pull request [#9693](https://github.com/ruby/rubygems/pull/9693) by hsbt
* Fix `bundle` binstub broken by `gem update --system` on Homebrew ruby. Pull request [#9688](https://github.com/ruby/rubygems/pull/9688) by hsbt

### Bundler

#### Enhancements:

* Open compact index cache in binary mode when appending. Pull request [#9679](https://github.com/ruby/rubygems/pull/9679) by hsbt

#### Bug fixes:

* Unquote Gem.ruby when spawning it as a separate argv element. Pull request [#9695](https://github.com/ruby/rubygems/pull/9695) by hsbt
* Escape glob metacharacters in install paths when globbing. Pull request [#9687](https://github.com/ruby/rubygems/pull/9687) by hsbt
* Avoid space-containing absolute path in RUBYOPT. Pull request [#9696](https://github.com/ruby/rubygems/pull/9696) by hsbt
* Preserve the locked Bundler checksum when the gem isn't cached. Pull request [#9658](https://github.com/ruby/rubygems/pull/9658) by rwstauner

#### Documentation:

* Point Bundler gemspec metadata at the moved docs. Pull request [#9648](https://github.com/ruby/rubygems/pull/9648) by hsbt

## 4.0.16 / 2026-07-10

### RubyGems

#### Enhancements:

* Installs bundler 4.0.16 as a default gem.

#### Bug fixes:

* Skip the make job server when using BSD make. Pull request [#9676](https://github.com/ruby/rubygems/pull/9676) by flavorjones

### Bundler

#### Enhancements:

* Bundler: Fix Bundler::Fetcher for PQC support, adding integration connection tests. Pull request [#9637](https://github.com/ruby/rubygems/pull/9637) by junaruga
* Reuse RubyGems' vendored tsort in Bundler. Pull request [#9647](https://github.com/ruby/rubygems/pull/9647) by hsbt

#### Bug fixes:

* Initialize the new gem's git repo without a subshell. Pull request [#9670](https://github.com/ruby/rubygems/pull/9670) by hsbt
* Preserve CRLF lockfile line endings on Windows. Pull request [#9669](https://github.com/ruby/rubygems/pull/9669) by hsbt
* Fix the gemspec error snippet on Windows drive-letter paths. Pull request [#9668](https://github.com/ruby/rubygems/pull/9668) by hsbt

#### Documentation:

* Point Bundler gemspec metadata at the moved docs. Pull request [#9648](https://github.com/ruby/rubygems/pull/9648) by hsbt

## 4.0.15 / 2026-06-24

### RubyGems

#### Enhancements:

* Rubygems: Fix Gem::Request for PQC support, adding integration connection tests. Pull request [#9615](https://github.com/ruby/rubygems/pull/9615) by junaruga
* Reduce peak memory usage of full index loading and bundle install. Pull request [#9618](https://github.com/ruby/rubygems/pull/9618) by hsbt
* Installs bundler 4.0.15 as a default gem.

#### Bug fixes:

* Forward security policy to old-format gems. Pull request [#9611](https://github.com/ruby/rubygems/pull/9611) by hsbt

### Bundler

#### Enhancements:

* Resolve Git LFS files in git sources from the real remote. Pull request [#9632](https://github.com/ruby/rubygems/pull/9632) by hsbt
* Suggest access issues, not only yanking, for missing locked gems. Pull request [#9631](https://github.com/ruby/rubygems/pull/9631) by hsbt
* Implement a make jobserver (continuation of #9210). Pull request [#9625](https://github.com/ruby/rubygems/pull/9625) by hsbt
* Reduce peak memory usage of full index loading and bundle install. Pull request [#9618](https://github.com/ruby/rubygems/pull/9618) by hsbt
* Bump up to rb-sys 0.9.128. Pull request [#9569](https://github.com/ruby/rubygems/pull/9569) by hsbt

#### Bug fixes:

* Skip the make jobserver on Windows. Pull request [#9630](https://github.com/ruby/rubygems/pull/9630) by hsbt
* Don't require source plugins to be installed to parse a lockfile: 4.0.x. Pull request [#9621](https://github.com/ruby/rubygems/pull/9621) by hsbt
* Exempt lockfile versions from cooldown on every resolution path. Pull request [#9619](https://github.com/ruby/rubygems/pull/9619) by hsbt
* Set `Bundler.settings[:ssl_ca_cert]` to download gems. Pull request [#9610](https://github.com/ruby/rubygems/pull/9610) by junaruga

## 4.0.14 / 2026-06-10

### RubyGems

#### Enhancements:

* Add executables and bindir validation to the gem installer. Pull request [#9595](https://github.com/ruby/rubygems/pull/9595) by hsbt
* Strip C1 control characters from displayed gem text. Pull request [#9597](https://github.com/ruby/rubygems/pull/9597) by hsbt
* Installs bundler 4.0.14 as a default gem.

### Bundler

#### Bug fixes:

* Preserve per-source cooldown when converging sources from the lockfile. Pull request [#9601](https://github.com/ruby/rubygems/pull/9601) by bryanwoods
* Don't exclude the locked version from cooldown during bundle update. Pull request [#9599](https://github.com/ruby/rubygems/pull/9599) by hsbt

## 4.0.13 / 2026-06-03

### RubyGems

#### Enhancements:

* Prevent extraction from escaping destination_dir via pre-existing symlinks. Pull request [#9493](https://github.com/ruby/rubygems/pull/9493) by thesmartshadow
* Close stdin immediately when using popen2e. Pull request [#9540](https://github.com/ruby/rubygems/pull/9540) by rwstauner
* Fallback to copy symlinks on Windows. Pull request [#9296](https://github.com/ruby/rubygems/pull/9296) by larskanis
* Installs bundler 4.0.13 as a default gem.

### Bundler

#### Enhancements:

* Do not hard-code permissions for new gem directories during bundle install. Pull request [#9557](https://github.com/ruby/rubygems/pull/9557) by maxfelsher-cgi
* Clear gem specification cache after acquiring process lock. Pull request [#9310](https://github.com/ruby/rubygems/pull/9310) by ngan
* Show release date with bundle outdated. Pull request [#9337](https://github.com/ruby/rubygems/pull/9337) by hsbt

#### Bug fixes:

* Apply cooldown to locally installed gem versions. Pull request [#9582](https://github.com/ruby/rubygems/pull/9582) by hsbt

#### Security:

* Add `cooldown` to delay newly published gem. Pull request [#9576](https://github.com/ruby/rubygems/pull/9576) by hsbt

## 4.0.12 / 2026-05-20

### RubyGems

#### Enhancements:

* Remove cygwin from WIN_PATTERNS. Pull request [#9527](https://github.com/ruby/rubygems/pull/9527) by fd00
* Installs bundler 4.0.12 as a default gem.

#### Bug fixes:

* Fall back to lockfile version when `BUNDLE_VERSION` is "lockfile". Pull request [#9545](https://github.com/ruby/rubygems/pull/9545) by hsbt
* Read `BUNDLE_VERSION` env var in `BundlerVersionFinder`. Pull request [#9538](https://github.com/ruby/rubygems/pull/9538) by hsbt

### Bundler

#### Enhancements:

* Make `bundle config get` return status 1 when the value is not set. Pull request [#9505](https://github.com/ruby/rubygems/pull/9505) by willnet
* Use Pathname#absolute?. Pull request [#9529](https://github.com/ruby/rubygems/pull/9529) by nobu
* Deprecate parsing non-lockfile content in LockfileParser. Pull request [#9502](https://github.com/ruby/rubygems/pull/9502) by kurotaky
* Print a warning for a potential confusion from the indirect dependencies. Pull request [#5029](https://github.com/ruby/rubygems/pull/5029) by junaruga
* Respect Gemfile bundler setting in `Bundler.setup`. Pull request [#4892](https://github.com/ruby/rubygems/pull/4892) by godfat

#### Bug fixes:

* Gracefully handle missing checksums in Compact Index. Pull request [#9492](https://github.com/ruby/rubygems/pull/9492) by jneen
* Skip git source exclusion when lockfile cannot backfill. Pull request [#9544](https://github.com/ruby/rubygems/pull/9544) by yahonda
* Fix bundle config gemfile unset behavior. Pull request [#9514](https://github.com/ruby/rubygems/pull/9514) by afurm

## 4.0.11 / 2026-04-30

### RubyGems

#### Enhancements:

* Add commented-out rubygems_mfa_required to bundle gem template. Pull request [#9487](https://github.com/ruby/rubygems/pull/9487) by MatheusRich
* Clarify the name and meaning of the first argument to `gem spec`. Pull request [#9476](https://github.com/ruby/rubygems/pull/9476) by eregon
* Installs bundler 4.0.11 as a default gem.

### Bundler

#### Enhancements:

* Update gem creation guide URL to rubygems.org. Pull request [#9500](https://github.com/ruby/rubygems/pull/9500) by nissyi-gh
* Lock the checksum of Bundler itself in the lockfile. Pull request [#9366](https://github.com/ruby/rubygems/pull/9366) by Edouard-chin

#### Bug fixes:

* Fix installing gems with native extensions + transitive dependencies. Pull request [#9477](https://github.com/ruby/rubygems/pull/9477) by nicholasdower
* Fix the bundler version not being updated in dev/test lockfile. Pull request [#9463](https://github.com/ruby/rubygems/pull/9463) by Edouard-chin
* Ensure the release CI doesn't break due to the Bundler checksum feature. Pull request [#9436](https://github.com/ruby/rubygems/pull/9436) by Edouard-chin

#### Documentation:

* Fix formatting for BUNDLE_PREFER_PATCH variable in man page. Pull request [#9474](https://github.com/ruby/rubygems/pull/9474) by toy

## 4.0.10 / 2026-04-08

### RubyGems

#### Enhancements:

* Ignore warnings with spec different platforms. Pull request [#8508](https://github.com/ruby/rubygems/pull/8508) by hsbt
* Better algorithm for sorting gem version. Pull request [#9421](https://github.com/ruby/rubygems/pull/9421) by Edouard-chin
* Update SPDX license list as of 2026-02-20. Pull request [#9434](https://github.com/ruby/rubygems/pull/9434) by hsbt
* Installs bundler 4.0.10 as a default gem.

#### Bug fixes:

* Register native extension files in default spec map. Pull request [#9431](https://github.com/ruby/rubygems/pull/9431) by hsbt
* Fix NoMethodError in Gem.try_activate when activation conflicts occur. Pull request [#9404](https://github.com/ruby/rubygems/pull/9404) by hsbt

### Bundler

#### Enhancements:

* Ignore warnings with spec different platforms. Pull request [#8508](https://github.com/ruby/rubygems/pull/8508) by hsbt
* Improve error message when current platform is not in lockfile. Pull request [#9439](https://github.com/ruby/rubygems/pull/9439) by 55728
* Cache package version selection. Pull request [#9410](https://github.com/ruby/rubygems/pull/9410) by Edouard-chin
* Check happy path first when comparing gem version. Pull request [#9417](https://github.com/ruby/rubygems/pull/9417) by Edouard-chin
* [feature] default_cli_command for config what command bundler runs when no specific command is provided. Pull request [#8886](https://github.com/ruby/rubygems/pull/8886) by jonbarlo
* Introduce a fast path for comparing Gem::Version. Pull request [#9414](https://github.com/ruby/rubygems/pull/9414) by Edouard-chin

#### Bug fixes:

* Restore rb_sys dependency for Rust. Pull request [#9416](https://github.com/ruby/rubygems/pull/9416) by bangseongbeom

## 4.0.9 / 2026-03-25

### RubyGems

#### Enhancements:

* Fix: include owner role in `gem owner`. Pull request [#9403](https://github.com/ruby/rubygems/pull/9403) by gjtorikian
* Installs bundler 4.0.9 as a default gem.

#### Bug fixes:

* Fix: Ensure trailing slash is added to source URIs added via gem sources. Pull request [#9055](https://github.com/ruby/rubygems/pull/9055) by zirni

#### Documentation:

* [DOC] Fix link. Pull request [#9409](https://github.com/ruby/rubygems/pull/9409) by BurdetteLamar

### Bundler

#### Enhancements:

* Check the git version only **once** per `bundle install`. Pull request [#9406](https://github.com/ruby/rubygems/pull/9406) by Edouard-chin
* Normalize the number of workers when performing parallel operations. Pull request [#9400](https://github.com/ruby/rubygems/pull/9400) by Edouard-chin
* Add exponential backoff to bundler retries. Pull request [#9163](https://github.com/ruby/rubygems/pull/9163) by ChrisBr
* Introduce a priority queue. Pull request [#9389](https://github.com/ruby/rubygems/pull/9389) by Edouard-chin
* Split the download and install process of a gem. Pull request [#9381](https://github.com/ruby/rubygems/pull/9381) by Edouard-chin

#### Bug fixes:

* Retry git fetch without --depth for dumb HTTP transport. Pull request [#9405](https://github.com/ruby/rubygems/pull/9405) by hsbt

## 4.0.8 / 2026-03-11

### RubyGems

#### Enhancements:

* Use JSON for cargo metadata parsing. Pull request
  [#9373](https://github.com/ruby/rubygems/pull/9373) by hsbt
* Fix NameError in Gem::Request.get_proxy_from_env when requiring
  rubygems/request directly. Pull request
  [#9362](https://github.com/ruby/rubygems/pull/9362) by afurm
* Installs bundler 4.0.8 as a default gem.

#### Documentation:

* Unify Compact Index API naming. Pull request
  [#9372](https://github.com/ruby/rubygems/pull/9372) by simi

### Bundler

#### Enhancements:

* Add a new Bundler config to control how many specs are fetched [#9363](https://github.com/ruby/rubygems/pull/9363)
* Restrict GitHub Actions workflow permissions for newgem [#9361](https://github.com/ruby/rubygems/pull/9361)

#### Bug fixes:

* Fix plugin new version not registering [#9355](https://github.com/ruby/rubygems/pull/9355)

## 4.0.7 / 2026-02-25

### RubyGems

#### Enhancements:

* Add Gem.disable_system_update_message in setup.rb. Pull request
  [#9020](https://github.com/ruby/rubygems/pull/9020) by hyuraku
* Print message when signing in with an existing API key. Pull request
  [#9312](https://github.com/ruby/rubygems/pull/9312) by hsbt
* Installs bundler 4.0.7 as a default gem.

#### Documentation:

* Document gemspecs must be deterministic. Pull request
  [#9321](https://github.com/ruby/rubygems/pull/9321) by fxn
* Remove "##" from a comment to require. Pull request
  [#9306](https://github.com/ruby/rubygems/pull/9306) by tompng

### Bundler

#### Enhancements:

* Don't check whether a plugin needs to be installed: [#9328](https://github.com/ruby/rubygems/pull/9328)
* [rust gem] Major improvements for gem scaffolding (rebased) [#8455](https://github.com/ruby/rubygems/pull/8455)
* Fix(bundler): only preload git sources for requested groups [#9234](https://github.com/ruby/rubygems/pull/9234)
* Raise error when gem contains capital letters [#5432](https://github.com/ruby/rubygems/pull/5432)

#### Bug fixes:

* Fix Bundler crashing when it tries to install plugin: [#9335](https://github.com/ruby/rubygems/pull/9335)
* Run git operations in parallel (take 2): [#9323](https://github.com/ruby/rubygems/pull/9323)
* Add support for help flag in plugin commands [#9263](https://github.com/ruby/rubygems/pull/9263)

#### Documentation:

* [DOC] Fix link in Bundler [#9315](https://github.com/ruby/rubygems/pull/9315)

## 4.0.6 / 2026-02-05

### RubyGems

#### Enhancements:

* Update vendored resolv to 0.7.0. Pull request
  [#9298](https://github.com/ruby/rubygems/pull/9298) by hsbt
* Installs bundler 4.0.6 as a default gem.

### Bundler

#### Bug fixes:

* Fix gzip cache corruption when recovering from HTTP 416 responses [#9272](https://github.com/ruby/rubygems/pull/9272)
* Fallback git/path sources to default source [#9301](https://github.com/ruby/rubygems/pull/9301)
* Ensure revision is always re-resolved in `git_proxy.rb` [#9294](https://github.com/ruby/rubygems/pull/9294)

#### Documentation:

* Clarify local gem override docs to require git-sourced gems [#9305](https://github.com/ruby/rubygems/pull/9305)

## 4.0.5 / 2026-01-29

### RubyGems

#### Enhancements:

* Removed unused deprecate loading. Pull request
  [#9266](https://github.com/ruby/rubygems/pull/9266) by hsbt
* Validate executable names for invalid characters. Pull request
  [#9257](https://github.com/ruby/rubygems/pull/9257) by hsbt
* Installs bundler 4.0.5 as a default gem.

#### Bug fixes:

* Fix RubyGems not able to require the right gem:. Pull request
  [#9246](https://github.com/ruby/rubygems/pull/9246) by Edouard-chin
* Remove special behavior for rake. Pull request
  [#9245](https://github.com/ruby/rubygems/pull/9245) by JasonLunn

#### Documentation:

* Added another usage of pristine command. Pull request
  [#9255](https://github.com/ruby/rubygems/pull/9255) by hsbt

### Bundler

#### Enhancements:

* Fix Bundler that re-exec $0 when a `version` is present in the config: [#9249](https://github.com/ruby/rubygems/pull/9249)

#### Bug fixes:

* Only use parent source with Git and Path sources [#9269](https://github.com/ruby/rubygems/pull/9269)

## 4.0.4 / 2026-01-15

### RubyGems

#### Enhancements:

* Remove date require from rebuild command. Pull request
  [#9232](https://github.com/ruby/rubygems/pull/9232) by jeremyevans
* Installs bundler 4.0.4 as a default gem.

#### Bug fixes:

* Add a missing "require 'etc'" statement:. Pull request
  [#9242](https://github.com/ruby/rubygems/pull/9242) by Edouard-chin

### Bundler

#### Enhancements:

* Validate more options for add sub-command [#5905](https://github.com/ruby/rubygems/pull/5905)
* Support Ruby 4.1 [#9219](https://github.com/ruby/rubygems/pull/9219)

#### Bug fixes:

* Fix dependency source bug in bundler [#9213](https://github.com/ruby/rubygems/pull/9213)
* Retain current bundler version on `bundle clean` [#9221](https://github.com/ruby/rubygems/pull/9221)

## 4.0.3 / 2025-12-23

### RubyGems

#### Enhancements:

* Installs bundler 4.0.3 as a default gem.

#### Documentation:

* Fix broken documentation links. Pull request
  [#9208](https://github.com/ruby/rubygems/pull/9208) by eileencodes

### Bundler

#### Enhancements:

* Fall back to ruby platform gem when precompiled variant is incompatible [#9211](https://github.com/ruby/rubygems/pull/9211)

## 4.0.2 / 2025-12-17

### RubyGems

#### Enhancements:

* Pass down value of `BUNDLE_JOBS` to RubyGems before compiling &
  introduce a new `gem install -j` flag. Pull request
  [#9171](https://github.com/ruby/rubygems/pull/9171) by Edouard-chin
* Installs bundler 4.0.2 as a default gem.

### Bundler

#### Enhancements:

* Support single quotes in mise format ruby version [#9183](https://github.com/ruby/rubygems/pull/9183)
* Tweak the Bundler's "X gems now installed message": [#9194](https://github.com/ruby/rubygems/pull/9194)

#### Bug fixes:

* Allow to show cli_help with `bundler` executable [#9198](https://github.com/ruby/rubygems/pull/9198)
* Allow bundle pristine to work for git gems in the same repo [#9196](https://github.com/ruby/rubygems/pull/9196)

## 4.0.1 / 2025-12-09

### RubyGems

#### Enhancements:

* Installs bundler 4.0.1 as a default gem.

#### Bug fixes:

* Fixed unexpected default bundler installation. Pull request
  [#9167](https://github.com/ruby/rubygems/pull/9167) by hsbt

#### Documentation:

* Update contributing docs with `RGV`. Pull request
  [#9155](https://github.com/ruby/rubygems/pull/9155) by eileencodes

### Bundler

#### Performance:

* Increase connection pool to allow for up to 70% speed increase on `bundle install` [#9087](https://github.com/ruby/rubygems/pull/9087)

#### Enhancements:

* Fix the config suggestion in the warning for `$ bundle` [#9164](https://github.com/ruby/rubygems/pull/9164)
* Fix native extension loading in newgem template for RHEL-based systems [#9156](https://github.com/ruby/rubygems/pull/9156)

#### Bug fixes:

* Fix Bundler removing executables after creating them [#9169](https://github.com/ruby/rubygems/pull/9169)

## 4.0.0 / 2025-12-03

### RubyGems

#### Features:

* Undeprecate `Gem::Version.new(nil)`. Pull request
  [#9086](https://github.com/ruby/rubygems/pull/9086) by tenderlove
* Add pattern matching support to Gem::NameTuple. Pull request
  [#9064](https://github.com/ruby/rubygems/pull/9064) by baweaver
* Add pattern matching support to Gem::Platform. Pull request
  [#9062](https://github.com/ruby/rubygems/pull/9062) by baweaver

#### Performance:

* Add `MAKEFLAGS=-j` by default before compiling. Pull request
  [#9131](https://github.com/ruby/rubygems/pull/9131) by Edouard-chin
* Remove some memoization. Pull request
  [#9017](https://github.com/ruby/rubygems/pull/9017) by tenderlove
* Pull `Gem.win_platform?` out of a hot path. Pull request
  [#8983](https://github.com/ruby/rubygems/pull/8983) by tenderlove
* Stop trying to remove every file on extraction. Pull request
  [#8974](https://github.com/ruby/rubygems/pull/8974) by tenderlove
* Use `IO.copy_stream` with IO object directly. Pull request
  [#8970](https://github.com/ruby/rubygems/pull/8970) by tenderlove
* Pass a file size to `IO.copy_stream`. Pull request
  [#8966](https://github.com/ruby/rubygems/pull/8966) by tenderlove
* Use File#chmod rather than FileUtils.chmod. Pull request
  [#8965](https://github.com/ruby/rubygems/pull/8965) by tenderlove

#### Enhancements:

* Update all vendored libraries to latest version. Pull request
  [#9089](https://github.com/ruby/rubygems/pull/9089) by hsbt
* Removed unused `Gem::Deprecate`. Pull request
  [#9090](https://github.com/ruby/rubygems/pull/9090) by hsbt
* Add debug logging information to see the time it took to download and
  install a gem. Pull request
  [#9066](https://github.com/ruby/rubygems/pull/9066) by Edouard-chin
* Fix constants in TAR to be frozen. Pull request
  [#9041](https://github.com/ruby/rubygems/pull/9041) by tenderlove
* Remove open-ended and prerelease dependency warnings when building gems.
  Pull request [#9050](https://github.com/ruby/rubygems/pull/9050) by
  jeremyevans
* Revamp CmakeBuilder. Pull request
  [#8753](https://github.com/ruby/rubygems/pull/8753) by cfis
* Restrict what schemes are acceptable in the remote fetcher. Pull request
  [#9022](https://github.com/ruby/rubygems/pull/9022) by tenderlove
* `gem sources --prepend` and `--append` allow finer grained control of
  sources. Pull request [#8901](https://github.com/ruby/rubygems/pull/8901)
  by martinemde
* Improve `gem sources --remove` output. Pull request
  [#8909](https://github.com/ruby/rubygems/pull/8909) by deivid-rodriguez
* Make `gem sources` output more clear. Pull request
  [#8938](https://github.com/ruby/rubygems/pull/8938) by deivid-rodriguez
* Don't fail if there is no makefile, simply don't do anything. Pull
  request [#8879](https://github.com/ruby/rubygems/pull/8879) by ioquatix
* Use IMDSv2 for S3 instance credentials. Pull request
  [#7709](https://github.com/ruby/rubygems/pull/7709) by folbricht-stripe
* Fix regression in presence of RVM gems. Pull request
  [#8854](https://github.com/ruby/rubygems/pull/8854) by deivid-rodriguez
* Restore parsing "--" as an unknown platform rather than crashing. Pull
  request [#8846](https://github.com/ruby/rubygems/pull/8846) by
  deivid-rodriguez
* Installs bundler 4.0.0 as a default gem.

#### Bug fixes:

* Fix test failure of mswin and nmake. Pull request
  [#9135](https://github.com/ruby/rubygems/pull/9135) by hsbt
* Respect `BUNDLE_VERSION` config at Gem::BundlerVersionFinder. Pull
  request [#9106](https://github.com/ruby/rubygems/pull/9106) by hsbt
* Fix "did you mean" suggestions for unknown commands. Pull request
  [#8948](https://github.com/ruby/rubygems/pull/8948) by deivid-rodriguez
* Fix trailing slashes not considered by `gem sources --remove`. Pull
  request [#8939](https://github.com/ruby/rubygems/pull/8939) by
  deivid-rodriguez

#### Security:

* Bump up vendored URI to 1.0.4. Pull request
  [#9031](https://github.com/ruby/rubygems/pull/9031) by hsbt

#### Breaking changes:

* Removed deprecated `-C` option from gem build. Pull request
  [#9088](https://github.com/ruby/rubygems/pull/9088) by hsbt
* Removed deprecated Gem::Specification#has_rdoc, has_rdoc= and has_rdoc?.
  Pull request [#9084](https://github.com/ruby/rubygems/pull/9084) by hsbt
* Removed deprecated `gem query` command. Pull request
  [#9083](https://github.com/ruby/rubygems/pull/9083) by hsbt
* Removed deprecated Gem::DependencyInstaller#find_gems_with_sources. Pull
  request [#9082](https://github.com/ruby/rubygems/pull/9082) by hsbt
* Remove deprecated methods of RubyGems. Pull request
  [#9081](https://github.com/ruby/rubygems/pull/9081) by hsbt
* Make verification methods private. Pull request
  [#9051](https://github.com/ruby/rubygems/pull/9051) by tenderlove
* Deprecate `--default` option from install command. Pull request
  [#7588](https://github.com/ruby/rubygems/pull/7588) by hsbt
* Removed `compatibility.rb` for RG 4.0. Pull request
  [#8899](https://github.com/ruby/rubygems/pull/8899) by hsbt

#### Deprecations:

* Deprecate `Gem::Specification#datadir`. Pull request
  [#8900](https://github.com/ruby/rubygems/pull/8900) by hsbt

#### Documentation:

* Unified UPGRADING.md and extract blog.rubygems.org. Pull request
  [#9148](https://github.com/ruby/rubygems/pull/9148) by hsbt
* Remove italic formatting from changelog section headers. Pull request
  [#9128](https://github.com/ruby/rubygems/pull/9128) by hsbt
* [DOC] Fix the location of Gem::Deprecate document. Pull request
  [#9065](https://github.com/ruby/rubygems/pull/9065) by nobu
* Fix typo. Pull request
  [#9012](https://github.com/ruby/rubygems/pull/9012) by etiennebarrie
* Added document for Gem::Uninstaller. Pull request
  [#8904](https://github.com/ruby/rubygems/pull/8904) by hsbt
* Use mailto link in Code of Conduct. Pull request
  [#8849](https://github.com/ruby/rubygems/pull/8849) by deivid-rodriguez
* Update Code of Conduct email to conduct@rubygems.org. Pull request
  [#8848](https://github.com/ruby/rubygems/pull/8848) by indirect

### Bundler

#### Features:

* Support bundle install --lockfile option [#9111](https://github.com/ruby/rubygems/pull/9111)
* Add support for lockfile in Gemfile and bundle install --no-lock [#9059](https://github.com/ruby/rubygems/pull/9059)
* Add `--ext=go` to `bundle gem` [#8183](https://github.com/ruby/rubygems/pull/8183)
* Update Bundler::CurrentRuby::ALL_RUBY_VERSIONS [#9058](https://github.com/ruby/rubygems/pull/9058)
* Introduce `bundle list --format=json` [#8728](https://github.com/ruby/rubygems/pull/8728)

#### Performance:

* Run git operations in parallel to speed things up: [#9100](https://github.com/ruby/rubygems/pull/9100)
* Replace instance method look up in plugin installer [#9094](https://github.com/ruby/rubygems/pull/9094)
* Adjust the API_REQUEST_LIMIT to make less network roundtrip [#9071](https://github.com/ruby/rubygems/pull/9071)

#### Enhancements:

* Make BUNDLE_LOCKFILE environment variable have precedence over lockfile method in Gemfile [#9146](https://github.com/ruby/rubygems/pull/9146)
* Improve banner message for the default command [#9145](https://github.com/ruby/rubygems/pull/9145)
* Introduce `install_or_cli_help` and use it default `bundle` command [#9136](https://github.com/ruby/rubygems/pull/9136)
* Add go_gem/rake_task for Go native extension gem skeleton [#9105](https://github.com/ruby/rubygems/pull/9105)
* Warn users that `bundle` now display the help: [#9092](https://github.com/ruby/rubygems/pull/9092)
* Use DidYouMean::SpellChecker for gem suggestions in Bundler [#3857](https://github.com/ruby/rubygems/pull/3857)
* Update all vendored libraries to latest version [#9089](https://github.com/ruby/rubygems/pull/9089)
* We don't need to allow some warning now [#9074](https://github.com/ruby/rubygems/pull/9074)
* Support to embedded Pathname [#9056](https://github.com/ruby/rubygems/pull/9056)
* Enforce activation of irb when running with bundle console [#9033](https://github.com/ruby/rubygems/pull/9033)
* Update Magnus version in Rust extension gem template [#9025](https://github.com/ruby/rubygems/pull/9025)
* Add checksum of gems hosted on private servers: [#9004](https://github.com/ruby/rubygems/pull/9004)
* Loading support on Windows [#8254](https://github.com/ruby/rubygems/pull/8254)
* Improve error message when the same source is specified through `gemspec` and `path` [#8460](https://github.com/ruby/rubygems/pull/8460)
* Raise an error in frozen mode if some registry gems have empty checksums [#8888](https://github.com/ruby/rubygems/pull/8888)
* Bump vendored thor to 1.4.0 [#8883](https://github.com/ruby/rubygems/pull/8883)
* Delay default path and global cache changes to Bundler 5 [#8867](https://github.com/ruby/rubygems/pull/8867)
* Fix spacing in bundle gem newgem.gemspec.tt [#8865](https://github.com/ruby/rubygems/pull/8865)
* Add some missing deprecation messages [#8844](https://github.com/ruby/rubygems/pull/8844)

#### Bug fixes:

* Fixed checksums generation issue when no source is specified [#9133](https://github.com/ruby/rubygems/pull/9133)
* Check for file existence before deletion from cache [#9095](https://github.com/ruby/rubygems/pull/9095)
* Use method_defined?(:method, false) [#9098](https://github.com/ruby/rubygems/pull/9098)
* Handle BUNDLER_VERSION being set to an empty string [#6928](https://github.com/ruby/rubygems/pull/6928)
* Fix `bundle install` when the Gemfile contains "install_if" git gems: [#8992](https://github.com/ruby/rubygems/pull/8992)
* Fix installation issue related to path sources and precompiled gems [#8973](https://github.com/ruby/rubygems/pull/8973)
* Fix outdated lockfile during `bundle lock` when source changes [#8962](https://github.com/ruby/rubygems/pull/8962)
* Raise error on missing version file [#8963](https://github.com/ruby/rubygems/pull/8963)
* Fix `bundle cache --frozen` and `bundle cache --no-prune` not printing a deprecation message [#8926](https://github.com/ruby/rubygems/pull/8926)
* Fix local installation incorrectly forced if there's a `vendor/cache` directory and frozen mode is set [#8925](https://github.com/ruby/rubygems/pull/8925)
* Fix `bundle lock --update <gem>` with `--lockfile` flag updating all gems [#8922](https://github.com/ruby/rubygems/pull/8922)
* Fix `bundle show --verbose` and recommend it as an alternative to `bundle show --outdated` [#8915](https://github.com/ruby/rubygems/pull/8915)
* Fix `bundle cache --no-all` not printing a deprecation warning [#8912](https://github.com/ruby/rubygems/pull/8912)
* Fix `bundle update foo` unable to update foo in an edge case [#8897](https://github.com/ruby/rubygems/pull/8897)
* Fix Bundler printing more flags than actually passed in verbose mode [#8914](https://github.com/ruby/rubygems/pull/8914)
* Fix bundler failing to install sorbet-static in truffleruby when there's no lockfile [#8872](https://github.com/ruby/rubygems/pull/8872)
* Cancel deprecation of `--force` flag to `bundle install` and `bundle update` [#8843](https://github.com/ruby/rubygems/pull/8843)

#### Security:

* Bump up vendored URI to 1.0.4 [#9031](https://github.com/ruby/rubygems/pull/9031)

#### Breaking changes:

* Fix triple spacing when generating lockfile [#9076](https://github.com/ruby/rubygems/pull/9076)
* Hide patchlevel from lockfile [#7772](https://github.com/ruby/rubygems/pull/7772)
* Remove `bundler_4_mode` [#9038](https://github.com/ruby/rubygems/pull/9038)
* Pick and add extra changes for 4.0.0 version [#9018](https://github.com/ruby/rubygems/pull/9018)
* Replaced Bundler::SharedHelpers.major_deprecation to feature_removed! or feature_deprecated! [#9016](https://github.com/ruby/rubygems/pull/9016)
* Removed legacy_check option from SpecSet#for [#9015](https://github.com/ruby/rubygems/pull/9015)
* Make update_requires_all_flag to settings [#9011](https://github.com/ruby/rubygems/pull/9011)
* Make default cli command settings [#9010](https://github.com/ruby/rubygems/pull/9010)
* Make global_gem_cache flag to settings [#9009](https://github.com/ruby/rubygems/pull/9009)
* Consolidate removal of `Bundler.rubygems.all_specs` [#9008](https://github.com/ruby/rubygems/pull/9008)
* Consolidate removal of `Bundler::SpecSet#-` and `Bundler::SpecSet#<<` [#9007](https://github.com/ruby/rubygems/pull/9007)
* Replaced Bundler.feature_flag.plugins? to Bundler.settings [#9006](https://github.com/ruby/rubygems/pull/9006)
* Make `bundle show --outdated` raise an error [#8980](https://github.com/ruby/rubygems/pull/8980)
* Make `--local-git` flag to `bundle plugin install` raise an error [#8979](https://github.com/ruby/rubygems/pull/8979)
* Switch `cache_all` to be `true` by default [#8975](https://github.com/ruby/rubygems/pull/8975)
* Completely forbid passing `--ext` to `bundle gem` without a value [#8976](https://github.com/ruby/rubygems/pull/8976)
* Switch `lockfile_checksums` to be `true` by default [#8981](https://github.com/ruby/rubygems/pull/8981)
* Make `bundle install --binstubs` raise an error [#8978](https://github.com/ruby/rubygems/pull/8978)
* Make `bundle remove --install` raise an error [#8977](https://github.com/ruby/rubygems/pull/8977)
* Remove support for multiple global sources in Gemfile & lockfile [#8968](https://github.com/ruby/rubygems/pull/8968)
* Remove `allow_offline_install` setting [#8969](https://github.com/ruby/rubygems/pull/8969)
* Completely remove `--rubocop` flag to `bundle gem`, and related configuration [#8967](https://github.com/ruby/rubygems/pull/8967)
* Completely remove all remembered CLI flags [#8958](https://github.com/ruby/rubygems/pull/8958)
* Remove implementation of `deployment`, `capistrano` and `vlad` entrypoints [#8957](https://github.com/ruby/rubygems/pull/8957)
* Remove deprecated `Bundler.*clean*`, and `Bundler.environment` helpers [#8924](https://github.com/ruby/rubygems/pull/8924)
* Remove deprecated `bundle viz` and `bundle inject` commands [#8923](https://github.com/ruby/rubygems/pull/8923)
* Removed to workaround for Bundler 2.2 [#8903](https://github.com/ruby/rubygems/pull/8903)

#### Documentation:

* Unified UPGRADING.md and extract blog.rubygems.org [#9148](https://github.com/ruby/rubygems/pull/9148)
* Remove italic formatting from changelog section headers [#9128](https://github.com/ruby/rubygems/pull/9128)
* Small clarifications to Bundler 4 upgrade docs [#8964](https://github.com/ruby/rubygems/pull/8964)
* Improve documentation of `bundle doctor`, `bundle plugin`, and `bundle config` [#8919](https://github.com/ruby/rubygems/pull/8919)
* Make sure all CLI flags and subcommands are documented [#8861](https://github.com/ruby/rubygems/pull/8861)
* Clarify documentation about new default gem installation directory in Bundler 4 [#8857](https://github.com/ruby/rubygems/pull/8857)
* Use mailto link in Code of Conduct [#8849](https://github.com/ruby/rubygems/pull/8849)
* Update Code of Conduct email to conduct@rubygems.org [#8848](https://github.com/ruby/rubygems/pull/8848)
* Add missing link to `irb` repo in DEBUGGING.md [#8842](https://github.com/ruby/rubygems/pull/8842)

## 3.7.2 / 2025-09-09

### Enhancements:

* `gem sources --prepend` and `--append` allow finer grained control of
  sources. Pull request
  [#8901](https://github.com/ruby/rubygems/pull/8901) by martinemde
* Improve `gem sources --remove` output. Pull request
  [#8909](https://github.com/ruby/rubygems/pull/8909) by
  deivid-rodriguez
* Make `gem sources` output more clear. Pull request
  [#8938](https://github.com/ruby/rubygems/pull/8938) by
  deivid-rodriguez
* Use IMDSv2 for S3 instance credentials. Pull request
  [#7709](https://github.com/ruby/rubygems/pull/7709) by
  folbricht-stripe
* Installs bundler 2.7.2 as a default gem.

### Bug fixes:

* Fix "did you mean" suggestions for unknown commands. Pull request
  [#8948](https://github.com/ruby/rubygems/pull/8948) by
  deivid-rodriguez
* Fix trailing slashes not considered by `gem sources --remove`. Pull
  request [#8939](https://github.com/ruby/rubygems/pull/8939) by
  deivid-rodriguez

## 3.7.1 / 2025-07-21

### Enhancements:

* Fix regression in presence of RVM gems. Pull request
  [#8854](https://github.com/ruby/rubygems/pull/8854) by
  deivid-rodriguez
* Restore parsing "--" as an unknown platform rather than crashing. Pull
  request [#8846](https://github.com/ruby/rubygems/pull/8846) by
  deivid-rodriguez
* Installs bundler 2.7.1 as a default gem.

### Documentation:

* Use mailto link in Code of Conduct. Pull request
  [#8849](https://github.com/ruby/rubygems/pull/8849) by
  deivid-rodriguez
* Update Code of Conduct email to conduct@rubygems.org. Pull request
  [#8848](https://github.com/ruby/rubygems/pull/8848) by indirect

## 3.7.0 / 2025-07-16

### Security:

* Update vendored resolv to 0.6.2. Pull request
  [#8831](https://github.com/ruby/rubygems/pull/8831) by hsbt

### Breaking changes:

* Stop generating binstubs with support for RubyGems before 2.6.2. Pull
  request [#8833](https://github.com/ruby/rubygems/pull/8833) by
  deivid-rodriguez
* Drop support for Ruby 3.1. Pull request
  [#8634](https://github.com/ruby/rubygems/pull/8634) by segiddins

### Enhancements:

* Update SPDX license list as of 2025-07-01. Pull request
  [#8829](https://github.com/ruby/rubygems/pull/8829) by
  github-actions[bot]
* Add `push_rubygem` as a default scope for `gem signin` command. Pull
  request [#8672](https://github.com/ruby/rubygems/pull/8672) by hsbt
* Update bundled tls certs. Pull request
  [#8731](https://github.com/ruby/rubygems/pull/8731) by segiddins
* Install the best matching gem for the current platform in `gem install`.
  Pull request [#8751](https://github.com/ruby/rubygems/pull/8751) by
  segiddins
* Move most of `Bundler::GemHelpers` to `Gem::Platform`. Pull request
  [#8703](https://github.com/ruby/rubygems/pull/8703) by segiddins
* Ensure that `Gem::Platform` parses strings to a fix point. Pull request
  [#8584](https://github.com/ruby/rubygems/pull/8584) by segiddins
* Installs bundler 2.7.0 as a default gem.

### Bug fixes:

* Fix signing HEAD and date formatting in S3 signer. Pull request
  [#8763](https://github.com/ruby/rubygems/pull/8763) by rye-stripe
* Fix `--bindir <foo>` flag to gem install failing when `<foo>` is not in
  the default GEM_HOME and its parent directory does not exist yet. Pull
  request [#8783](https://github.com/ruby/rubygems/pull/8783) by larouxn
* Fix `gem install` sometimes compiling the wrong source files. Pull
  request [#8764](https://github.com/ruby/rubygems/pull/8764) by
  deivid-rodriguez
* Workaround rust extension compilation when `ccache` or `sccache` are
  used. Pull request [#8521](https://github.com/ruby/rubygems/pull/8521)
  by hsbt
* Fix `gem pristine` not recompiling extensions sometimes. Pull request
  [#8757](https://github.com/ruby/rubygems/pull/8757) by
  deivid-rodriguez
* Fix `--prerelease` flag to `gem install` sometimes not respected. Pull
  request [#8648](https://github.com/ruby/rubygems/pull/8648) by ntl

### Documentation:

* Fix incorrect UPGRADING link in README.md. Pull request
  [#8838](https://github.com/ruby/rubygems/pull/8838) by djbender
* Add a root CONTRIBUTING.md file. Pull request
  [#8822](https://github.com/ruby/rubygems/pull/8822) by
  deivid-rodriguez
* Add a SECURITY.md file. Pull request
  [#8812](https://github.com/ruby/rubygems/pull/8812) by
  deivid-rodriguez
* Fix heading ranks in documentation. Pull request
  [#8711](https://github.com/ruby/rubygems/pull/8711) by antoinem

## 3.6.9 / 2025-05-13

### Enhancements:

* Add mtime to Gem::Package::TarWriter#add_file argument. Pull request
  [#8673](https://github.com/ruby/rubygems/pull/8673) by unasuke
* Print webauthn authentication link as a separate line to make it easier
  to visit. Pull request
  [#8663](https://github.com/ruby/rubygems/pull/8663) by mperham
* Remove shellwords autoload. Pull request
  [#8644](https://github.com/ruby/rubygems/pull/8644) by
  deivid-rodriguez
* Installs bundler 2.6.9 as a default gem.

### Performance:

* Avoid unnecessary splat allocation. Pull request
  [#8640](https://github.com/ruby/rubygems/pull/8640) by jeremyevans

### Documentation:

* Fix typo in Changelog for 3.6.0 / 2024-12-16. Pull request
  [#8638](https://github.com/ruby/rubygems/pull/8638) by thatrobotdev

## 3.6.8 / 2025-04-13

### Enhancements:

* Installs bundler 2.6.8 as a default gem.

## 3.6.7 / 2025-04-03

### Enhancements:

* Sorting files in metadata for build reproducibility. Pull request
  [#8569](https://github.com/ruby/rubygems/pull/8569) by
  giacomobenedetti
* Default to a SOURCE_DATE_EPOCH of 315619200, to simplify reproducible
  builds. Pull request
  [#8568](https://github.com/ruby/rubygems/pull/8568) by duckinator
* Let `gem exec` raise an error in ambiguous cases. Pull request
  [#8573](https://github.com/ruby/rubygems/pull/8573) by
  deivid-rodriguez
* Installs bundler 2.6.7 as a default gem.

### Performance:

* Speed up Version#<=> ~20-50% when lengths differ. Pull request
  [#8565](https://github.com/ruby/rubygems/pull/8565) by skipkayhil

## 3.6.6 / 2025-03-13

### Enhancements:

* Update vendored uri to 1.0.3. Pull request
  [#8534](https://github.com/ruby/rubygems/pull/8534) by hsbt
* Installs bundler 2.6.6 as a default gem.

### Bug fixes:

* Fix `gem rdoc` not working with newer versions of rdoc when not
  installed as default gems. Pull request
  [#8549](https://github.com/ruby/rubygems/pull/8549) by
  deivid-rodriguez

## 3.6.5 / 2025-02-20

### Enhancements:

* Installs bundler 2.6.5 as a default gem.

### Documentation:

* Removed `gem server` from `gem help`. Pull request
  [#8507](https://github.com/ruby/rubygems/pull/8507) by hsbt

## 3.6.4 / 2025-02-17

### Enhancements:

* Raise a simpler error when RubyGems fails to activate a dependency. Pull
  request [#8449](https://github.com/ruby/rubygems/pull/8449) by
  deivid-rodriguez
* Installs bundler 2.6.4 as a default gem.

### Performance:

* Allocate strings from Requirement match only once. Pull request
  [#8245](https://github.com/ruby/rubygems/pull/8245) by segiddins

## 3.6.3 / 2025-01-16

### Enhancements:

* Add credentials file path to `gem env`. Pull request
  [#8375](https://github.com/ruby/rubygems/pull/8375) by duckinator
* Update SPDX license list as of 2024-12-30. Pull request
  [#8387](https://github.com/ruby/rubygems/pull/8387) by
  github-actions[bot]
* Installs bundler 2.6.3 as a default gem.

### Bug fixes:

* Fix `@licenses` array unmarshalling. Pull request
  [#8411](https://github.com/ruby/rubygems/pull/8411) by rykov

## 3.6.2 / 2024-12-23

### Security:

* Fix Gem::SafeMarshal buffer overrun when given lengths larger than fit
  into a byte. Pull request
  [#8305](https://github.com/ruby/rubygems/pull/8305) by segiddins
* Improve type checking in marshal_load methods. Pull request
  [#8306](https://github.com/ruby/rubygems/pull/8306) by segiddins

### Enhancements:

* Skip rdoc hooks and their tests on newer rdoc versions. Pull request
  [#8340](https://github.com/ruby/rubygems/pull/8340) by
  deivid-rodriguez
* Installs bundler 2.6.2 as a default gem.

### Bug fixes:

* Fix serialized metadata including an empty `@original_platform`
  attribute. Pull request
  [#8355](https://github.com/ruby/rubygems/pull/8355) by
  deivid-rodriguez

## 3.6.1 / 2024-12-17

### Enhancements:

* Installs bundler 2.6.1 as a default gem.

### Bug fixes:

* Fix `gem info` tagging some non default gems as default. Pull request
  [#8321](https://github.com/ruby/rubygems/pull/8321) by
  deivid-rodriguez

### Documentation:

* Fix broken links. Pull request
  [#8327](https://github.com/ruby/rubygems/pull/8327) by st0012

## 3.6.0 / 2024-12-16

### Security:

* Stop storing executable names in ivars. Pull request
  [#8307](https://github.com/ruby/rubygems/pull/8307) by segiddins

### Breaking changes:

* Drop ruby 3.0 support. Pull request
  [#8091](https://github.com/ruby/rubygems/pull/8091) by segiddins

### Features:

* Add --attestation option to gem push. Pull request
  [#8239](https://github.com/ruby/rubygems/pull/8239) by segiddins

### Enhancements:

* Skip unresolved deps warning on `Gem::Specification.reset` on benign
  cases. Pull request
  [#8309](https://github.com/ruby/rubygems/pull/8309) by
  deivid-rodriguez
* Let `gem install <name>` suggest `<name>-ruby` and `ruby-<name>` when
  providing "did you mean" suggestions. Pull request
  [#8197](https://github.com/ruby/rubygems/pull/8197) by duckinator
* Update SPDX license list as of 2024-08-19. Pull request
  [#8233](https://github.com/ruby/rubygems/pull/8233) by
  github-actions[bot]
* Add `--target-rbconfig` option to `gem install` and `gem update`
  commands. Pull request
  [#7628](https://github.com/ruby/rubygems/pull/7628) by kateinoigakukun
* Skip nil-value keys to make metadata reproducible. Pull request
  [#7129](https://github.com/ruby/rubygems/pull/7129) by nobu
* Allow disabling installation of compiled extensions into lib through
  `Gem.configuration.install_extension_in_lib`. Pull request
  [#6463](https://github.com/ruby/rubygems/pull/6463) by hsbt
* Installs bundler 2.6.0 as a default gem.

### Bug fixes:

* Set $0 to exe when running `gem exec` to fix name in CLI output. Pull
  request [#8267](https://github.com/ruby/rubygems/pull/8267) by adam12
* Fix manifest in gem package using incorrect platform sometimes. Pull
  request [#8202](https://github.com/ruby/rubygems/pull/8202) by
  deivid-rodriguez

### Documentation:

* Fix missing single quote in git source example. Pull request
  [#8303](https://github.com/ruby/rubygems/pull/8303) by nobu
* Update the `gem install` demo in README to use a gem that just works on
  Windows. Pull request
  [#8262](https://github.com/ruby/rubygems/pull/8262) by soda92
* Unify rubygems and bundler docs directory. Pull request
  [#8159](https://github.com/ruby/rubygems/pull/8159) by hsbt

## 3.5.23 / 2024-11-05

### Enhancements:

* Validate user input encoding of `gem` CLI arguments. Pull request
  [#6471](https://github.com/ruby/rubygems/pull/6471) by
  deivid-rodriguez
* Fix `gem update --system` leaving old default bundler executables
  around. Pull request
  [#8172](https://github.com/ruby/rubygems/pull/8172) by
  deivid-rodriguez
* Installs bundler 2.5.23 as a default gem.

### Bug fixes:

* Fix commands with 2 MFA requests when webauthn is enabled. Pull request
  [#8174](https://github.com/ruby/rubygems/pull/8174) by
  deivid-rodriguez
* Make `--enable-load-relative` binstubs prolog work when Ruby is not
  installed in the same directory as the binstub. Pull request
  [#7872](https://github.com/ruby/rubygems/pull/7872) by
  deivid-rodriguez

### Performance:

* Speed up `gem install <nonexistent-gem>` by finding alternative name
  suggestions faster. Pull request
  [#8084](https://github.com/ruby/rubygems/pull/8084) by duckinator

### Documentation:

* Add missing comma in documentation. Pull request
  [#8152](https://github.com/ruby/rubygems/pull/8152) by leoarnold

## 3.5.22 / 2024-10-16

### Enhancements:

* Prevent `._*` files in packages generated from macOS. Pull request
  [#8150](https://github.com/ruby/rubygems/pull/8150) by
  deivid-rodriguez
* Fix `gem pristine etc` resetting gem twice sometimes. Pull request
  [#8117](https://github.com/ruby/rubygems/pull/8117) by
  deivid-rodriguez
* Allow `gem pristine` to reset default gems too. Pull request
  [#8118](https://github.com/ruby/rubygems/pull/8118) by
  deivid-rodriguez
* Update vendored `uri` and `net-http`. Pull request
  [#8112](https://github.com/ruby/rubygems/pull/8112) by segiddins
* Installs bundler 2.5.22 as a default gem.

### Bug fixes:

* Fix `gem contents` for default gems. Pull request
  [#8132](https://github.com/ruby/rubygems/pull/8132) by
  deivid-rodriguez
* Fix duplicated specs when they have been previously activated. Pull
  request [#8131](https://github.com/ruby/rubygems/pull/8131) by
  deivid-rodriguez
* Fix `gem install` on NFS shares. Pull request
  [#8123](https://github.com/ruby/rubygems/pull/8123) by
  deivid-rodriguez
* Fix a `gem install` crash during "done installing" hooks. Pull request
  [#8113](https://github.com/ruby/rubygems/pull/8113) by
  deivid-rodriguez
* Fix plugin command loading. Pull request
  [#8121](https://github.com/ruby/rubygems/pull/8121) by
  deivid-rodriguez

## 3.5.21 / 2024-10-03

### Enhancements:

* Fix `Gem::MissingSpecVersionError#to_s` not showing exception message.
  Pull request [#8074](https://github.com/ruby/rubygems/pull/8074) by
  deivid-rodriguez
* Remove code that makes suggest_gems_from_name give worse results. Pull
  request [#8083](https://github.com/ruby/rubygems/pull/8083) by
  duckinator
* Warning about PATH in `--user-install` mode is only necessary for gems
  with executables. Pull request
  [#8071](https://github.com/ruby/rubygems/pull/8071) by
  deivid-rodriguez
* Installs bundler 2.5.21 as a default gem.

### Bug fixes:

* Fix error in one source when fetching dependency APIs clearing results
  from all sources. Pull request
  [#8080](https://github.com/ruby/rubygems/pull/8080) by
  deivid-rodriguez
* Fix `gem cleanup` warning when two versions of psych installed. Pull
  request [#8072](https://github.com/ruby/rubygems/pull/8072) by
  deivid-rodriguez

## 3.5.20 / 2024-09-24

### Enhancements:

* Installs bundler 2.5.20 as a default gem.

## 3.5.19 / 2024-09-18

### Enhancements:

* Standardize pretty-print output for `Gem::Source` and subclasses. Pull
  request [#7994](https://github.com/ruby/rubygems/pull/7994) by
  djberube
* Update vendored `molinillo` to master and vendored `resolv` to 0.4.0.
  Pull request [#7521](https://github.com/ruby/rubygems/pull/7521) by
  hsbt
* Installs bundler 2.5.19 as a default gem.

### Bug fixes:

* Fix `bundle exec rake install` failing when local gem has extensions.
  Pull request [#7977](https://github.com/ruby/rubygems/pull/7977) by
  deivid-rodriguez
* Make `gem exec` use the standard GEM_HOME. Pull request
  [#7982](https://github.com/ruby/rubygems/pull/7982) by
  deivid-rodriguez
* Fix `gem fetch` always exiting with zero status code. Pull request
  [#8007](https://github.com/ruby/rubygems/pull/8007) by
  deivid-rodriguez
* Remove temporary `.lock` files unintentionally left around by gem
  installer. Pull request
  [#7939](https://github.com/ruby/rubygems/pull/7939) by nobu
* Removed unused stringio. Pull request
  [#8001](https://github.com/ruby/rubygems/pull/8001) by hsbt
* Avoid another race condition of open mode. Pull request
  [#7931](https://github.com/ruby/rubygems/pull/7931) by nobu
* Fix `@license` typo preventing licenses from being correctly
  unmarshalled. Pull request
  [#7975](https://github.com/ruby/rubygems/pull/7975) by djberube

### Performance:

* Fix `gem install does-not-exist` being super slow. Pull request
  [#8006](https://github.com/ruby/rubygems/pull/8006) by
  deivid-rodriguez

## 3.5.18 / 2024-08-26

### Enhancements:

* Installs bundler 2.5.18 as a default gem.

### Bug fixes:

* Fix `gem uninstall <name>:<version>` failing on shadowed default gems.
  Pull request [#7949](https://github.com/ruby/rubygems/pull/7949) by
  deivid-rodriguez

## 3.5.17 / 2024-08-01

### Enhancements:

* Explicitly encode `Gem::Dependency` to yaml. Pull request
  [#7867](https://github.com/ruby/rubygems/pull/7867) by segiddins
* Installs bundler 2.5.17 as a default gem.

### Bug fixes:

* Fix `gem list` regression when a regular gem shadows a default one. Pull
  request [#7892](https://github.com/ruby/rubygems/pull/7892) by
  deivid-rodriguez
* Always leave default gem executables around. Pull request
  [#7879](https://github.com/ruby/rubygems/pull/7879) by
  deivid-rodriguez
* Fix line comment issue for hash when loading gemrc. Pull request
  [#7857](https://github.com/ruby/rubygems/pull/7857) by leetking

## 3.5.16 / 2024-07-18

### Enhancements:

* Installs bundler 2.5.16 as a default gem.

### Bug fixes:

* Fix gemspec `require_paths` validation. Pull request
  [#7866](https://github.com/ruby/rubygems/pull/7866) by
  deivid-rodriguez
* Fix loading of nested `gemrc` config keys when specified as symbols.
  Pull request [#7851](https://github.com/ruby/rubygems/pull/7851) by
  moofkit

### Performance:

* Use `caller_locations` instead of splitting `caller`. Pull request
  [#7708](https://github.com/ruby/rubygems/pull/7708) by nobu

## 3.5.15 / 2024-07-09

### Enhancements:

* Installs bundler 2.5.15 as a default gem.

### Bug fixes:

* Restrict generic `arm` to only match 32-bit arm. Pull request
  [#7830](https://github.com/ruby/rubygems/pull/7830) by ntkme
* Protect creating binstubs with a file lock. Pull request
  [#7806](https://github.com/ruby/rubygems/pull/7806) by
  deivid-rodriguez

### Documentation:

* Make it clearer that `add_dependency` is the main way to add
  non-development dependencies. Pull request
  [#7800](https://github.com/ruby/rubygems/pull/7800) by jeromedalbert

## 3.5.14 / 2024-06-21

### Enhancements:

* Installs bundler 2.5.14 as a default gem.

### Bug fixes:

* Make "bundler? update --bundler" behave identically. Pull request
  [#7778](https://github.com/ruby/rubygems/pull/7778) by x-yuri

## 3.5.13 / 2024-06-14

### Enhancements:

* Installs bundler 2.5.13 as a default gem.

### Bug fixes:

* Never remove executables that may belong to a default gem. Pull request
  [#7747](https://github.com/ruby/rubygems/pull/7747) by
  deivid-rodriguez

## 3.5.12 / 2024-06-13

### Enhancements:

* Installs bundler 2.5.12 as a default gem.

### Bug fixes:

* Fix `gem uninstall` unresolved specifications warning. Pull request
  [#7667](https://github.com/ruby/rubygems/pull/7667) by
  deivid-rodriguez
* Fix `gem pristine` sometimes failing to pristine user installed gems.
  Pull request [#7664](https://github.com/ruby/rubygems/pull/7664) by
  deivid-rodriguez

## 3.5.11 / 2024-05-28

### Enhancements:

* Update SPDX license list as of 2024-05-22. Pull request
  [#7689](https://github.com/ruby/rubygems/pull/7689) by
  github-actions[bot]
* Fix the update_rubygems inconsistency (--disable-gems). Pull request
  [#7658](https://github.com/ruby/rubygems/pull/7658) by x-yuri
* Accept WASI as an OS name in Gem::Platform. Pull request
  [#7629](https://github.com/ruby/rubygems/pull/7629) by kateinoigakukun
* Warn if RubyGems version explicitly set in gemspec does not match
  running version. Pull request
  [#7460](https://github.com/ruby/rubygems/pull/7460) by
  deivid-rodriguez
* Installs bundler 2.5.11 as a default gem.

### Bug fixes:

* Fix binstubs sometimes not getting regenerated when `--destdir` is
  given. Pull request
  [#7660](https://github.com/ruby/rubygems/pull/7660) by
  deivid-rodriguez
* Fix `gem uninstall --user-install`  for symlinked HOME. Pull request
  [#7645](https://github.com/ruby/rubygems/pull/7645) by
  deivid-rodriguez
* Fix issue when plugin stubs would sometimes not be properly removed by
  `gem uninstall`. Pull request
  [#7631](https://github.com/ruby/rubygems/pull/7631) by
  deivid-rodriguez
* Fix plugins uninstallation for user installed gems. Pull request
  [#6456](https://github.com/ruby/rubygems/pull/6456) by voxik

### Performance:

* Use a constant empty tar header to avoid extra allocations. Pull request
  [#7484](https://github.com/ruby/rubygems/pull/7484) by segiddins

### Documentation:

* Recommend `bin/rake` over `rake` in contributing docs. Pull request
  [#7648](https://github.com/ruby/rubygems/pull/7648) by
  deivid-rodriguez

## 3.5.10 / 2024-05-03

### Security:

* Add a limit to the size of the metadata and checksums files in a gem
  package. Pull request
  [#7568](https://github.com/ruby/rubygems/pull/7568) by segiddins

### Enhancements:

* Don't fully require `rubygems` from `rubygems/package` to prevent some
  circular require warnings when using Bundler. Pull request
  [#7612](https://github.com/ruby/rubygems/pull/7612) by
  deivid-rodriguez
* Installs bundler 2.5.10 as a default gem.

### Bug fixes:

* Rename credential email to identifier in WebAuthn poller. Pull request
  [#7623](https://github.com/ruby/rubygems/pull/7623) by jenshenny

## 3.5.9 / 2024-04-12

### Enhancements:

* Installs bundler 2.5.9 as a default gem.

## 3.5.8 / 2024-04-11

### Security:

* Respect global umask when writing regular files. Pull request
  [#7518](https://github.com/ruby/rubygems/pull/7518) by
  deivid-rodriguez

### Enhancements:

* Allow string keys with gemrc. Pull request
  [#7543](https://github.com/ruby/rubygems/pull/7543) by hsbt
* [Experimental] Add "gem rebuild" command. Pull request
  [#4913](https://github.com/ruby/rubygems/pull/4913) by duckinator
* Installs bundler 2.5.8 as a default gem.

### Bug fixes:

* Fix NoMethodError crash when building errors about corrupt package
  files. Pull request
  [#7539](https://github.com/ruby/rubygems/pull/7539) by jez
* Fix resolver to properly intersect Arrays of `Gem::Resolver::Activation`
  objects. Pull request
  [#7537](https://github.com/ruby/rubygems/pull/7537) by
  deivid-rodriguez

## 3.5.7 / 2024-03-22

### Enhancements:

* Warn on empty or open required_ruby_version specification attribute.
  Pull request [#5010](https://github.com/ruby/rubygems/pull/5010) by
  simi
* Control whether YAML aliases are enabled in Gem::SafeYAML.safe_load via
  attribute. Pull request
  [#7464](https://github.com/ruby/rubygems/pull/7464) by segiddins
* Update SPDX license list as of 2024-02-08. Pull request
  [#7468](https://github.com/ruby/rubygems/pull/7468) by
  github-actions[bot]
* Installs bundler 2.5.7 as a default gem.

### Bug fixes:

* Allow prerelease activation (even if requirement is not explicit about
  it) when it's the only possibility. Pull request
  [#7428](https://github.com/ruby/rubygems/pull/7428) by kimesf

### Documentation:

* Fix a typo. Pull request
  [#7505](https://github.com/ruby/rubygems/pull/7505) by hsbt
* Use https instead of http in documentation links. Pull request
  [#7481](https://github.com/ruby/rubygems/pull/7481) by hsbt

## 3.5.6 / 2024-02-06

### Enhancements:

* Deep copy requirements in `Gem::Specification` and `Gem::Requirement`.
  Pull request [#7439](https://github.com/ruby/rubygems/pull/7439) by
  flavorjones
* Change gem login message to clear up that username can be also used.
  Pull request [#7422](https://github.com/ruby/rubygems/pull/7422) by
  VitaliySerov
* Add metadata for rubygems.org. Pull request
  [#7435](https://github.com/ruby/rubygems/pull/7435) by m-nakamura145
* Improve gem login scope selection. Pull request
  [#7342](https://github.com/ruby/rubygems/pull/7342) by williantenfen
* Vendor uri in RubyGems. Pull request
  [#7386](https://github.com/ruby/rubygems/pull/7386) by
  deivid-rodriguez
* Installs bundler 2.5.6 as a default gem.

### Bug fixes:

* Skip to load commented out words. Pull request
  [#7413](https://github.com/ruby/rubygems/pull/7413) by hsbt
* Fix rake runtime dependency warning for rake based extension. Pull
  request [#7395](https://github.com/ruby/rubygems/pull/7395) by ntkme

## 3.5.5 / 2024-01-18

### Enhancements:

* Installs bundler 2.5.5 as a default gem.

### Bug fixes:

* Fix `require` activation conflicts when requiring default gems under
  some situations. Pull request
  [#7379](https://github.com/ruby/rubygems/pull/7379) by
  deivid-rodriguez
* Use cache_home instead of data_home in default_spec_cache_dir. Pull
  request [#7331](https://github.com/ruby/rubygems/pull/7331) by mrkn

### Documentation:

* Use squiggly heredocs in `Gem::Specification#description` documentation,
  so it doesn't add leading whitespace. Pull request
  [#7373](https://github.com/ruby/rubygems/pull/7373) by bravehager

## 3.5.4 / 2024-01-04

### Enhancements:

* Always avoid "Updating rubygems-update" message. Pull request
  [#7335](https://github.com/ruby/rubygems/pull/7335) by
  deivid-rodriguez
* Installs bundler 2.5.4 as a default gem.

### Bug fixes:

* Make `gem update --system` respect ruby version constraints. Pull
  request [#7334](https://github.com/ruby/rubygems/pull/7334) by
  deivid-rodriguez

## 3.5.3 / 2023-12-22

### Enhancements:

* Installs bundler 2.5.3 as a default gem.

## 3.5.2 / 2023-12-21

### Enhancements:

* Support dynamic library loading with extension .so or .o. Pull request
  [#7241](https://github.com/ruby/rubygems/pull/7241) by hogelog
* Installs bundler 2.5.2 as a default gem.

### Performance:

* Replace `object_id` comparison with identity Hash. Pull request
  [#7303](https://github.com/ruby/rubygems/pull/7303) by amomchilov
* Use IO.copy_stream when reading, writing. Pull request
  [#6958](https://github.com/ruby/rubygems/pull/6958) by martinemde

## 3.5.1 / 2023-12-15

### Enhancements:

* Installs bundler 2.5.1 as a default gem.

## 3.5.0 / 2023-12-15

### Security:

* Replace `Marshal.load` with a fully-checked safe gemspec loader. Pull
  request [#6896](https://github.com/ruby/rubygems/pull/6896) by
  segiddins

### Breaking changes:

* Drop ruby 2.6 and 2.7 support. Pull request
  [#7116](https://github.com/ruby/rubygems/pull/7116) by
  deivid-rodriguez
* Release package no longer includes test files. Pull request
  [#6781](https://github.com/ruby/rubygems/pull/6781) by hsbt
* Hide `Gem::MockGemUi` from users. Pull request
  [#6623](https://github.com/ruby/rubygems/pull/6623) by hsbt
* Deprecated `Gem.datadir` has been removed. Pull request
  [#6469](https://github.com/ruby/rubygems/pull/6469) by hsbt

### Deprecations:

* Deprecate `Gem::Platform.match?`. Pull request
  [#6783](https://github.com/ruby/rubygems/pull/6783) by hsbt
* Deprecate `Gem::List`. Pull request
  [#6311](https://github.com/ruby/rubygems/pull/6311) by segiddins

### Features:

* The `generate_index` command can now generate compact index files and
  lives as an external `rubygems-generate_index` gem. Pull request
  [#7085](https://github.com/ruby/rubygems/pull/7085) by segiddins
* Make `gem install` fallback to user installation directory if default
  gem home is not writable. Pull request
  [#5327](https://github.com/ruby/rubygems/pull/5327) by duckinator
* Leverage ruby feature to warn when requiring default gems from stdlib
  that will be turned into bundled gems in the future. Pull request
  [#6840](https://github.com/ruby/rubygems/pull/6840) by hsbt

### Performance:

* Use match? when regexp match data is unused. Pull request
  [#7263](https://github.com/ruby/rubygems/pull/7263) by segiddins
* Fewer allocations in gem installation. Pull request
  [#6975](https://github.com/ruby/rubygems/pull/6975) by segiddins
* Optimize allocations in `Gem::Version`. Pull request
  [#6970](https://github.com/ruby/rubygems/pull/6970) by segiddins

### Enhancements:

* Warn for duplicate meta data links when building gems. Pull request
  [#7213](https://github.com/ruby/rubygems/pull/7213) by etherbob
* Vendor `net-http`, `net-protocol`, `resolv`, and `timeout` to reduce
  conflicts between Gemfile gems and internal dependencies. Pull request
  [#6793](https://github.com/ruby/rubygems/pull/6793) by
  deivid-rodriguez
* Remove non-transparent requirement added to prerelease gems. Pull
  request [#7226](https://github.com/ruby/rubygems/pull/7226) by
  deivid-rodriguez
* Stream output from ext builds when --verbose. Pull request
  [#7240](https://github.com/ruby/rubygems/pull/7240) by osyoyu
* Add missing services to CI detection and make it consistent between
  RubyGems and Bundler. Pull request
  [#7205](https://github.com/ruby/rubygems/pull/7205) by nevinera
* Update generate licenses template to not freeze regexps. Pull request
  [#7154](https://github.com/ruby/rubygems/pull/7154) by
  github-actions[bot]
* Don't check `LIBRUBY_RELATIVE` in truffleruby to signal a bash prelude
  in rubygems binstubs. Pull request
  [#7156](https://github.com/ruby/rubygems/pull/7156) by
  deivid-rodriguez
* Update SPDX list and warn on deprecated identifiers. Pull request
  [#6926](https://github.com/ruby/rubygems/pull/6926) by simi
* Simplify extended `require` to potentially fix some deadlocks. Pull
  request [#6827](https://github.com/ruby/rubygems/pull/6827) by nobu
* Small refactors for `Gem::Resolver`. Pull request
  [#6766](https://github.com/ruby/rubygems/pull/6766) by hsbt
* Use double-quotes instead of single-quotes consistently in warnings.
  Pull request [#6550](https://github.com/ruby/rubygems/pull/6550) by
  hsbt
* Add debug message for `nil` version gemspec. Pull request
  [#6436](https://github.com/ruby/rubygems/pull/6436) by hsbt
* Installs bundler 2.5.0 as a default gem.

### Bug fixes:

* Fix installing from source with same default bundler version already
  installed. Pull request
  [#7244](https://github.com/ruby/rubygems/pull/7244) by
  deivid-rodriguez

### Documentation:

* Improve comment explaining the necessity of `write_default_spec` method.
  Pull request [#6563](https://github.com/ruby/rubygems/pull/6563) by
  voxik

## 3.4.22 / 2023-11-09

### Enhancements:

* Update SPDX license list as of 2023-10-05. Pull request
  [#7040](https://github.com/ruby/rubygems/pull/7040) by
  github-actions[bot]
* Remove unnecessary rescue. Pull request
  [#7109](https://github.com/ruby/rubygems/pull/7109) by
  deivid-rodriguez
* Installs bundler 2.4.22 as a default gem.

### Bug fixes:

* Handle empty array at built-in YAML serializer. Pull request
  [#7099](https://github.com/ruby/rubygems/pull/7099) by hsbt
* Ignore non-tar format `.gem` files during search. Pull request
  [#7095](https://github.com/ruby/rubygems/pull/7095) by dearblue
* Allow explicitly uninstalling multiple versions of same gem. Pull
  request [#7063](https://github.com/ruby/rubygems/pull/7063) by
  kstevens715

### Performance:

* Avoid regexp match on every call to `Gem::Platform.local`. Pull request
  [#7104](https://github.com/ruby/rubygems/pull/7104) by segiddins

### Documentation:

* Get `Gem::Specification#extensions_dir` documented. Pull request
  [#6218](https://github.com/ruby/rubygems/pull/6218) by
  deivid-rodriguez

## 3.4.21 / 2023-10-17

### Enhancements:

* Abort `setup.rb` if Ruby is too old. Pull request
  [#7011](https://github.com/ruby/rubygems/pull/7011) by
  deivid-rodriguez
* Remove usage of Dir.chdir that only execute a subprocess. Pull request
  [#6930](https://github.com/ruby/rubygems/pull/6930) by segiddins
* Freeze more strings in generated gemspecs. Pull request
  [#6974](https://github.com/ruby/rubygems/pull/6974) by segiddins
* Use pure-ruby YAML parser for loading configuration at RubyGems. Pull
  request [#6615](https://github.com/ruby/rubygems/pull/6615) by hsbt
* Installs bundler 2.4.21 as a default gem.

### Documentation:

* Update suggested variable for bindir. Pull request
  [#7028](https://github.com/ruby/rubygems/pull/7028) by hsbt
* Fix invalid links in documentation. Pull request
  [#7008](https://github.com/ruby/rubygems/pull/7008) by simi

## 3.4.20 / 2023-09-27

### Enhancements:

* Raise `Gem::Package::FormatError` when gem encounters corrupt EOF.
  Pull request [#6882](https://github.com/ruby/rubygems/pull/6882)
  by martinemde
* Allow skipping empty license `gem build` warning by setting license to
  `nil`. Pull request
  [#6879](https://github.com/ruby/rubygems/pull/6879) by jhong97
* Update SPDX license list as of 2023-06-18. Pull request
  [#6891](https://github.com/ruby/rubygems/pull/6891) by
  github-actions[bot]
* Update SPDX license list as of 2023-04-28. Pull request
  [#6642](https://github.com/ruby/rubygems/pull/6642) by segiddins
* Update SPDX license list as of 2023-01-26. Pull request
  [#6310](https://github.com/ruby/rubygems/pull/6310) by segiddins
* Installs bundler 2.4.20 as a default gem.

### Bug fixes:

* Fixed false positive SymlinkError in symbolic link directory. Pull
  request [#6947](https://github.com/ruby/rubygems/pull/6947) by
  negi0109
* Ensure that loading multiple gemspecs with legacy YAML class references
  does not warn. Pull request
  [#6889](https://github.com/ruby/rubygems/pull/6889) by segiddins
* Fix NoMethodError when choosing a too big number from `gem uni` list.
  Pull request [#6901](https://github.com/ruby/rubygems/pull/6901) by
  amatsuda

### Performance:

* Reduce allocations for stub specifications. Pull request
  [#6972](https://github.com/ruby/rubygems/pull/6972) by segiddins

## 3.4.19 / 2023-08-17

### Enhancements:

* Installs bundler 2.4.19 as a default gem.

### Performance:

* Speedup building docs when updating rubygems. Pull request
  [#6864](https://github.com/ruby/rubygems/pull/6864) by
  deivid-rodriguez

## 3.4.18 / 2023-08-02

### Enhancements:

* Add poller to fetch WebAuthn OTP. Pull request
  [#6774](https://github.com/ruby/rubygems/pull/6774) by jenshenny
* Remove side effects when unmarshaling old `Gem::Specification`. Pull
  request [#6825](https://github.com/ruby/rubygems/pull/6825) by nobu
* Ship rubygems executables in `exe` folder. Pull request
  [#6704](https://github.com/ruby/rubygems/pull/6704) by hsbt
* Installs bundler 2.4.18 as a default gem.

## 3.4.17 / 2023-07-14

### Enhancements:

* Installs bundler 2.4.17 as a default gem.

### Performance:

* Avoid unnecessary work for private local gem installation. Pull request
  [#6810](https://github.com/ruby/rubygems/pull/6810) by
  deivid-rodriguez

## 3.4.16 / 2023-07-10

### Enhancements:

* Installs bundler 2.4.16 as a default gem.

## 3.4.15 / 2023-06-29

### Enhancements:

* Installs bundler 2.4.15 as a default gem.

### Bug fixes:

* Autoload shellwords when it's needed. Pull request
  [#6734](https://github.com/ruby/rubygems/pull/6734) by ioquatix

### Documentation:

* Update command to test local gem command changes. Pull request
  [#6761](https://github.com/ruby/rubygems/pull/6761) by jenshenny

## 3.4.14 / 2023-06-12

### Enhancements:

* Load plugin immediately. Pull request
  [#6673](https://github.com/ruby/rubygems/pull/6673) by kou
* Installs bundler 2.4.14 as a default gem.

### Documentation:

* Clarify what the `rubygems-update` gem is for, and link to source code
  and guides. Pull request
  [#6710](https://github.com/ruby/rubygems/pull/6710) by davetron5000

## 3.4.13 / 2023-05-09

### Enhancements:

* Installs bundler 2.4.13 as a default gem.

## 3.4.12 / 2023-04-11

### Enhancements:

* [Experimental] Add WebAuthn Support to the CLI. Pull request
  [#6560](https://github.com/ruby/rubygems/pull/6560) by jenshenny
* Installs bundler 2.4.12 as a default gem.

## 3.4.11 / 2023-04-10

### Enhancements:

* Installs bundler 2.4.11 as a default gem.

## 3.4.10 / 2023-03-27

### Enhancements:

* Installs bundler 2.4.10 as a default gem.

## 3.4.9 / 2023-03-20

### Enhancements:

* Improve `TarHeader#calculate_checksum` speed and readability. Pull
  request [#6476](https://github.com/ruby/rubygems/pull/6476) by
  Maumagnaguagno
* Added only missing extensions option into pristine command. Pull request
  [#6446](https://github.com/ruby/rubygems/pull/6446) by hsbt
* Installs bundler 2.4.9 as a default gem.

### Bug fixes:

* Fix `$LOAD_PATH` in rake and ext_conf builder. Pull request
  [#6490](https://github.com/ruby/rubygems/pull/6490) by ntkme
* Fix `gem uninstall` with `--install-dir`. Pull request
  [#6481](https://github.com/ruby/rubygems/pull/6481) by
  deivid-rodriguez

### Documentation:

* Document our current release policy. Pull request
  [#6450](https://github.com/ruby/rubygems/pull/6450) by
  deivid-rodriguez

## 3.4.8 / 2023-03-08

### Enhancements:

* Add TarReader::Entry#seek to seek within the tar file entry. Pull
  request [#6390](https://github.com/ruby/rubygems/pull/6390) by
  martinemde
* Avoid calling String#dup in Gem::Version#marshal_dump. Pull request
  [#6438](https://github.com/ruby/rubygems/pull/6438) by segiddins
* Remove hardcoded "master" branch references. Pull request
  [#6425](https://github.com/ruby/rubygems/pull/6425) by
  deivid-rodriguez
* [Experimental] Add `gem exec` command to run executables from gems that
  may or may not be installed. Pull request
  [#6309](https://github.com/ruby/rubygems/pull/6309) by segiddins
* Installs bundler 2.4.8 as a default gem.

### Bug fixes:

* Fix installation error of same version of default gems with local
  installation. Pull request
  [#6430](https://github.com/ruby/rubygems/pull/6430) by hsbt
* Use proper memoized var name for Gem.state_home. Pull request
  [#6420](https://github.com/ruby/rubygems/pull/6420) by simi

### Documentation:

* Switch supporting explanations to all Ruby Central. Pull request
  [#6419](https://github.com/ruby/rubygems/pull/6419) by indirect
* Update the link to OpenSource.org. Pull request
  [#6392](https://github.com/ruby/rubygems/pull/6392) by nobu

## 3.4.7 / 2023-02-15

### Enhancements:

* Warn on self referencing gemspec dependency. Pull request
  [#6335](https://github.com/ruby/rubygems/pull/6335) by simi
* Installs bundler 2.4.7 as a default gem.

### Bug fixes:

* Fix inconsistent behavior of zero byte files in archive. Pull request
  [#6329](https://github.com/ruby/rubygems/pull/6329) by martinemde

## 3.4.6 / 2023-01-31

### Enhancements:

* Allow `require` decorations be disabled. Pull request
  [#6319](https://github.com/ruby/rubygems/pull/6319) by
  deivid-rodriguez
* Installs bundler 2.4.6 as a default gem.

### Bug fixes:

* Include directory in CargoBuilder install path. Pull request
  [#6298](https://github.com/ruby/rubygems/pull/6298) by matsadler

### Documentation:

* Include links to pull requests in changelog. Pull request
  [#6316](https://github.com/ruby/rubygems/pull/6316) by
  deivid-rodriguez

## 3.4.5 / 2023-01-21

### Enhancements:

* Installs bundler 2.4.5 as a default gem.

## 3.4.4 / 2023-01-16

### Enhancements:

* Installs bundler 2.4.4 as a default gem.

### Documentation:

* Improve documentation about `Kernel` monkeypatches. Pull request [#6217](https://github.com/ruby/rubygems/pull/6217)
  by nobu

## 3.4.3 / 2023-01-06

### Enhancements:

* Installs bundler 2.4.3 as a default gem.

### Documentation:

* Fix several typos. Pull request [#6224](https://github.com/ruby/rubygems/pull/6224) by jdufresne

## 3.4.2 / 2023-01-01

### Enhancements:

* Add global flag (`-C`) to change execution directory. Pull request [#6180](https://github.com/ruby/rubygems/pull/6180)
  by gustavothecoder
* Installs bundler 2.4.2 as a default gem.

## 3.4.1 / 2022-12-24

### Enhancements:

* Installs bundler 2.4.1 as a default gem.

## 3.4.0 / 2022-12-24

### Breaking changes:

* Drop support for Ruby 2.3, 2.4, 2.5 and RubyGems 2.5, 2.6, 2.7. Pull
  request [#6107](https://github.com/ruby/rubygems/pull/6107) by deivid-rodriguez
* Remove support for deprecated OS. Pull request [#6041](https://github.com/ruby/rubygems/pull/6041) by peterzhu2118

### Features:

* Add 'call for update' to RubyGems install command. Pull request [#5922](https://github.com/ruby/rubygems/pull/5922) by
  simi

### Enhancements:

* Add `mswin` support for cargo builder. Pull request [#6167](https://github.com/ruby/rubygems/pull/6167) by ianks
* Validate Cargo.lock is present for Rust based extensions. Pull request
  [#6151](https://github.com/ruby/rubygems/pull/6151) by simi
* Clean built artifacts after building extensions. Pull request [#6133](https://github.com/ruby/rubygems/pull/6133) by
  deivid-rodriguez
* Installs bundler 2.4.0 as a default gem.

### Bug fixes:

* Fix crash due to `BundlerVersionFinder` not defined. Pull request [#6152](https://github.com/ruby/rubygems/pull/6152)
  by deivid-rodriguez
* Don't leave corrupted partial package download around when running out
  of disk space. Pull request [#5681](https://github.com/ruby/rubygems/pull/5681) by duckinator

## 3.3.26 / 2022-11-16

### Enhancements:

* Upgrade rb-sys to 0.9.37. Pull request [#6047](https://github.com/ruby/rubygems/pull/6047) by ianks
* Installs bundler 2.3.26 as a default gem.

## 3.3.25 / 2022-11-02

### Enhancements:

* Github source should default to secure protocol. Pull request [#6026](https://github.com/ruby/rubygems/pull/6026) by
  jasonkarns
* Allow upcoming JRuby to pass keywords to Kernel#warn. Pull request [#6002](https://github.com/ruby/rubygems/pull/6002)
  by enebo
* Installs bundler 2.3.25 as a default gem.

## 3.3.24 / 2022-10-17

### Enhancements:

* Installs bundler 2.3.24 as a default gem.

## 3.3.23 / 2022-10-05

### Enhancements:

* Add better error handling for permanent redirect responses. Pull request
  [#5931](https://github.com/ruby/rubygems/pull/5931) by jenshenny
* Installs bundler 2.3.23 as a default gem.

### Bug fixes:

* Fix generic arm platform matching against runtime arm platforms with
  eabi modifiers. Pull request [#5957](https://github.com/ruby/rubygems/pull/5957) by deivid-rodriguez
* Fix `Gem::Platform.match` not handling String argument properly. Pull
  request [#5939](https://github.com/ruby/rubygems/pull/5939) by flavorjones
* Fix resolution on non-musl platforms. Pull request [#5915](https://github.com/ruby/rubygems/pull/5915) by
  deivid-rodriguez
* Mask the file mode when extracting files. Pull request [#5906](https://github.com/ruby/rubygems/pull/5906) by
  kddnewton

## 3.3.22 / 2022-09-07

### Enhancements:

* Support non gnu libc arm-linux-eabi platforms. Pull request [#5889](https://github.com/ruby/rubygems/pull/5889) by
  ntkme
* Installs bundler 2.3.22 as a default gem.

### Bug fixes:

* Fix `gem info` with explicit `--version`. Pull request [#5884](https://github.com/ruby/rubygems/pull/5884) by
  tonyaraujop

## 3.3.21 / 2022-08-24

### Enhancements:

* Support non gnu libc linux platforms. Pull request [#5852](https://github.com/ruby/rubygems/pull/5852) by
  deivid-rodriguez
* Installs bundler 2.3.21 as a default gem.

## 3.3.20 / 2022-08-10

### Enhancements:

* Include backtrace with crashes by default. Pull request [#5811](https://github.com/ruby/rubygems/pull/5811) by
  deivid-rodriguez
* Don't create broken symlinks when a gem includes them, but print a
  warning instead. Pull request [#5801](https://github.com/ruby/rubygems/pull/5801) by deivid-rodriguez
* Warn (rather than crash) when setting `nil` specification versions. Pull
  request [#5794](https://github.com/ruby/rubygems/pull/5794) by deivid-rodriguez
* Installs bundler 2.3.20 as a default gem.

### Bug fixes:

* Always consider installed specs for resolution, even if prereleases.
  Pull request [#5821](https://github.com/ruby/rubygems/pull/5821) by deivid-rodriguez
* Fix `gem install` with `--platform` flag not matching simulated platform
  correctly. Pull request [#5820](https://github.com/ruby/rubygems/pull/5820) by deivid-rodriguez
* Fix platform matching for index specs. Pull request [#5795](https://github.com/ruby/rubygems/pull/5795) by Ilushkanama

## 3.3.19 / 2022-07-27

### Enhancements:

* Display mfa warnings on `gem signin`. Pull request [#5590](https://github.com/ruby/rubygems/pull/5590) by aellispierce
* Require fileutils more lazily when installing gems. Pull request [#5738](https://github.com/ruby/rubygems/pull/5738)
  by deivid-rodriguez
* Fix upgrading RubyGems with a customized `Gem.default_dir`. Pull request
  [#5728](https://github.com/ruby/rubygems/pull/5728) by deivid-rodriguez
* Stop using `/dev/null` for silent ui for WASI platform. Pull request
  [#5703](https://github.com/ruby/rubygems/pull/5703) by kateinoigakukun
* Unify loading `Gem::Requirement`. Pull request [#5596](https://github.com/ruby/rubygems/pull/5596) by deivid-rodriguez
* Installs bundler 2.3.19 as a default gem.

### Bug fixes:

* Fix `ruby setup.rb` with `--destdir` writing outside of `--destdir`.
  Pull request [#5737](https://github.com/ruby/rubygems/pull/5737) by deivid-rodriguez

### Documentation:

* Fix wrong information about default RubyGems source. Pull request [#5723](https://github.com/ruby/rubygems/pull/5723)
  by tnir

## 3.3.18 / 2022-07-14

### Enhancements:

* Make platform `universal-mingw32` match "x64-mingw-ucrt". Pull request
  [#5655](https://github.com/ruby/rubygems/pull/5655) by johnnyshields
* Add more descriptive messages when `gem update` fails to update some
  gems. Pull request [#5676](https://github.com/ruby/rubygems/pull/5676) by brianleshopify
* Installs bundler 2.3.18 as a default gem.

### Bug fixes:

* Make sure RubyGems prints no warnings when loading plugins. Pull request
  [#5607](https://github.com/ruby/rubygems/pull/5607) by deivid-rodriguez

## 3.3.17 / 2022-06-29

### Enhancements:

* Document `gem env` argument aliases and add `gem env user_gemhome` and
  `gem env user_gemdir`. Pull request [#5644](https://github.com/ruby/rubygems/pull/5644) by deivid-rodriguez
* Improve error message when `operating_system.rb` fails to load. Pull
  request [#5658](https://github.com/ruby/rubygems/pull/5658) by deivid-rodriguez
* Clean up temporary directory after `generate_index --update`. Pull
  request [#5653](https://github.com/ruby/rubygems/pull/5653) by graywolf-at-work
* Simplify extension builder. Pull request [#5626](https://github.com/ruby/rubygems/pull/5626) by deivid-rodriguez
* Installs bundler 2.3.17 as a default gem.

### Documentation:

* Modify RubyGems issue template to be like the one for Bundler. Pull
  request [#5643](https://github.com/ruby/rubygems/pull/5643) by deivid-rodriguez

## 3.3.16 / 2022-06-15

### Enhancements:

* Auto-fix and warn gem packages including a gemspec with `require_paths`
  as an array of arrays. Pull request [#5615](https://github.com/ruby/rubygems/pull/5615) by deivid-rodriguez
* Misc cargo builder improvements. Pull request [#5459](https://github.com/ruby/rubygems/pull/5459) by ianks
* Installs bundler 2.3.16 as a default gem.

### Bug fixes:

* Fix incorrect password redaction when there's an error in `gem source
  -a`. Pull request [#5623](https://github.com/ruby/rubygems/pull/5623) by deivid-rodriguez
* Fix another regression when loading old marshaled specs. Pull request
  [#5610](https://github.com/ruby/rubygems/pull/5610) by deivid-rodriguez

## 3.3.15 / 2022-06-01

### Enhancements:

* Support the change of did_you_mean about `Exception#detailed_message`.
  Pull request [#5560](https://github.com/ruby/rubygems/pull/5560) by mame
* Installs bundler 2.3.15 as a default gem.

### Bug fixes:

* Fix loading old marshaled specs including `YAML::PrivateType` constant.
  Pull request [#5415](https://github.com/ruby/rubygems/pull/5415) by deivid-rodriguez
* Fix rubygems update when non default `--install-dir` is configured. Pull
  request [#5566](https://github.com/ruby/rubygems/pull/5566) by deivid-rodriguez

## 3.3.14 / 2022-05-18

### Enhancements:

* Installs bundler 2.3.14 as a default gem.

## 3.3.13 / 2022-05-04

### Enhancements:

* Installs bundler 2.3.13 as a default gem.

### Bug fixes:

* Fix regression when resolving ruby constraints. Pull request [#5486](https://github.com/ruby/rubygems/pull/5486) by
  deivid-rodriguez

### Documentation:

* Clarify description of owner-flags. Pull request [#5497](https://github.com/ruby/rubygems/pull/5497) by kronn

## 3.3.12 / 2022-04-20

### Enhancements:

* Less error swallowing when installing gems. Pull request [#5475](https://github.com/ruby/rubygems/pull/5475) by
  deivid-rodriguez
* Stop considering `RUBY_PATCHLEVEL` for resolution. Pull request [#5472](https://github.com/ruby/rubygems/pull/5472) by
  deivid-rodriguez
* Bump vendored optparse to latest master. Pull request [#5466](https://github.com/ruby/rubygems/pull/5466) by
  deivid-rodriguez
* Installs bundler 2.3.12 as a default gem.

### Documentation:

* Fix formatting in docs. Pull request [#5470](https://github.com/ruby/rubygems/pull/5470) by peterzhu2118
* Fix a typo. Pull request [#5401](https://github.com/ruby/rubygems/pull/5401) by znz

## 3.3.11 / 2022-04-07

### Enhancements:

* Enable mfa on specific keys during gem signin. Pull request [#5305](https://github.com/ruby/rubygems/pull/5305) by
  aellispierce
* Prefer `__dir__` to `__FILE__`. Pull request [#5444](https://github.com/ruby/rubygems/pull/5444) by deivid-rodriguez
* Add cargo builder for rust extensions. Pull request [#5175](https://github.com/ruby/rubygems/pull/5175) by ianks
* Installs bundler 2.3.11 as a default gem.

### Documentation:

* Improve RDoc setup. Pull request [#5398](https://github.com/ruby/rubygems/pull/5398) by deivid-rodriguez

## 3.3.10 / 2022-03-23

### Enhancements:

* Installs bundler 2.3.10 as a default gem.

### Documentation:

* Enable `Gem::Package` example in RDoc documentation. Pull request [#5399](https://github.com/ruby/rubygems/pull/5399)
  by nobu
* Unhide RDoc documentation from top level `Gem` module. Pull request
  [#5396](https://github.com/ruby/rubygems/pull/5396) by nobu

## 3.3.9 / 2022-03-09

### Enhancements:

* Installs bundler 2.3.9 as a default gem.

## 3.3.8 / 2022-02-23

### Enhancements:

* Installs bundler 2.3.8 as a default gem.

## 3.3.7 / 2022-02-09

### Enhancements:

* Installs bundler 2.3.7 as a default gem.

### Documentation:

* Fix missing rdoc for `Gem::Version`. Pull request [#5299](https://github.com/ruby/rubygems/pull/5299) by nevans

## 3.3.6 / 2022-01-26

### Enhancements:

* Forbid downgrading past the originally shipped version on Ruby 3.1. Pull
  request [#5301](https://github.com/ruby/rubygems/pull/5301) by deivid-rodriguez
* Support `--enable-load-relative` inside binstubs. Pull request [#2929](https://github.com/ruby/rubygems/pull/2929) by
  deivid-rodriguez
* Let `Version#<=>` accept a String. Pull request [#5275](https://github.com/ruby/rubygems/pull/5275) by amatsuda
* Installs bundler 2.3.6 as a default gem.

### Bug fixes:

* Avoid `flock` on non Windows systems, since it causing issues on NFS
  file systems. Pull request [#5278](https://github.com/ruby/rubygems/pull/5278) by deivid-rodriguez
* Fix `gem update --system`  for already installed version of
  `rubygems-update`. Pull request [#5285](https://github.com/ruby/rubygems/pull/5285) by loadkpi

## 3.3.5 / 2022-01-12

### Enhancements:

* Don't activate `yaml` gem from RubyGems. Pull request [#5266](https://github.com/ruby/rubygems/pull/5266) by
  deivid-rodriguez
* Let `gem fetch` understand `<gem>:<version>` syntax and
  `--[no-]suggestions` flag. Pull request [#5242](https://github.com/ruby/rubygems/pull/5242) by ximenasandoval
* Installs bundler 2.3.5 as a default gem.

### Bug fixes:

* Fix `gem install <non-existent-gem> --force` crash. Pull request [#5262](https://github.com/ruby/rubygems/pull/5262)
  by deivid-rodriguez
* Fix longstanding `gem install` failure on JRuby. Pull request [#5228](https://github.com/ruby/rubygems/pull/5228) by
  deivid-rodriguez

### Documentation:

* Markup `Gem::Specification` documentation with RDoc notations. Pull
  request [#5268](https://github.com/ruby/rubygems/pull/5268) by nobu

## 3.3.4 / 2021-12-29

### Enhancements:

* Don't redownload `rubygems-update` package if already there. Pull
  request [#5230](https://github.com/ruby/rubygems/pull/5230) by deivid-rodriguez
* Installs bundler 2.3.4 as a default gem.

### Bug fixes:

* Fix `gem update --system` crashing when latest version not supported.
  Pull request [#5191](https://github.com/ruby/rubygems/pull/5191) by deivid-rodriguez

### Performance:

* Make SpecificationPolicy autoload constant. Pull request [#5222](https://github.com/ruby/rubygems/pull/5222) by pocke

## 3.3.3 / 2021-12-24

### Enhancements:

* Installs bundler 2.3.3 as a default gem.

### Bug fixes:

* Fix gem installation failing in Solaris due to bad `IO#flock` usage.
  Pull request [#5216](https://github.com/ruby/rubygems/pull/5216) by mame

## 3.3.2 / 2021-12-23

### Enhancements:

* Fix deprecations when activating DidYouMean for misspelled command
  suggestions. Pull request [#5211](https://github.com/ruby/rubygems/pull/5211) by yuki24
* Installs bundler 2.3.2 as a default gem.

### Bug fixes:

* Fix gemspec truncation. Pull request [#5208](https://github.com/ruby/rubygems/pull/5208) by deivid-rodriguez

## 3.3.1 / 2021-12-22

### Enhancements:

* Fix compatibility with OpenSSL 3.0. Pull request [#5196](https://github.com/ruby/rubygems/pull/5196) by rhenium
* Remove hard errors when matching major bundler not found. Pull request
  [#5181](https://github.com/ruby/rubygems/pull/5181) by deivid-rodriguez
* Installs bundler 2.3.1 as a default gem.

## 3.3.0 / 2021-12-21

### Breaking changes:

* Removed deprecated `gem server` command. Pull request [#5034](https://github.com/ruby/rubygems/pull/5034) by hsbt
* Remove macOS specific gem layout. Pull request [#4833](https://github.com/ruby/rubygems/pull/4833) by deivid-rodriguez
* Default `gem update` documentation format is now only `ri`. Pull request
  [#3888](https://github.com/ruby/rubygems/pull/3888) by hsbt

### Features:

* Give command misspelled suggestions via `did_you_mean` gem. Pull request
  [#3904](https://github.com/ruby/rubygems/pull/3904) by hsbt

### Performance:

* Avoid some unnecessary stat calls. Pull request [#3887](https://github.com/ruby/rubygems/pull/3887) by kares
* Improve spell checking suggestion performance by
  vendoring`DidYouMean::Levenshtein.distance` from `did_you_mean-1.4.0`.
  Pull request [#3856](https://github.com/ruby/rubygems/pull/3856) by austinpray

### Enhancements:

* Set `BUNDLER_VERSION` when `bundle _<version>_` is passed. Pull request
  [#5180](https://github.com/ruby/rubygems/pull/5180) by deivid-rodriguez
* Don't require `rdoc` for `gem uninstall`. Pull request [#4691](https://github.com/ruby/rubygems/pull/4691) by ndren
* More focused rescue on extension builder exception to get more
  information on errors. Pull request [#4189](https://github.com/ruby/rubygems/pull/4189) by deivid-rodriguez
* Installs bundler 2.3.0 as a default gem.

### Bug fixes:

* Fix encoding mismatch issues when writing gem packages. Pull request
  [#5162](https://github.com/ruby/rubygems/pull/5162) by deivid-rodriguez
* Fix broken brew formula due to loading `operating_system.rb`
  customizations too late. Pull request [#5154](https://github.com/ruby/rubygems/pull/5154) by deivid-rodriguez
* Properly fetch `Gem#latest_spec_for` with multiple sources. Pull request
  [#2764](https://github.com/ruby/rubygems/pull/2764) by kevlogan90
* Fix upgrade crashing when multiple versions of `fileutils` installed.
  Pull request [#5140](https://github.com/ruby/rubygems/pull/5140) by deivid-rodriguez

## 3.2.33 / 2021-12-07

### Deprecations:

* Deprecate typo name. Pull request [#5109](https://github.com/ruby/rubygems/pull/5109) by nobu

### Enhancements:

* Add login & logout alias for the signin & signout commands. Pull request
  [#5133](https://github.com/ruby/rubygems/pull/5133) by colby-swandale
* Fix race conditions when reading & writing gemspecs concurrently. Pull
  request [#4408](https://github.com/ruby/rubygems/pull/4408) by deivid-rodriguez
* Installs bundler 2.2.33 as a default gem.

### Bug fixes:

* Fix `ruby setup.rb` trying to write outside of `--destdir`. Pull request
  [#5053](https://github.com/ruby/rubygems/pull/5053) by deivid-rodriguez

### Documentation:

* Move required_ruby_version gemspec attribute to recommended section.
  Pull request [#5130](https://github.com/ruby/rubygems/pull/5130) by simi
* Ignore to generate the documentation from vendored libraries. Pull
  request [#5118](https://github.com/ruby/rubygems/pull/5118) by hsbt

## 3.2.32 / 2021-11-23

### Enhancements:

* Refactor installer thread safety protections. Pull request [#5050](https://github.com/ruby/rubygems/pull/5050) by
  deivid-rodriguez
* Allow gem activation from `operating_system.rb`. Pull request [#5044](https://github.com/ruby/rubygems/pull/5044) by
  deivid-rodriguez
* Installs bundler 2.2.32 as a default gem.

## 3.2.31 / 2021-11-08

### Enhancements:

* Don't pass empty `DESTDIR` to `nmake` since it works differently from
  standard `make`. Pull request [#5057](https://github.com/ruby/rubygems/pull/5057) by hsbt
* Fix `gem install` vs `gem fetch` inconsistency. Pull request [#5037](https://github.com/ruby/rubygems/pull/5037) by
  deivid-rodriguez
* Lazily load and vendor `optparse`. Pull request [#4881](https://github.com/ruby/rubygems/pull/4881) by
  deivid-rodriguez
* Use a vendored copy of `tsort` internally. Pull request [#5027](https://github.com/ruby/rubygems/pull/5027) by
  deivid-rodriguez
* Install bundler 2.2.31 as a default gem.

### Bug fixes:

* Fix `ruby setup.rb` when `--prefix` is passed. Pull request [#5051](https://github.com/ruby/rubygems/pull/5051) by
  deivid-rodriguez
* Don't apply `--destdir` twice when running `setup.rb`. Pull request
  [#2768](https://github.com/ruby/rubygems/pull/2768) by alyssais

## 3.2.30 / 2021-10-26

### Enhancements:

* Add support to build and sign certificates with multiple key algorithms.
  Pull request [#4991](https://github.com/ruby/rubygems/pull/4991) by doodzik
* Avoid loading the `digest` gem unnecessarily. Pull request [#4979](https://github.com/ruby/rubygems/pull/4979) by
  deivid-rodriguez
* Prefer `require_relative` for all internal requires. Pull request [#4978](https://github.com/ruby/rubygems/pull/4978)
  by deivid-rodriguez
* Add missing `require` of `time` within
  `Gem::Request.verify_certificate_message`. Pull request [#4975](https://github.com/ruby/rubygems/pull/4975) by nobu
* Install bundler 2.2.30 as a default gem.

### Performance:

* Speed up `gem install`, specially under Windows. Pull request [#4960](https://github.com/ruby/rubygems/pull/4960) by
  deivid-rodriguez

## 3.2.29 / 2021-10-08

### Enhancements:

* Only disallow FIXME/TODO for first word of gemspec description. Pull
  request [#4937](https://github.com/ruby/rubygems/pull/4937) by duckinator
* Install bundler 2.2.29 as a default gem.

### Bug fixes:

* Fix `wordy` method in `SourceFetchProblem` changing the password of
  source. Pull request [#4910](https://github.com/ruby/rubygems/pull/4910) by Huangxiaodui

### Performance:

* Improve `require` performance, particularly on systems with a lot of
  gems installed. Pull request [#4951](https://github.com/ruby/rubygems/pull/4951) by pocke

## 3.2.28 / 2021-09-23

### Enhancements:

* Support MINGW-UCRT. Pull request [#4925](https://github.com/ruby/rubygems/pull/4925) by hsbt
* Only check if descriptions *start with* FIXME/TODO. Pull request [#4841](https://github.com/ruby/rubygems/pull/4841)
  by duckinator
* Avoid loading `uri` unnecessarily when activating gems. Pull request
  [#4897](https://github.com/ruby/rubygems/pull/4897) by deivid-rodriguez
* Install bundler 2.2.28 as a default gem.

### Bug fixes:

* Fix redacted credentials being sent to gemserver. Pull request [#4919](https://github.com/ruby/rubygems/pull/4919) by
  jdliss

## 3.2.27 / 2021-09-03

### Enhancements:

* Redact credentials when printing URI. Pull request [#4868](https://github.com/ruby/rubygems/pull/4868) by intuxicated
* Prefer `require_relative` to `require` for internal requires. Pull
  request [#4858](https://github.com/ruby/rubygems/pull/4858) by deivid-rodriguez
* Prioritise gems with higher version for fetching metadata, and stop
  fetching once we find a valid candidate. Pull request [#4843](https://github.com/ruby/rubygems/pull/4843) by intuxicated
* Install bundler 2.2.27 as a default gem.

## 3.2.26 / 2021-08-17

### Enhancements:

* Enhance the error handling for loading the
  `rubygems/defaults/operating_system` file. Pull request [#4824](https://github.com/ruby/rubygems/pull/4824) by
  intuxicated
* Ignore `RUBYGEMS_GEMDEPS` for the bundler gem. Pull request [#4532](https://github.com/ruby/rubygems/pull/4532) by
  deivid-rodriguez
* Install bundler 2.2.26 as a default gem.

### Bug fixes:

* Also load user installed rubygems plugins. Pull request [#4829](https://github.com/ruby/rubygems/pull/4829) by
  deivid-rodriguez

## 3.2.25 / 2021-07-30

### Enhancements:

* Don't load the `base64` library since it's not used. Pull request [#4785](https://github.com/ruby/rubygems/pull/4785)
  by deivid-rodriguez
* Don't load the `resolv` library since it's not used. Pull request [#4784](https://github.com/ruby/rubygems/pull/4784)
  by deivid-rodriguez
* Lazily load `shellwords` library. Pull request [#4783](https://github.com/ruby/rubygems/pull/4783) by deivid-rodriguez
* Check requirements class before loading marshalled requirements. Pull
  request [#4651](https://github.com/ruby/rubygems/pull/4651) by nobu
* Install bundler 2.2.25 as a default gem.

### Bug fixes:

* Add missing `require 'fileutils'` in `Gem::ConfigFile`. Pull request
  [#4768](https://github.com/ruby/rubygems/pull/4768) by ybiquitous

## 3.2.24 / 2021-07-15

### Enhancements:

* Install bundler 2.2.24 as a default gem.

### Bug fixes:

* Fix contradictory message about deletion of default gem. Pull request
  [#4739](https://github.com/ruby/rubygems/pull/4739) by jaredbeck

### Documentation:

* Add a description about `GEM_HOST_OTP_CODE` to help text. Pull request
  [#4742](https://github.com/ruby/rubygems/pull/4742) by ybiquitous

## 3.2.23 / 2021-07-09

### Enhancements:

* Rewind IO source to allow working with contents in memory. Pull request
  [#4729](https://github.com/ruby/rubygems/pull/4729) by drcapulet
* Install bundler 2.2.23 as a default gem.

## 3.2.22 / 2021-07-06

### Enhancements:

* Allow setting `--otp` via `GEM_HOST_OTP_CODE`. Pull request [#4697](https://github.com/ruby/rubygems/pull/4697) by
  CGA1123
* Fixes for the edge case when openssl library is missing. Pull request
  [#4695](https://github.com/ruby/rubygems/pull/4695) by rhenium
* Install bundler 2.2.22 as a default gem.

## 3.2.21 / 2021-06-23

### Enhancements:

* Fix typo in OpenSSL detection. Pull request [#4679](https://github.com/ruby/rubygems/pull/4679) by osyoyu
* Add the most recent licenses from spdx.org. Pull request [#4662](https://github.com/ruby/rubygems/pull/4662) by nobu
* Simplify setup.rb code to allow installing rubygems from source on
  truffleruby 21.0 and 21.1. Pull request [#4624](https://github.com/ruby/rubygems/pull/4624) by deivid-rodriguez
* Install bundler 2.2.21 as a default gem.

### Bug fixes:

* Create credentials folder when setting API keys if not there yet. Pull
  request [#4665](https://github.com/ruby/rubygems/pull/4665) by deivid-rodriguez

## 3.2.20 / 2021-06-11

### Security fixes:

* Verify platform before installing to avoid potential remote code
  execution. Pull request [#4667](https://github.com/ruby/rubygems/pull/4667) by sonalkr132

### Enhancements:

* Add better specification policy error description. Pull request [#4658](https://github.com/ruby/rubygems/pull/4658) by
  ceritium
* Install bundler 2.2.20 as a default gem.

## 3.2.19 / 2021-05-31

### Enhancements:

* Fix `gem help build` output format. Pull request [#4613](https://github.com/ruby/rubygems/pull/4613) by tnir
* Install bundler 2.2.19 as a default gem.

## 3.2.18 / 2021-05-25

### Enhancements:

* Don't leave temporary directory around when building extensions to
  improve build reproducibility. Pull request [#4610](https://github.com/ruby/rubygems/pull/4610) by baloo
* Install bundler 2.2.18 as a default gem.

## 3.2.17 / 2021-05-05

### Enhancements:

* Only print month & year in deprecation messages. Pull request [#3085](https://github.com/ruby/rubygems/pull/3085) by
  Schwad
* Make deprecate method support ruby3's keyword arguments. Pull request
  [#4558](https://github.com/ruby/rubygems/pull/4558) by mame
* Update the default bindir on macOS. Pull request [#4524](https://github.com/ruby/rubygems/pull/4524) by nobu
* Prefer File.open instead of Kernel#open. Pull request [#4529](https://github.com/ruby/rubygems/pull/4529) by mame
* Install bundler 2.2.17 as a default gem.

### Documentation:

* Fix usage messages to reflect the current POSIX-compatible behaviour.
  Pull request [#4551](https://github.com/ruby/rubygems/pull/4551) by graywolf-at-work

## 3.2.16 / 2021-04-08

### Enhancements:

* Install bundler 2.2.16 as a default gem.

### Bug fixes:

* Correctly handle symlinks. Pull request [#2836](https://github.com/ruby/rubygems/pull/2836) by voxik

## 3.2.15 / 2021-03-19

### Enhancements:

* Prevent downgrades to untested rubygems versions. Pull request [#4460](https://github.com/ruby/rubygems/pull/4460) by
  deivid-rodriguez
* Install bundler 2.2.15 as a default gem.

### Bug fixes:

* Fix missing require breaking `gem cert`. Pull request [#4464](https://github.com/ruby/rubygems/pull/4464) by lukehinds

## 3.2.14 / 2021-03-08

### Enhancements:

* Less wrapping of network errors. Pull request [#4064](https://github.com/ruby/rubygems/pull/4064) by deivid-rodriguez
* Install bundler 2.2.14 as a default gem.

### Bug fixes:

* Revert addition of support for `musl` variants to restore graceful
  fallback on Alpine. Pull request [#4434](https://github.com/ruby/rubygems/pull/4434) by deivid-rodriguez

## 3.2.13 / 2021-03-03

### Enhancements:

* Install bundler 2.2.13 as a default gem.

### Bug fixes:

* Support non-gnu libc linux platforms. Pull request [#4082](https://github.com/ruby/rubygems/pull/4082) by lloeki

## 3.2.12 / 2021-03-01

### Enhancements:

* Install bundler 2.2.12 as a default gem.

### Bug fixes:

* Restore the ability to manually install extension gems. Pull request
  [#4384](https://github.com/ruby/rubygems/pull/4384) by cfis

## 3.2.11 / 2021-02-17

### Enhancements:

* Optionally fallback to IPv4 when IPv6 is unreachable. Pull request [#2662](https://github.com/ruby/rubygems/pull/2662)
  by sonalkr132
* Install bundler 2.2.11 as a default gem.

## 3.2.10 / 2021-02-15

### Enhancements:

* Install bundler 2.2.10 as a default gem.

### Documentation:

* Add a `gem push` example to `gem help`. Pull request [#4373](https://github.com/ruby/rubygems/pull/4373) by
  deivid-rodriguez
* Improve documentation for `required_ruby_version`. Pull request [#4343](https://github.com/ruby/rubygems/pull/4343) by
  AlexWayfer

## 3.2.9 / 2021-02-08

### Enhancements:

* Install bundler 2.2.9 as a default gem.

### Bug fixes:

* Fix error message when underscore selection can't find bundler. Pull
  request [#4363](https://github.com/ruby/rubygems/pull/4363) by deivid-rodriguez
* Fix `Gem::Specification.stubs_for` returning wrong named specs. Pull
  request [#4356](https://github.com/ruby/rubygems/pull/4356) by tompng
* Don't error out when activating a binstub unless necessary. Pull request
  [#4351](https://github.com/ruby/rubygems/pull/4351) by deivid-rodriguez
* Fix `gem outdated` incorrectly handling platform specific gems. Pull
  request [#4248](https://github.com/ruby/rubygems/pull/4248) by deivid-rodriguez

## 3.2.8 / 2021-02-02

### Enhancements:

* Install bundler 2.2.8 as a default gem.

### Bug fixes:

* Fix `gem install` crashing on gemspec with nil required_ruby_version.
  Pull request [#4334](https://github.com/ruby/rubygems/pull/4334) by pbernays

## 3.2.7 / 2021-01-26

### Enhancements:

* Install bundler 2.2.7 as a default gem.

### Bug fixes:

* Generate plugin wrappers with relative requires. Pull request [#4317](https://github.com/ruby/rubygems/pull/4317) by
  deivid-rodriguez

## 3.2.6 / 2021-01-18

### Enhancements:

* Fix `Gem::Platform#inspect` showing duplicate information. Pull request
  [#4276](https://github.com/ruby/rubygems/pull/4276) by deivid-rodriguez
* Install bundler 2.2.6 as a default gem.

### Bug fixes:

* Swallow any system call error in `ensure_gem_subdirs` to support jruby
  embedded paths. Pull request [#4291](https://github.com/ruby/rubygems/pull/4291) by kares
* Restore accepting custom make command with extra options as the `make`
  env variable. Pull request [#4271](https://github.com/ruby/rubygems/pull/4271) by terceiro

## 3.2.5 / 2021-01-11

### Enhancements:

* Install bundler 2.2.5 as a default gem.

### Bug fixes:

* Don't load more specs after the whole set of specs has been setup. Pull
  request [#4262](https://github.com/ruby/rubygems/pull/4262) by deivid-rodriguez
* Fix broken `bundler` executable after `gem update --system`. Pull
  request [#4221](https://github.com/ruby/rubygems/pull/4221) by deivid-rodriguez

## 3.2.4 / 2020-12-31

### Enhancements:

* Use a CHANGELOG in markdown for rubygems. Pull request [#4168](https://github.com/ruby/rubygems/pull/4168) by
  deivid-rodriguez
* Never spawn subshells when building extensions. Pull request [#4190](https://github.com/ruby/rubygems/pull/4190) by
  deivid-rodriguez
* Install bundler 2.2.4 as a default gem.

### Bug fixes:

* Fix fallback to the old index and installation from it not working. Pull
  request [#4213](https://github.com/ruby/rubygems/pull/4213) by deivid-rodriguez
* Fix installing from source on truffleruby. Pull request [#4201](https://github.com/ruby/rubygems/pull/4201) by
  deivid-rodriguez

## 3.2.3 / 2020-12-22

### Enhancements:

* Fix misspellings in default API key name. Pull request [#4177](https://github.com/ruby/rubygems/pull/4177) by hsbt
* Install bundler 2.2.3 as a default gem.

### Bug fixes:

* Respect `required_ruby_version` and `required_rubygems_version`
  constraints when looking for `gem install` candidates. Pull request [#4110](https://github.com/ruby/rubygems/pull/4110)
  by deivid-rodriguez

## 3.2.2 / 2020-12-17

### Enhancements:

* Install bundler 2.2.2 as a default gem.

### Bug fixes:

* Fix issue where CLI commands making more than one request to
  rubygems.org needing an OTP code would crash or ask for the code twice.
  Pull request [#4162](https://github.com/ruby/rubygems/pull/4162) by sonalkr132
* Fix building rake extensions that require openssl. Pull request [#4165](https://github.com/ruby/rubygems/pull/4165) by
  deivid-rodriguez
* Fix `gem update --system` displaying too many changelog entries. Pull
  request [#4145](https://github.com/ruby/rubygems/pull/4145) by deivid-rodriguez

## 3.2.1 / 2020-12-14

### Enhancements:

* Added help message for gem i webrick in gem server command. Pull request
  [#4117](https://github.com/ruby/rubygems/pull/4117) by hsbt
* Install bundler 2.2.1 as a default gem.

### Bug fixes:

* Added the missing loading of fileutils same as load_specs. Pull request
  [#4124](https://github.com/ruby/rubygems/pull/4124) by hsbt
* Fix Resolver::APISet to always include prereleases when necessary. Pull
  request [#4113](https://github.com/ruby/rubygems/pull/4113) by deivid-rodriguez

## 3.2.0 / 2020-12-07

### Enhancements:

* Do not override Kernel#warn when there is no need. Pull request [#4075](https://github.com/ruby/rubygems/pull/4075) by
  eregon
* Update endpoint of gem signin command. Pull request [#3840](https://github.com/ruby/rubygems/pull/3840) by sonalkr132
* Omit deprecated commands from command help output. Pull request [#4023](https://github.com/ruby/rubygems/pull/4023) by
  landongrindheim
* Suggest alternatives in `gem query` deprecation. Pull request [#4021](https://github.com/ruby/rubygems/pull/4021) by
  landongrindheim
* Lazily load `time`, `cgi`, and `zlib`. Pull request [#4010](https://github.com/ruby/rubygems/pull/4010) by
  deivid-rodriguez
* Don't hit the network when installing dependencyless local gemspec. Pull
  request [#3968](https://github.com/ruby/rubygems/pull/3968) by deivid-rodriguez
* Add `--force` option to `gem sources` command. Pull request [#3956](https://github.com/ruby/rubygems/pull/3956) by
  andy-smith-msm
* Lazily load `openssl`. Pull request [#3850](https://github.com/ruby/rubygems/pull/3850) by deivid-rodriguez
* Pass more information when comparing platforms. Pull request [#3817](https://github.com/ruby/rubygems/pull/3817) by
  eregon
* Install bundler 2.2.0 as a default gem.

### Bug fixes:

* Use better owner & group for files in rubygems package. Pull request
  [#4065](https://github.com/ruby/rubygems/pull/4065) by deivid-rodriguez
* Improve gem build -C flag. Pull request [#3983](https://github.com/ruby/rubygems/pull/3983) by bronzdoc
* Handle unexpected behavior with URI#merge and subpaths missing trailing
  slashes. Pull request [#3123](https://github.com/ruby/rubygems/pull/3123) by drcapulet
* Add missing `fileutils` require in rubygems installer. Pull request
  [#4036](https://github.com/ruby/rubygems/pull/4036) by deivid-rodriguez
* Fix `--platform` option to `gem specification` being ignored. Pull
  request [#4043](https://github.com/ruby/rubygems/pull/4043) by deivid-rodriguez
* Expose `--no-minimal-deps` flag to install the latest version of
  dependencies. Pull request [#4030](https://github.com/ruby/rubygems/pull/4030) by deivid-rodriguez
* Fix "stack level too deep" error when overriding `Warning.warn`. Pull
  request [#3987](https://github.com/ruby/rubygems/pull/3987) by eregon
* Append '.gemspec' extension only when it is not present. Pull request
  [#3988](https://github.com/ruby/rubygems/pull/3988) by voxik
* Install to correct plugins dir when using `--build-root`. Pull request
  [#3972](https://github.com/ruby/rubygems/pull/3972) by deivid-rodriguez
* Fix `--build-root` flag under Windows. Pull request [#3975](https://github.com/ruby/rubygems/pull/3975) by
  deivid-rodriguez
* Fix `typo_squatting?` false positive for `rubygems.org` itself. Pull
  request [#3951](https://github.com/ruby/rubygems/pull/3951) by andy-smith-msm
* Make `--default` and `--install-dir` options to `gem install` play nice
  together. Pull request [#3906](https://github.com/ruby/rubygems/pull/3906) by deivid-rodriguez

### Deprecations:

* Deprecate server command. Pull request [#3868](https://github.com/ruby/rubygems/pull/3868) by bronzdoc

### Performance:

* Don't change ruby process CWD when building extensions. Pull request
  [#3498](https://github.com/ruby/rubygems/pull/3498) by deivid-rodriguez

## 3.2.0.rc.2 / 2020-10-08

### Enhancements:

* Make --dry-run flag consistent across rubygems commands. Pull request
  [#3867](https://github.com/ruby/rubygems/pull/3867) by bronzdoc
* Disallow downgrades to too old versions. Pull request [#3566](https://github.com/ruby/rubygems/pull/3566) by
  deivid-rodriguez
* Added `--platform` option to `build` command. Pull request [#3079](https://github.com/ruby/rubygems/pull/3079) by nobu
* Have "gem update --system" pass through the `--silent` flag. Pull
  request [#3789](https://github.com/ruby/rubygems/pull/3789) by duckinator
* Add writable check for cache dir. Pull request [#3876](https://github.com/ruby/rubygems/pull/3876) by xndcn
* Warn on duplicate dependency in a specification. Pull request [#3864](https://github.com/ruby/rubygems/pull/3864) by
  bronzdoc
* Fix indentation in `gem env`. Pull request [#3861](https://github.com/ruby/rubygems/pull/3861) by colby-swandale
* Let more exceptions flow. Pull request [#3819](https://github.com/ruby/rubygems/pull/3819) by deivid-rodriguez
* Ignore internal frames in RubyGems' Kernel#warn. Pull request [#3810](https://github.com/ruby/rubygems/pull/3810) by
  eregon

### Bug fixes:

* Add missing fileutils require. Pull request [#3911](https://github.com/ruby/rubygems/pull/3911) by deivid-rodriguez
* Fix false positive warning on Windows when PATH has
  `File::ALT_SEPARATOR`. Pull request [#3829](https://github.com/ruby/rubygems/pull/3829) by deivid-rodriguez
* Fix Kernel#warn override to handle backtrace location with nil path.
  Pull request [#3852](https://github.com/ruby/rubygems/pull/3852) by jeremyevans
* Don't format executables on `gem update --system`. Pull request [#3811](https://github.com/ruby/rubygems/pull/3811) by
  deivid-rodriguez
* `gem install --user` fails with `Gem::FilePermissionError` on the system
  plugins directory. Pull request [#3804](https://github.com/ruby/rubygems/pull/3804) by nobu

### Performance:

* Avoid duplicated generation of APISpecification objects. Pull request
  [#3940](https://github.com/ruby/rubygems/pull/3940) by mame
* Eval defaults with frozen_string_literal: true. Pull request [#3847](https://github.com/ruby/rubygems/pull/3847) by
  casperisfine
* Deduplicate the requirement operators in memory. Pull request [#3846](https://github.com/ruby/rubygems/pull/3846) by
  casperisfine
* Optimize Gem.already_loaded?. Pull request [#3793](https://github.com/ruby/rubygems/pull/3793) by casperisfine

## 3.2.0.rc.1 / 2020-07-04

### Enhancements:

* Test TruffleRuby in CI. Pull request [#2797](https://github.com/ruby/rubygems/pull/2797) by Benoit Daloze.
* Rework plugins system and speed up rubygems. Pull request [#3108](https://github.com/ruby/rubygems/pull/3108) by David
  Rodríguez.
* Specify explicit separator not to be affected by $;. Pull request [#3424](https://github.com/ruby/rubygems/pull/3424)
  by Nobuyoshi Nakada.
* Enable `Layout/ExtraSpacing` cop. Pull request [#3449](https://github.com/ruby/rubygems/pull/3449) by David Rodríguez.
* Rollback gem deprecate. Pull request [#3530](https://github.com/ruby/rubygems/pull/3530) by Luis Sagastume.
* Normalize heredoc delimiters. Pull request [#3533](https://github.com/ruby/rubygems/pull/3533) by David Rodríguez.
* Log messages to stdout in `rake package`. Pull request [#3632](https://github.com/ruby/rubygems/pull/3632) by David
  Rodríguez.
* Remove explicit `psych` activation. Pull request [#3636](https://github.com/ruby/rubygems/pull/3636) by David
  Rodríguez.
* Delay `fileutils` loading to fix some warnings. Pull request [#3637](https://github.com/ruby/rubygems/pull/3637) by
  David Rodríguez.
* Make sure rubygems/package can be directly required reliably. Pull
  request [#3670](https://github.com/ruby/rubygems/pull/3670) by Luis Sagastume.
* Make sure `tmp` folder exists before calling `Dir.tmpdir`. Pull request
  [#3711](https://github.com/ruby/rubygems/pull/3711) by David Rodríguez.
* Add Gem.disable_system_update_message to disable gem update --system if
  needed. Pull request [#3720](https://github.com/ruby/rubygems/pull/3720) by Josef Šimánek.
* Tweaks to play nice with ruby-core setup. Pull request [#3733](https://github.com/ruby/rubygems/pull/3733) by David
  Rodríguez.
* Remove explicit require for auto-loaded constant. Pull request [#3751](https://github.com/ruby/rubygems/pull/3751) by
  Karol Bucek.
* Test files should not be included in spec.files. Pull request [#3758](https://github.com/ruby/rubygems/pull/3758) by
  Marc-André Lafortune.
* Remove TODO comment about warning on setting instead of pushing. Pull
  request [#2823](https://github.com/ruby/rubygems/pull/2823) by Luis Sagastume.
* Add deprecate command method. Pull request [#2935](https://github.com/ruby/rubygems/pull/2935) by Luis Sagastume.
* Simplify deprecate command method. Pull request [#2974](https://github.com/ruby/rubygems/pull/2974) by Luis Sagastume.
* Fix Gem::LOADED_SPECS_MUTEX handling for recursive locking. Pull request
  [#2985](https://github.com/ruby/rubygems/pull/2985) by MSP-Greg.
* Add `funding_uri ` metadata field to gemspec. Pull request [#3060](https://github.com/ruby/rubygems/pull/3060) by
  Colby Swandale.
* Updates to some old gem-signing docs. Pull request [#3063](https://github.com/ruby/rubygems/pull/3063) by Tieg
  Zaharia.
* Update the gem method for Gem::Installer. Pull request [#3137](https://github.com/ruby/rubygems/pull/3137) by Daniel
  Berger.
* Simplify initial gem help output. Pull request [#3148](https://github.com/ruby/rubygems/pull/3148) by Olivier Lacan.
* Resolve latest version via `gem contents`. Pull request [#3149](https://github.com/ruby/rubygems/pull/3149) by Dan
  Rice.
* Install suggestions. Pull request [#3151](https://github.com/ruby/rubygems/pull/3151) by Sophia Castellarin.
* Only rescue the errors we actually want to rescue. Pull request [#3156](https://github.com/ruby/rubygems/pull/3156) by
  David Rodríguez.

### Bug fixes:

* Accept not only /usr/bin/env but also /bin/env in some tests. Pull
  request [#3422](https://github.com/ruby/rubygems/pull/3422) by Yusuke Endoh.
* Skip a test that attempts to remove the current directory on Solaris.
  Pull request [#3423](https://github.com/ruby/rubygems/pull/3423) by Yusuke Endoh.
* Fix race condition on bundler's parallel installer. Pull request [#3440](https://github.com/ruby/rubygems/pull/3440)
  by David Rodríguez.
* Fix platform comparison check in #contains_requirable_file?. Pull
  request [#3495](https://github.com/ruby/rubygems/pull/3495) by Benoit Daloze.
* Improve missing spec error. Pull request [#3559](https://github.com/ruby/rubygems/pull/3559) by Luis Sagastume.
* Fix hidden bundler template installation from rubygems updater. Pull
  request [#3674](https://github.com/ruby/rubygems/pull/3674) by David Rodríguez.
* Fix gem update --user-install. Pull request [#2901](https://github.com/ruby/rubygems/pull/2901) by Luis Sagastume.
* Correct conflict list when uninstallation is prevented. Pull request
  [#2973](https://github.com/ruby/rubygems/pull/2973) by David Rodríguez.
* Fix error when trying to find bundler with a deleted "working directo….
  Pull request [#3090](https://github.com/ruby/rubygems/pull/3090) by Luis Sagastume.
* Fix -I require priority. Pull request [#3124](https://github.com/ruby/rubygems/pull/3124) by David Rodríguez.
* Fix `ruby setup.rb` for new plugins layout. Pull request [#3144](https://github.com/ruby/rubygems/pull/3144) by David
  Rodríguez.

### Deprecations:

* Set deprecation warning on query command. Pull request [#2967](https://github.com/ruby/rubygems/pull/2967) by Luis
  Sagastume.

### Breaking changes:

* Remove ruby 1.8 leftovers. Pull request [#3442](https://github.com/ruby/rubygems/pull/3442) by David Rodríguez.
* Minitest cleanup. Pull request [#3445](https://github.com/ruby/rubygems/pull/3445) by David Rodríguez.
* Remove `builder` gem requirement for `gem regenerate_index`. Pull
  request [#3552](https://github.com/ruby/rubygems/pull/3552) by David Rodríguez.
* Remove modelines for consistency. Pull request [#3714](https://github.com/ruby/rubygems/pull/3714) by David Rodríguez.
* Stop using deprecated OpenSSL::Digest constants. Pull request [#3763](https://github.com/ruby/rubygems/pull/3763) by
  Bart de Water.
* Remove Gem module deprecated methods. Pull request [#3101](https://github.com/ruby/rubygems/pull/3101) by Luis
  Sagastume.
* Remove ubygems.rb. Pull request [#3102](https://github.com/ruby/rubygems/pull/3102) by Luis Sagastume.
* Remove Gem::Commands::QueryCommand. Pull request [#3104](https://github.com/ruby/rubygems/pull/3104) by Luis
  Sagastume.
* Remove dependency installer deprecated methods. Pull request [#3106](https://github.com/ruby/rubygems/pull/3106) by
  Luis Sagastume.
* Remove Gem::UserInteraction#debug method. Pull request [#3107](https://github.com/ruby/rubygems/pull/3107) by Luis
  Sagastume.
* Remove options from Gem::GemRunner.new. Pull request [#3110](https://github.com/ruby/rubygems/pull/3110) by Luis
  Sagastume.
* Remove deprecated Gem::RemoteFetcher#fetch_size. Pull request [#3111](https://github.com/ruby/rubygems/pull/3111) by
  Luis Sagastume.
* Remove source_exception from Gem::Exception. Pull request [#3112](https://github.com/ruby/rubygems/pull/3112) by Luis
  Sagastume.
* Requiring rubygems/source_specific_file is deprecated, remove it. Pull
  request [#3114](https://github.com/ruby/rubygems/pull/3114) by Luis Sagastume.

## 3.1.4 / 2020-06-03

### Enhancements:

* Deprecate rubyforge_project attribute only during build
  time. Pull request [#3609](https://github.com/ruby/rubygems/pull/3609) by Josef Šimánek.
* Update links. Pull request [#3610](https://github.com/ruby/rubygems/pull/3610) by Josef Šimánek.
* Run CI at 3.1 branch head as well. Pull request [#3677](https://github.com/ruby/rubygems/pull/3677) by Josef Šimánek.
* Remove failing ubuntu-rvm CI flow. Pull request [#3611](https://github.com/ruby/rubygems/pull/3611) by
  Josef Šimánek.

## 3.1.3 / 2020-05-05

### Enhancements:

* Resolver: require NameTuple before use. Pull request [#3171](https://github.com/ruby/rubygems/pull/3171) by Olle
  Jonsson.
* Use absolute paths with autoload. Pull request [#3100](https://github.com/ruby/rubygems/pull/3100) by David Rodríguez.
* Avoid changing $SOURCE_DATE_EPOCH. Pull request [#3088](https://github.com/ruby/rubygems/pull/3088) by Ellen Marie
  Dash.
* Use Bundler 2.1.4. Pull request [#3072](https://github.com/ruby/rubygems/pull/3072) by Hiroshi SHIBATA.
* Add tests to check if Gem.ruby_version works with ruby git master.
  Pull request [#3049](https://github.com/ruby/rubygems/pull/3049) by Yusuke Endoh.

### Bug fixes:

* Fix platform comparison check in #contains_requirable_file?. Pull
  request [#3495](https://github.com/ruby/rubygems/pull/3495) by Benoit Daloze.
* Improve gzip errors logging. Pull request [#3485](https://github.com/ruby/rubygems/pull/3485) by David Rodríguez.
* Fix incorrect `gem uninstall --all` message. Pull request [#3483](https://github.com/ruby/rubygems/pull/3483) by David
  Rodríguez.
* Fix incorrect bundler version being required. Pull request [#3458](https://github.com/ruby/rubygems/pull/3458) by
  David Rodríguez.
* Fix gem install from a gemdeps file with complex dependencies.
  Pull request [#3054](https://github.com/ruby/rubygems/pull/3054) by Luis Sagastume.

## 3.1.2 / 2019-12-20

### Enhancements:

* Restore non prompting `gem update --system` behavior. Pull request [#3040](https://github.com/ruby/rubygems/pull/3040)
  by David Rodríguez.
* Show only release notes for new code installed. Pull request [#3041](https://github.com/ruby/rubygems/pull/3041) by
  David Rodríguez.
* Inform about installed `bundle` executable after `gem update --system`.
  Pull request [#3042](https://github.com/ruby/rubygems/pull/3042) by David Rodríguez.
* Use Bundler 2.1.2. Pull request [#3043](https://github.com/ruby/rubygems/pull/3043) by SHIBATA Hiroshi.

### Bug fixes:

* Require `uri` in source.rb. Pull request [#3034](https://github.com/ruby/rubygems/pull/3034) by mihaibuzgau.
* Fix `gem update --system --force`. Pull request [#3035](https://github.com/ruby/rubygems/pull/3035) by David
  Rodríguez.
* Move `require uri` to source_list. Pull request [#3038](https://github.com/ruby/rubygems/pull/3038) by mihaibuzgau.

## 3.1.1 / 2019-12-16

### Bug fixes:

* Vendor Bundler 2.1.0 again. The version of Bundler with
  RubyGems 3.1.0 was Bundler 2.1.0.pre.3. Pull request [#3029](https://github.com/ruby/rubygems/pull/3029) by
  SHIBATA Hiroshi.

## 3.1.0 / 2019-12-16

### Enhancements:

* Vendor bundler 2.1. Pull request [#3028](https://github.com/ruby/rubygems/pull/3028) by David Rodríguez.
* Check for rubygems.org typo squatting sources. Pull request [#2999](https://github.com/ruby/rubygems/pull/2999) by
  Luis Sagastume.
* Refactor remote fetcher. Pull request [#3017](https://github.com/ruby/rubygems/pull/3017) by David Rodríguez.
* Lazily load `open3`. Pull request [#3001](https://github.com/ruby/rubygems/pull/3001) by David Rodríguez.
* Remove `delegate` dependency. Pull request [#3002](https://github.com/ruby/rubygems/pull/3002) by David Rodríguez.
* Lazily load `uri`. Pull request [#3005](https://github.com/ruby/rubygems/pull/3005) by David Rodríguez.
* Lazily load `rubygems/gem_runner` during tests. Pull request [#3009](https://github.com/ruby/rubygems/pull/3009) by
  David Rodríguez.
* Use bundler to manage development dependencies. Pull request [#3012](https://github.com/ruby/rubygems/pull/3012) by
  David Rodríguez.

### Bug fixes:

* Remove unnecessary executable flags. Pull request [#2982](https://github.com/ruby/rubygems/pull/2982) by David
  Rodríguez.
* Remove configuration that contained a typo. Pull request [#2989](https://github.com/ruby/rubygems/pull/2989) by David
  Rodríguez.

### Deprecations:

* Deprecate `gem generate_index --modern` and `gem generate_index
  --no-modern`. Pull request [#2992](https://github.com/ruby/rubygems/pull/2992) by David Rodríguez.

### Breaking changes:

* Remove 1.8.7 leftovers. Pull request [#2972](https://github.com/ruby/rubygems/pull/2972) by David Rodríguez.

## 3.1.0.pre3 / 2019-11-11

### Enhancements:

* Fix gem pristine not accounting for user installed gems. Pull request
  [#2914](https://github.com/ruby/rubygems/pull/2914) by Luis Sagastume.
* Refactor keyword argument test for Ruby 2.7. Pull request [#2947](https://github.com/ruby/rubygems/pull/2947) by
  SHIBATA Hiroshi.
* Fix errors at frozen Gem::Version. Pull request [#2949](https://github.com/ruby/rubygems/pull/2949) by Nobuyoshi
  Nakada.
* Remove taint usage on Ruby 2.7+. Pull request [#2951](https://github.com/ruby/rubygems/pull/2951) by Jeremy Evans.
* Check Manifest.txt is up to date. Pull request [#2953](https://github.com/ruby/rubygems/pull/2953) by David Rodríguez.
* Clarify symlink conditionals in tests. Pull request [#2962](https://github.com/ruby/rubygems/pull/2962) by David
  Rodríguez.
* Update command line parsing to work under ps. Pull request [#2966](https://github.com/ruby/rubygems/pull/2966) by
  David Rodríguez.
* Properly test `Gem::Specifications.stub_for`. Pull request [#2970](https://github.com/ruby/rubygems/pull/2970) by
  David Rodríguez.
* Fix Gem::LOADED_SPECS_MUTEX handling for recursive locking. Pull request
  [#2985](https://github.com/ruby/rubygems/pull/2985) by MSP-Greg.

## 3.1.0.pre2 / 2019-10-15

### Enhancements:

* Optimize Gem::Package::TarReader#each. Pull request [#2941](https://github.com/ruby/rubygems/pull/2941) by Jean byroot
  Boussier.
* Time comparison around date boundary. Pull request [#2944](https://github.com/ruby/rubygems/pull/2944) by Nobuyoshi
  Nakada.

## 3.1.0.pre1 / 2019-10-08

### Enhancements:

* Try to use bundler-2.1.0.pre.2. Pull request [#2923](https://github.com/ruby/rubygems/pull/2923) by SHIBATA Hiroshi.
* [Require] Ensure -I beats a default gem. Pull request [#1868](https://github.com/ruby/rubygems/pull/1868) by Samuel
  Giddins.
* [Specification] Prefer user-installed gems to default gems. Pull request
  [#2112](https://github.com/ruby/rubygems/pull/2112) by Samuel Giddins.
* Multifactor authentication for yank command. Pull request [#2514](https://github.com/ruby/rubygems/pull/2514) by Qiu
  Chaofan.
* Autoswitch to exact bundler version if present. Pull request [#2583](https://github.com/ruby/rubygems/pull/2583) by
  David Rodríguez.
* Fix Gem::Requirement equality comparison when ~> operator is used. Pull
  request [#2554](https://github.com/ruby/rubygems/pull/2554) by Grey Baker.
* Don't use a proxy if https_proxy env var is empty. Pull request [#2567](https://github.com/ruby/rubygems/pull/2567) by
  Luis Sagastume.
* Fix typo in specs warning. Pull request [#2585](https://github.com/ruby/rubygems/pull/2585) by Rui.
* Bin/gem: remove initial empty line. Pull request [#2602](https://github.com/ruby/rubygems/pull/2602) by Kenyon Ralph.
* Avoid rdoc hook when it's failed to load rdoc library. Pull request
  [#2604](https://github.com/ruby/rubygems/pull/2604) by SHIBATA Hiroshi.
* Refactor get_proxy_from_env logic. Pull request [#2611](https://github.com/ruby/rubygems/pull/2611) by Luis Sagastume.
* Allow to easily bisect flaky failures. Pull request [#2626](https://github.com/ruby/rubygems/pull/2626) by David
  Rodríguez.
* Fix `--ignore-dependencies` flag not installing platform specific gems.
  Pull request [#2631](https://github.com/ruby/rubygems/pull/2631) by David Rodríguez.
* Make `gem install --explain` list platforms. Pull request [#2634](https://github.com/ruby/rubygems/pull/2634) by David
  Rodríguez.
* Make `gem update --explain` list platforms. Pull request [#2635](https://github.com/ruby/rubygems/pull/2635) by David
  Rodríguez.
* Refactoring install and update explanations. Pull request [#2643](https://github.com/ruby/rubygems/pull/2643) by David
  Rodríguez.
* Restore transitiveness of version comparison. Pull request [#2651](https://github.com/ruby/rubygems/pull/2651) by
  David Rodríguez.
* Undo requirement sorting. Pull request [#2652](https://github.com/ruby/rubygems/pull/2652) by David Rodríguez.
* Update dummy version of Bundler for #2581. Pull request [#2584](https://github.com/ruby/rubygems/pull/2584) by SHIBATA
  Hiroshi.
* Ignore to handle the different platform. Pull request [#2672](https://github.com/ruby/rubygems/pull/2672) by SHIBATA
  Hiroshi.
* Make Gem::Specification.default_stubs to public methods. Pull request
  [#2675](https://github.com/ruby/rubygems/pull/2675) by SHIBATA Hiroshi.
* Sort files and test_files in specifications. Pull request [#2524](https://github.com/ruby/rubygems/pull/2524) by
  Christopher Baines.
* Fix comment of Gem::Specification#required_ruby_version=. Pull request
  [#2732](https://github.com/ruby/rubygems/pull/2732) by Alex Junger.
* Config_file.rb - update path separator in ENV['GEMRC'] logic. Pull
  request [#2735](https://github.com/ruby/rubygems/pull/2735) by MSP-Greg.
* Fix `ruby setup.rb` warnings. Pull request [#2737](https://github.com/ruby/rubygems/pull/2737) by David Rodríguez.
* Don't use regex delimiters when searching for a dependency. Pull request
  [#2738](https://github.com/ruby/rubygems/pull/2738) by Luis Sagastume.
* Refactor query command. Pull request [#2739](https://github.com/ruby/rubygems/pull/2739) by Luis Sagastume.
* Don't remove default spec files from mapping after require. Pull request
  [#2741](https://github.com/ruby/rubygems/pull/2741) by David Rodríguez.
* Cleanup base test case. Pull request [#2742](https://github.com/ruby/rubygems/pull/2742) by David Rodríguez.
* Simplify Specification#gems_dir. Pull request [#2745](https://github.com/ruby/rubygems/pull/2745) by David Rodríguez.
* Fix test warning. Pull request [#2746](https://github.com/ruby/rubygems/pull/2746) by David Rodríguez.
* Extract an `add_to_load_path` method. Pull request [#2749](https://github.com/ruby/rubygems/pull/2749) by David
  Rodríguez.
* Fix setup command if format_executable is true by default. Pull request
  [#2766](https://github.com/ruby/rubygems/pull/2766) by Jeremy Evans.
* Update the certificate files to make the test pass on Debian 10. Pull
  request [#2777](https://github.com/ruby/rubygems/pull/2777) by Yusuke Endoh.
* Write to the correct config file(.gemrc). Pull request [#2779](https://github.com/ruby/rubygems/pull/2779) by Luis
  Sagastume.
* Fix for large values in UID/GID fields in tar archives. Pull request
  [#2780](https://github.com/ruby/rubygems/pull/2780) by Alexey Shein.
* Lazy require stringio. Pull request [#2781](https://github.com/ruby/rubygems/pull/2781) by Luis Sagastume.
* Make Gem::Specification#ruby_code handle OpenSSL::PKey::RSA objects.
  Pull request [#2782](https://github.com/ruby/rubygems/pull/2782) by Luis Sagastume.
* Fix setup command test for bundler with program_suffix. Pull request
  [#2783](https://github.com/ruby/rubygems/pull/2783) by Sorah Fukumori.
* Make sure `rake package` works. Pull request [#2787](https://github.com/ruby/rubygems/pull/2787) by David Rodríguez.
* Synchronize access to the Gem::Specification::LOAD_CACHE Hash. Pull
  request [#2789](https://github.com/ruby/rubygems/pull/2789) by Benoit Daloze.
* Task to install rubygems to local system. Pull request [#2795](https://github.com/ruby/rubygems/pull/2795) by David
  Rodríguez.
* Add an attr_reader to Gem::Installer for the package instance variable.
  Pull request [#2796](https://github.com/ruby/rubygems/pull/2796) by Daniel Berger.
* Switch CI script to bash. Pull request [#2799](https://github.com/ruby/rubygems/pull/2799) by David Rodríguez.
* Move gemcutter utilities code to Gem::Command. Pull request [#2803](https://github.com/ruby/rubygems/pull/2803) by
  Luis Sagastume.
* Add raw spec method to gem package. Pull request [#2806](https://github.com/ruby/rubygems/pull/2806) by Luis
  Sagastume.
* Improve `rake package` test error message. Pull request [#2815](https://github.com/ruby/rubygems/pull/2815) by David
  Rodríguez.
* Resolve `@@project_dir` from test file paths. Pull request [#2843](https://github.com/ruby/rubygems/pull/2843) by
  Nobuyoshi Nakada.
* Remove dead code in Gem::Validator. Pull request [#2537](https://github.com/ruby/rubygems/pull/2537) by Ellen Marie
  Dash.
* The date might have advanced since TODAY has been set. Pull request
  [#2938](https://github.com/ruby/rubygems/pull/2938) by Nobuyoshi Nakada.
* Remove old ci configurations. Pull request [#2917](https://github.com/ruby/rubygems/pull/2917) by SHIBATA Hiroshi.
* Add Gem::Dependency identity. Pull request [#2936](https://github.com/ruby/rubygems/pull/2936) by Luis Sagastume.
* Filter dependency type and name strictly. Pull request [#2930](https://github.com/ruby/rubygems/pull/2930) by SHIBATA
  Hiroshi.
* Always pass an encoding option to Zlib::GzipReader.wrap. Pull request
  [#2933](https://github.com/ruby/rubygems/pull/2933) by Nobuyoshi Nakada.
* Introduce default prerelease requirement. Pull request [#2925](https://github.com/ruby/rubygems/pull/2925) by David
  Rodríguez.
* Detect libc version, closes #2918. Pull request [#2922](https://github.com/ruby/rubygems/pull/2922) by fauno.
* Use IAM role to extract security-credentials for EC2 instance. Pull
  request [#2894](https://github.com/ruby/rubygems/pull/2894) by Alexander Pakulov.
* Improve `gem uninstall --all`. Pull request [#2893](https://github.com/ruby/rubygems/pull/2893) by David Rodríguez.
* Use `RbConfig::CONFIG['rubylibprefix']`. Pull request [#2889](https://github.com/ruby/rubygems/pull/2889) by Nobuyoshi
  Nakada.
* Build the first gemspec we found if no arguments are passed to gem
  build. Pull request [#2887](https://github.com/ruby/rubygems/pull/2887) by Luis Sagastume.
* $LOAD_PATH elements should be real paths. Pull request [#2885](https://github.com/ruby/rubygems/pull/2885) by
  Nobuyoshi Nakada.
* Use the standard RUBY_ENGINE_VERSION instead of JRUBY_VERSION. Pull
  request [#2864](https://github.com/ruby/rubygems/pull/2864) by Benoit Daloze.
* Cleanup after testing `rake package`. Pull request [#2862](https://github.com/ruby/rubygems/pull/2862) by David
  Rodríguez.
* Cherry-pick shushing deprecation warnings from ruby-core. Pull request
  [#2861](https://github.com/ruby/rubygems/pull/2861) by David Rodríguez.
* Ext/builder.rb cleanup. Pull request [#2849](https://github.com/ruby/rubygems/pull/2849) by Luis Sagastume.
* Fix @ran_rake assignment in builder.rb. Pull request [#2850](https://github.com/ruby/rubygems/pull/2850) by Luis
  Sagastume.
* Remove test suite warnings. Pull request [#2845](https://github.com/ruby/rubygems/pull/2845) by Luis Sagastume.
* Replace domain parameter with a parameter to suppress suggestions. Pull
  request [#2846](https://github.com/ruby/rubygems/pull/2846) by Luis Sagastume.
* Move default specifications dir definition out of BasicSpecification.
  Pull request [#2841](https://github.com/ruby/rubygems/pull/2841) by Vít Ondruch.
* There is no usage of @orig_env_* variables in test suite. Pull request
  [#2838](https://github.com/ruby/rubygems/pull/2838) by SHIBATA Hiroshi.
* Use File#open instead of Kernel#open in stub_specification.rb. Pull
  request [#2834](https://github.com/ruby/rubygems/pull/2834) by Luis Sagastume.
* Simplify #to_ruby code. Pull request [#2825](https://github.com/ruby/rubygems/pull/2825) by Nobuyoshi Nakada.
* Add a gem attr to the Gem::Package class. Pull request [#2828](https://github.com/ruby/rubygems/pull/2828) by Daniel
  Berger.
* Remove useless TODO comment. Pull request [#2818](https://github.com/ruby/rubygems/pull/2818) by Luis Sagastume.

### Bug fixes:

* Fix typos in History.txt. Pull request [#2565](https://github.com/ruby/rubygems/pull/2565) by Igor Zubkov.
* Remove unused empty sources array. Pull request [#2598](https://github.com/ruby/rubygems/pull/2598) by Aaron
  Patterson.
* Fix windows specific executables generated by `gem install`. Pull
  request [#2628](https://github.com/ruby/rubygems/pull/2628) by David Rodríguez.
* Gem::Specification#to_ruby needs OpenSSL. Pull request [#2937](https://github.com/ruby/rubygems/pull/2937) by
  Nobuyoshi Nakada.
* Set SOURCE_DATE_EPOCH env var if not provided. Pull request [#2882](https://github.com/ruby/rubygems/pull/2882) by
  Ellen Marie Dash.
* Installer.rb - fix #windows_stub_script. Pull request [#2876](https://github.com/ruby/rubygems/pull/2876) by MSP-Greg.
* Fixed deprecation message. Pull request [#2867](https://github.com/ruby/rubygems/pull/2867) by Nobuyoshi Nakada.
* Fix requiring default gems to consider prereleases. Pull request [#2728](https://github.com/ruby/rubygems/pull/2728)
  by David Rodríguez.
* Forbid `find_spec_for_exe` without an `exec_name`. Pull request [#2706](https://github.com/ruby/rubygems/pull/2706) by
  David Rodríguez.
* Do not prompt for passphrase when key can be loaded without it. Pull
  request [#2710](https://github.com/ruby/rubygems/pull/2710) by Luis Sagastume.
* Add missing wrapper. Pull request [#2690](https://github.com/ruby/rubygems/pull/2690) by David Rodríguez.
* Remove long ago deprecated methods. Pull request [#2704](https://github.com/ruby/rubygems/pull/2704) by David
  Rodríguez.
* Renamed duplicate test. Pull request [#2678](https://github.com/ruby/rubygems/pull/2678) by Nobuyoshi Nakada.
* File.exists? is deprecated. Pull request [#2855](https://github.com/ruby/rubygems/pull/2855) by SHIBATA Hiroshi.
* Fixed to warn with shadowing outer local variable. Pull request [#2856](https://github.com/ruby/rubygems/pull/2856) by
  SHIBATA Hiroshi.
* Fix explain with ignore-dependencies. Pull request [#2647](https://github.com/ruby/rubygems/pull/2647) by David
  Rodríguez.
* Fix default gem executable installation when folder is not `bin/`. Pull
  request [#2649](https://github.com/ruby/rubygems/pull/2649) by David Rodríguez.
* Fix cryptic error on local and ignore-dependencies combination. Pull
  request [#2650](https://github.com/ruby/rubygems/pull/2650) by David Rodríguez.

### Deprecations:

* Make deprecate Gem::RubyGemsVersion and Gem::ConfigMap. Pull request
  [#2857](https://github.com/ruby/rubygems/pull/2857) by SHIBATA Hiroshi.
* Deprecate Gem::RemoteFetcher#fetch_size. Pull request [#2833](https://github.com/ruby/rubygems/pull/2833) by Luis
  Sagastume.
* Explicitly deprecate `rubyforge_project`. Pull request [#2798](https://github.com/ruby/rubygems/pull/2798) by David
  Rodríguez.
* Deprecate unused Gem::Installer#unpack method. Pull request [#2715](https://github.com/ruby/rubygems/pull/2715) by Vít
  Ondruch.
* Deprecate a few unused methods. Pull request [#2674](https://github.com/ruby/rubygems/pull/2674) by David Rodríguez.
* Add deprecation warnings for cli options. Pull request [#2607](https://github.com/ruby/rubygems/pull/2607) by Luis
  Sagastume.

### Breaking changes:

* Suppress keywords warning. Pull request [#2934](https://github.com/ruby/rubygems/pull/2934) by Nobuyoshi Nakada.
* Suppress Ruby 2.7's real kwargs warning. Pull request [#2912](https://github.com/ruby/rubygems/pull/2912) by Koichi
  ITO.
* Fix Kernel#warn override. Pull request [#2911](https://github.com/ruby/rubygems/pull/2911) by Jeremy Evans.
* Remove conflict.rb code that was supposed to be removed in Rubygems 3.
  Pull request [#2802](https://github.com/ruby/rubygems/pull/2802) by Luis Sagastume.
* Compatibility cleanups. Pull request [#2754](https://github.com/ruby/rubygems/pull/2754) by David Rodríguez.
* Remove `others_possible` activation request param. Pull request [#2747](https://github.com/ruby/rubygems/pull/2747) by
  David Rodríguez.
* Remove dependency installer deprecated code. Pull request [#2740](https://github.com/ruby/rubygems/pull/2740) by Luis
  Sagastume.
* Removed guard condition with USE_BUNDLER_FOR_GEMDEPS. Pull request [#2716](https://github.com/ruby/rubygems/pull/2716)
  by SHIBATA Hiroshi.
* Skip deprecation warning during specs. Pull request [#2718](https://github.com/ruby/rubygems/pull/2718) by David
  Rodríguez.
* Remove QuickLoader reference. Pull request [#2719](https://github.com/ruby/rubygems/pull/2719) by David Rodríguez.
* Removed circular require. Pull request [#2679](https://github.com/ruby/rubygems/pull/2679) by Nobuyoshi Nakada.
* Removed needless environmental variable for Travis CI. Pull request
  [#2685](https://github.com/ruby/rubygems/pull/2685) by SHIBATA Hiroshi.
* Removing yaml require. Pull request [#2538](https://github.com/ruby/rubygems/pull/2538) by Luciano Sousa.

## 3.0.8 / 2020-02-19

### Bug fixes:

* Gem::Specification#to_ruby needs OpenSSL. Pull request [#2937](https://github.com/ruby/rubygems/pull/2937) by
  Nobuyoshi Nakada.

## 3.0.7 / 2020-02-18

### Bug fixes:

* Fix underscore version selection for bundler #2908 by David Rodríguez.
* Add missing wrapper. Pull request [#2690](https://github.com/ruby/rubygems/pull/2690) by David Rodríguez.
* Make Gem::Specification#ruby_code handle OpenSSL::PKey::RSA objects.
  Pull request [#2782](https://github.com/ruby/rubygems/pull/2782) by Luis Sagastume.
* Installer.rb - fix #windows_stub_script. Pull request [#2876](https://github.com/ruby/rubygems/pull/2876) by MSP-Greg.
* Use IAM role to extract security-credentials for EC2 instance. Pull
  request [#2894](https://github.com/ruby/rubygems/pull/2894) by Alexander Pakulov.

## 3.0.6 / 2019-08-17

### Bug fixes:

* Revert #2813. It broke the compatibility with 3.0.x versions.

## 3.0.5 / 2019-08-16

### Enhancements:

* Use env var to configure api key on push. Pull request [#2559](https://github.com/ruby/rubygems/pull/2559) by Luis
  Sagastume.
* Unswallow uninstall error. Pull request [#2707](https://github.com/ruby/rubygems/pull/2707) by David Rodríguez.
* Expose windows path normalization utility. Pull request [#2767](https://github.com/ruby/rubygems/pull/2767) by David
  Rodríguez.
* Clean which command. Pull request [#2801](https://github.com/ruby/rubygems/pull/2801) by Luis Sagastume.
* Upgrading S3 source signature to AWS SigV4. Pull request [#2807](https://github.com/ruby/rubygems/pull/2807) by
  Alexander Pakulov.
* Remove misleading comment, no reason to move Gem.host to Gem::Util.
  Pull request [#2811](https://github.com/ruby/rubygems/pull/2811) by Luis Sagastume.
* Drop support for 'gem env packageversion'. Pull request [#2813](https://github.com/ruby/rubygems/pull/2813) by Luis
  Sagastume.
* Take into account just git tracked files in update_manifest rake task.
  Pull request [#2816](https://github.com/ruby/rubygems/pull/2816) by Luis Sagastume.
* Remove TODO comment, there's no Gem::Dirs constant. Pull request [#2819](https://github.com/ruby/rubygems/pull/2819)
  by Luis Sagastume.
* Remove unused 'raise' from test_case. Pull request [#2820](https://github.com/ruby/rubygems/pull/2820) by Luis
  Sagastume.
* Move TODO comment to an information comment. Pull request [#2821](https://github.com/ruby/rubygems/pull/2821) by Luis
  Sagastume.
* Use File#open instead of Kernel#open in stub_specification.rb. Pull
  request [#2834](https://github.com/ruby/rubygems/pull/2834) by Luis Sagastume.
* Make error code a gemcutter_utilities a constant. Pull request [#2844](https://github.com/ruby/rubygems/pull/2844) by
  Luis Sagastume.
* Remove FIXME comment related to PathSupport. Pull request [#2854](https://github.com/ruby/rubygems/pull/2854) by Luis
  Sagastume.
* Use gsub with Hash. Pull request [#2860](https://github.com/ruby/rubygems/pull/2860) by Kazuhiro NISHIYAMA.
* Use the standard RUBY_ENGINE_VERSION instead of JRUBY_VERSION. Pull
  request [#2864](https://github.com/ruby/rubygems/pull/2864) by Benoit Daloze.
* Do not mutate uri.query during s3 signature creation. Pull request [#2874](https://github.com/ruby/rubygems/pull/2874)
  by Alexander Pakulov.
* Fixup #2844. Pull request [#2878](https://github.com/ruby/rubygems/pull/2878) by SHIBATA Hiroshi.

### Bug fixes:

* Fix intermittent test error on Appveyor & Travis. Pull request [#2568](https://github.com/ruby/rubygems/pull/2568) by
  MSP-Greg.
* Extend timeout on assert_self_install_permissions. Pull request [#2605](https://github.com/ruby/rubygems/pull/2605) by
  SHIBATA Hiroshi.
* Better folder assertions. Pull request [#2644](https://github.com/ruby/rubygems/pull/2644) by David Rodríguez.
* Fix default gem executable installation when folder is not `bin/`. Pull
  request [#2649](https://github.com/ruby/rubygems/pull/2649) by David Rodríguez.
* Fix gem uninstall behavior. Pull request [#2663](https://github.com/ruby/rubygems/pull/2663) by Luis Sagastume.
* Fix for large values in UID/GID fields in tar archives. Pull request
  [#2780](https://github.com/ruby/rubygems/pull/2780) by Alexey Shein.
* Fixed task order for release. Pull request [#2792](https://github.com/ruby/rubygems/pull/2792) by SHIBATA Hiroshi.
* Ignore GEMRC variable for test suite. Pull request [#2837](https://github.com/ruby/rubygems/pull/2837) by SHIBATA
  Hiroshi.

## 3.0.4 / 2019-06-14

### Enhancements:

* Add support for TruffleRuby #2612 by Benoit Daloze
* Serve a more descriptive error when --no-ri or --no-rdoc are used #2572
  by Grey Baker
* Improve test compatibility with CMake 2.8. Pull request [#2590](https://github.com/ruby/rubygems/pull/2590) by Vít
  Ondruch.
* Restore gem build behavior and introduce the "-C" flag to gem build.
  Pull request [#2596](https://github.com/ruby/rubygems/pull/2596) by Luis Sagastume.
* Enabled block call with util_set_arch. Pull request [#2603](https://github.com/ruby/rubygems/pull/2603) by SHIBATA
  Hiroshi.
* Avoid rdoc hook when it's failed to load rdoc library. Pull request
  [#2604](https://github.com/ruby/rubygems/pull/2604) by SHIBATA Hiroshi.
* Drop tests for legacy RDoc. Pull request [#2608](https://github.com/ruby/rubygems/pull/2608) by Nobuyoshi Nakada.
* Update TODO comment. Pull request [#2658](https://github.com/ruby/rubygems/pull/2658) by Luis Sagastume.
* Skip malicious extension test with mswin platform. Pull request [#2670](https://github.com/ruby/rubygems/pull/2670) by
  SHIBATA Hiroshi.
* Check deprecated methods on release. Pull request [#2673](https://github.com/ruby/rubygems/pull/2673) by David
  Rodríguez.
* Add steps to run bundler tests. Pull request [#2680](https://github.com/ruby/rubygems/pull/2680) by Aditya Prakash.
* Skip temporary "No such host is known" error. Pull request [#2684](https://github.com/ruby/rubygems/pull/2684) by
  Takashi Kokubun.
* Replaced aws-sdk-s3 instead of s3cmd. Pull request [#2688](https://github.com/ruby/rubygems/pull/2688) by SHIBATA
  Hiroshi.
* Allow uninstall from symlinked GEM_HOME. Pull request [#2720](https://github.com/ruby/rubygems/pull/2720) by David
  Rodríguez.
* Use current checkout in CI to uninstall RVM related gems. Pull request
  [#2729](https://github.com/ruby/rubygems/pull/2729) by David Rodríguez.
* Update Contributor Covenant v1.4.1. Pull request [#2751](https://github.com/ruby/rubygems/pull/2751) by SHIBATA
  Hiroshi.
* Added supported versions of Ruby. Pull request [#2756](https://github.com/ruby/rubygems/pull/2756) by SHIBATA Hiroshi.
* Fix shadowing outer local variable warning. Pull request [#2763](https://github.com/ruby/rubygems/pull/2763) by Luis
  Sagastume.
* Update the certificate files to make the test pass on Debian 10. Pull
  request [#2777](https://github.com/ruby/rubygems/pull/2777) by Yusuke Endoh.
* Backport ruby core changes. Pull request [#2778](https://github.com/ruby/rubygems/pull/2778) by SHIBATA Hiroshi.

### Bug fixes:

* Test_gem.rb - intermittent failure fix. Pull request [#2613](https://github.com/ruby/rubygems/pull/2613) by MSP-Greg.
* Fix sporadic CI failures. Pull request [#2617](https://github.com/ruby/rubygems/pull/2617) by David Rodríguez.
* Fix flaky bundler version finder tests. Pull request [#2624](https://github.com/ruby/rubygems/pull/2624) by David
  Rodríguez.
* Fix gem indexer tests leaking utility gems. Pull request [#2625](https://github.com/ruby/rubygems/pull/2625) by David
  Rodríguez.
* Clean up default spec dir too. Pull request [#2639](https://github.com/ruby/rubygems/pull/2639) by David Rodríguez.
* Fix 2.6.1 build against vendored bundler. Pull request [#2645](https://github.com/ruby/rubygems/pull/2645) by David
  Rodríguez.
* Fix comment typo. Pull request [#2664](https://github.com/ruby/rubygems/pull/2664) by Luis Sagastume.
* Fix comment of Gem::Specification#required_ruby_version=. Pull request
  [#2732](https://github.com/ruby/rubygems/pull/2732) by Alex Junger.
* Fix TODOs. Pull request [#2748](https://github.com/ruby/rubygems/pull/2748) by David Rodríguez.

## 3.0.3 / 2019-03-05

Security fixes:

  * CVE-2019-8320: Delete directory using symlink when decompressing tar
  * CVE-2019-8321: Escape sequence injection vulnerability in `verbose`
  * CVE-2019-8322: Escape sequence injection vulnerability in `gem owner`
  * CVE-2019-8323: Escape sequence injection vulnerability in API response handling
  * CVE-2019-8324: Installing a malicious gem may lead to arbitrary code execution
  * CVE-2019-8325: Escape sequence injection vulnerability in errors

## 3.0.2 / 2019-01-01

### Enhancements:

* Use Bundler-1.17.3. Pull request [#2556](https://github.com/ruby/rubygems/pull/2556) by SHIBATA Hiroshi.
* Fix document flag description. Pull request [#2555](https://github.com/ruby/rubygems/pull/2555) by Luis Sagastume.

### Bug fixes:

* Fix tests when ruby --program-suffix is used without rubygems
  --format-executable. Pull request [#2549](https://github.com/ruby/rubygems/pull/2549) by Jeremy Evans.
* Fix Gem::Requirement equality comparison when ~> operator is used. Pull
  request [#2554](https://github.com/ruby/rubygems/pull/2554) by Grey Baker.
* Unset SOURCE_DATE_EPOCH in the test cases. Pull request [#2558](https://github.com/ruby/rubygems/pull/2558) by Sorah
  Fukumori.
* Restore SOURCE_DATE_EPOCH. Pull request [#2560](https://github.com/ruby/rubygems/pull/2560) by SHIBATA Hiroshi.

## 3.0.1 / 2018-12-23

### Bug fixes:

* Ensure globbed files paths are expanded. Pull request [#2536](https://github.com/ruby/rubygems/pull/2536) by Tony Ta.
* Dup the Dir.home string before passing it on. Pull request [#2545](https://github.com/ruby/rubygems/pull/2545) by
  Charles Oliver Nutter.
* Added permissions to installed files for non-owners. Pull request [#2546](https://github.com/ruby/rubygems/pull/2546)
  by SHIBATA Hiroshi.
* Restore release task without hoe. Pull request [#2547](https://github.com/ruby/rubygems/pull/2547) by SHIBATA Hiroshi.

## 3.0.0 / 2018-12-19

### Enhancements:

* S3 source. Pull request [#1690](https://github.com/ruby/rubygems/pull/1690) by Aditya Prakash.
* Download gems with threads. Pull request [#1898](https://github.com/ruby/rubygems/pull/1898) by André Arko.
* Update to SPDX license list 3.0. Pull request [#2152](https://github.com/ruby/rubygems/pull/2152) by Mike Linksvayer.
* [GSoC] Multi-factor feature for RubyGems. Pull request [#2369](https://github.com/ruby/rubygems/pull/2369) by Qiu
  Chaofan.
* Use bundler 1.17.2. Pull request [#2521](https://github.com/ruby/rubygems/pull/2521) by SHIBATA Hiroshi.
* Don't treat inaccessible working directories as build failures. Pull
  request [#1135](https://github.com/ruby/rubygems/pull/1135) by Pete.
* Remove useless directory parameter from builders .build methods.
  [rebased]. Pull request [#1433](https://github.com/ruby/rubygems/pull/1433) by Kurtis Rainbolt-Greene.
* Skipping more than one gem in pristine. Pull request [#1592](https://github.com/ruby/rubygems/pull/1592) by Henne
  Vogelsang.
* Add info command to print information about an installed gem. Pull
  request [#2023](https://github.com/ruby/rubygems/pull/2023) by Colby Swandale.
* Add --[no-]check-development option to cleanup command. Pull request
  [#2061](https://github.com/ruby/rubygems/pull/2061) by Lin Jen-Shin (godfat).
* Show which gem referenced a missing gem. Pull request [#2067](https://github.com/ruby/rubygems/pull/2067) by Artem
  Khramov.
* Prevent to delete to "bundler-" prefix gem like bundler-audit. Pull
  request [#2086](https://github.com/ruby/rubygems/pull/2086) by SHIBATA Hiroshi.
* Fix rake install_test_deps once the rake clean_env does not exist. Pull
  request [#2090](https://github.com/ruby/rubygems/pull/2090) by Lucas Arantes.
* Workaround common options mutation in Gem::Command test. Pull request
  [#2098](https://github.com/ruby/rubygems/pull/2098) by Thibault Jouan.
* Extract a SpecificationPolicy validation class. Pull request [#2101](https://github.com/ruby/rubygems/pull/2101) by
  Olle Jonsson.
* Handle environment that does not have `flock` system call. Pull request
  [#2107](https://github.com/ruby/rubygems/pull/2107) by SHIBATA Hiroshi.
* Handle the explain option in gem update. Pull request [#2110](https://github.com/ruby/rubygems/pull/2110) by Colby
  Swandale.
* Add Gem.operating_system_defaults to allow packagers to override
  defaults. Pull request [#2116](https://github.com/ruby/rubygems/pull/2116) by Vít Ondruch.
* Update for compatibility with new minitest. Pull request [#2118](https://github.com/ruby/rubygems/pull/2118) by
  MSP-Greg.
* Make Windows bin stubs portable. Pull request [#2119](https://github.com/ruby/rubygems/pull/2119) by MSP-Greg.
* Avoid to warnings about gemspec loadings in rubygems tests. Pull request
  [#2125](https://github.com/ruby/rubygems/pull/2125) by SHIBATA Hiroshi.
* Set whether bundler is used for gemdeps with an environmental variable.
  Pull request [#2126](https://github.com/ruby/rubygems/pull/2126) by SHIBATA Hiroshi.
* Titleize "GETTING HELP" in readme. Pull request [#2136](https://github.com/ruby/rubygems/pull/2136) by Colby Swandale.
* Improve the error message given when using --version with multiple gems
  in the install command. Pull request [#2137](https://github.com/ruby/rubygems/pull/2137) by Colby Swandale.
* Use `File.open` instead of `open`. Pull request [#2142](https://github.com/ruby/rubygems/pull/2142) by SHIBATA
  Hiroshi.
* Gem::Util.traverse_parents should not crash on permissions error. Pull
  request [#2147](https://github.com/ruby/rubygems/pull/2147) by Robert Ulejczyk.
* [Installer] Avoid a #mkdir race condition. Pull request [#2148](https://github.com/ruby/rubygems/pull/2148) by Samuel
  Giddins.
* Allow writing gemspecs from gem unpack to location specified by target
  option. Pull request [#2150](https://github.com/ruby/rubygems/pull/2150) by Colby Swandale.
* Raise errors in `gem uninstall` when a file in a gem could not be
  removed . Pull request [#2154](https://github.com/ruby/rubygems/pull/2154) by Colby Swandale.
* Remove PID from gem index directory. Pull request [#2155](https://github.com/ruby/rubygems/pull/2155) by SHIBATA
  Hiroshi.
* Nil guard on `Gem::Specification`. Pull request [#2164](https://github.com/ruby/rubygems/pull/2164) by SHIBATA
  Hiroshi.
* Skip broken test with macOS platform. Pull request [#2167](https://github.com/ruby/rubygems/pull/2167) by SHIBATA
  Hiroshi.
* Support option for `--destdir` with upgrade installer. Pull request
  [#2169](https://github.com/ruby/rubygems/pull/2169) by SHIBATA Hiroshi.
* To use constant instead of hard-coded version. Pull request [#2171](https://github.com/ruby/rubygems/pull/2171) by
  SHIBATA Hiroshi.
* Add Rake task to install dev dependencies. Pull request [#2173](https://github.com/ruby/rubygems/pull/2173) by Ellen
  Marie Dash.
* Add new sections to the README and explanation of what RubyGems is.
  Pull request [#2174](https://github.com/ruby/rubygems/pull/2174) by Colby Swandale.
* Prefer to use `Numeric#zero?` instead of `== 0`. Pull request [#2176](https://github.com/ruby/rubygems/pull/2176) by
  SHIBATA Hiroshi.
* Ignore performance test of version regexp pattern. Pull request [#2179](https://github.com/ruby/rubygems/pull/2179) by
  SHIBATA Hiroshi.
* Ignore .DS_Store files in the update_manifest task. Pull request [#2199](https://github.com/ruby/rubygems/pull/2199)
  by Colby Swandale.
* Allow building gems without having to be in the gem folder . Pull
  request [#2204](https://github.com/ruby/rubygems/pull/2204) by Colby Swandale.
* Added coverage ability used by simplecov. Pull request [#2207](https://github.com/ruby/rubygems/pull/2207) by SHIBATA
  Hiroshi.
* Improve invalid proxy error message. Pull request [#2217](https://github.com/ruby/rubygems/pull/2217) by Luis
  Sagastume.
* Simplify home directory detection and platform condition. Pull request
  [#2218](https://github.com/ruby/rubygems/pull/2218) by SHIBATA Hiroshi.
* Permission options. Pull request [#2219](https://github.com/ruby/rubygems/pull/2219) by Nobuyoshi Nakada.
* Improve gemspec and package task. Pull request [#2220](https://github.com/ruby/rubygems/pull/2220) by SHIBATA Hiroshi.
* Prefer to use util_spec in `Gem::TestCase`. Pull request [#2227](https://github.com/ruby/rubygems/pull/2227) by
  SHIBATA Hiroshi.
*  [Requirement] Treat requirements with == versions as equal. Pull
  request [#2230](https://github.com/ruby/rubygems/pull/2230) by Samuel Giddins.
* Add a note for the non-semantically versioned case. Pull request [#2242](https://github.com/ruby/rubygems/pull/2242)
  by David Rodríguez.
* Keep feature names loaded in the block. Pull request [#2261](https://github.com/ruby/rubygems/pull/2261) by Nobuyoshi
  Nakada.
* Tweak warning recommendation. Pull request [#2266](https://github.com/ruby/rubygems/pull/2266) by David Rodríguez.
* Show git path in gem env. Pull request [#2268](https://github.com/ruby/rubygems/pull/2268) by Luis Sagastume.
* Add `--env-shebang` flag to setup command. Pull request [#2271](https://github.com/ruby/rubygems/pull/2271) by James
  Myers.
* Support SOURCE_DATE_EPOCH to make gem spec reproducible. Pull request
  [#2278](https://github.com/ruby/rubygems/pull/2278) by Levente Polyak.
* Chdir back to original directory when building an extension fails. Pull
  request [#2282](https://github.com/ruby/rubygems/pull/2282) by Samuel Giddins.
* [Rakefile] Add a default task that runs the tests. Pull request [#2283](https://github.com/ruby/rubygems/pull/2283) by
  Samuel Giddins.
* Support SOURCE_DATE_EPOCH to make gem tar reproducible. Pull request
  [#2289](https://github.com/ruby/rubygems/pull/2289) by Levente Polyak.
* Reset hooks in test cases. Pull request [#2297](https://github.com/ruby/rubygems/pull/2297) by Samuel Giddins.
* Minor typo: nokogiri. Pull request [#2298](https://github.com/ruby/rubygems/pull/2298) by Darshan Baid.
* Ignore vendored molinillo from code coverage. Pull request [#2302](https://github.com/ruby/rubygems/pull/2302) by
  SHIBATA Hiroshi.
* Support IO.copy_stream. Pull request [#2303](https://github.com/ruby/rubygems/pull/2303) by okkez.
* Prepare beta release. Pull request [#2304](https://github.com/ruby/rubygems/pull/2304) by SHIBATA Hiroshi.
* Add error message when trying to open a default gem. Pull request [#2307](https://github.com/ruby/rubygems/pull/2307)
  by Luis Sagastume.
* Add alias command 'i' for 'install' command. Pull request [#2308](https://github.com/ruby/rubygems/pull/2308) by
  ota42y.
* Cleanup rdoc task in Rakefile. Pull request [#2318](https://github.com/ruby/rubygems/pull/2318) by SHIBATA Hiroshi.
* Add testcase to test_gem_text.rb. Pull request [#2329](https://github.com/ruby/rubygems/pull/2329) by Oliver.
* Gem build strict option. Pull request [#2332](https://github.com/ruby/rubygems/pull/2332) by David Rodríguez.
* Make spec reset more informative. Pull request [#2333](https://github.com/ruby/rubygems/pull/2333) by Luis Sagastume.
* [Rakefile] Set bundler build metadata when doing a release. Pull request
  [#2335](https://github.com/ruby/rubygems/pull/2335) by Samuel Giddins.
* Speed up globbing relative to given directories. Pull request [#2336](https://github.com/ruby/rubygems/pull/2336) by
  Samuel Giddins.
* Remove semver gem build warning. Pull request [#2351](https://github.com/ruby/rubygems/pull/2351) by David Rodríguez.
* Expand symlinks in gem path. Pull request [#2352](https://github.com/ruby/rubygems/pull/2352) by Benoit Daloze.
* Normalize comment indentations. Pull request [#2353](https://github.com/ruby/rubygems/pull/2353) by David Rodríguez.
* Add bindir flag to pristine. Pull request [#2361](https://github.com/ruby/rubygems/pull/2361) by Luis Sagastume.
* Add --user-install behaviour to cleanup command. Pull request [#2362](https://github.com/ruby/rubygems/pull/2362) by
  Luis Sagastume.
* Allow build options to be passed to Rake. Pull request [#2382](https://github.com/ruby/rubygems/pull/2382) by Alyssa
  Ross.
* Add --re-sign flag to cert command. Pull request [#2391](https://github.com/ruby/rubygems/pull/2391) by Luis
  Sagastume.
* Fix "interpreted as grouped expression" warning. Pull request [#2399](https://github.com/ruby/rubygems/pull/2399) by
  Colby Swandale.
* [Gem::Ext::Builder] Comments to aid future refactoring. Pull request
  [#2405](https://github.com/ruby/rubygems/pull/2405) by Ellen Marie Dash.
* Move CONTRIBUTING.rdoc and POLICIES.rdoc documents to markdown. Pull
  request [#2412](https://github.com/ruby/rubygems/pull/2412) by Colby Swandale.
* Improve certificate expiration defaults. Pull request [#2420](https://github.com/ruby/rubygems/pull/2420) by Luis
  Sagastume.
* Freeze all possible constants. Pull request [#2422](https://github.com/ruby/rubygems/pull/2422) by Colby Swandale.
* Fix bundler rubygems binstub not properly looking for bundler. Pull
  request [#2426](https://github.com/ruby/rubygems/pull/2426) by David Rodríguez.
* Make sure rubygems never leaks to another installation. Pull request
  [#2427](https://github.com/ruby/rubygems/pull/2427) by David Rodríguez.
* Update README.md. Pull request [#2428](https://github.com/ruby/rubygems/pull/2428) by Marc-André Lafortune.
* Restrict special chars from prefixing new gem names. Pull request [#2432](https://github.com/ruby/rubygems/pull/2432)
  by Luis Sagastume.
* This removes support for dynamic API backend lookup via DNS SRV records.
  Pull request [#2433](https://github.com/ruby/rubygems/pull/2433) by Arlandis Word.
* Fix link to CONTRIBUTING.md doc. Pull request [#2434](https://github.com/ruby/rubygems/pull/2434) by Arlandis Word.
* Support Keyword args with Psych. Pull request [#2439](https://github.com/ruby/rubygems/pull/2439) by SHIBATA Hiroshi.
* Bug/kernel#warn uplevel. Pull request [#2442](https://github.com/ruby/rubygems/pull/2442) by Nobuyoshi Nakada.
* Improve certificate error message. Pull request [#2454](https://github.com/ruby/rubygems/pull/2454) by Luis Sagastume.
* Update gem open command help text. Pull request [#2458](https://github.com/ruby/rubygems/pull/2458) by Aditya Prakash.
* Uninstall with versions. Pull request [#2466](https://github.com/ruby/rubygems/pull/2466) by David Rodríguez.
* Add output option to build command. Pull request [#2501](https://github.com/ruby/rubygems/pull/2501) by Colby
  Swandale.
* Move rubocop into a separate stage in travis ci. Pull request [#2510](https://github.com/ruby/rubygems/pull/2510) by
  Colby Swandale.
* Ignore warnings with test_gem_specification.rb. Pull request [#2523](https://github.com/ruby/rubygems/pull/2523) by
  SHIBATA Hiroshi.
* Support the environment without OpenSSL. Pull request [#2528](https://github.com/ruby/rubygems/pull/2528) by SHIBATA
  Hiroshi.

### Bug fixes:

* Fix undefined method error when printing alert. Pull request [#1884](https://github.com/ruby/rubygems/pull/1884) by
  Robert Ross.
* Frozen string fix - lib/rubygems/bundler_version_finder.rb. Pull request
  [#2115](https://github.com/ruby/rubygems/pull/2115) by MSP-Greg.
* Fixed typos. Pull request [#2143](https://github.com/ruby/rubygems/pull/2143) by SHIBATA Hiroshi.
* Fix regression of destdir on Windows platform. Pull request [#2178](https://github.com/ruby/rubygems/pull/2178) by
  SHIBATA Hiroshi.
* Fixed no assignment variables about default gems installation. Pull
  request [#2181](https://github.com/ruby/rubygems/pull/2181) by SHIBATA Hiroshi.
* Fix spelling errors in the README. Pull request [#2187](https://github.com/ruby/rubygems/pull/2187) by Colby Swandale.
* Missing comma creates ambiguous meaning. Pull request [#2190](https://github.com/ruby/rubygems/pull/2190) by Clifford
  Heath.
* Fix getting started instructions. Pull request [#2198](https://github.com/ruby/rubygems/pull/2198) by Luis Sagastume.
* Fix rubygems dev env. Pull request [#2201](https://github.com/ruby/rubygems/pull/2201) by Luis Sagastume.
* Fix #1470: generate documentation when --install-dir is present. Pull
  request [#2229](https://github.com/ruby/rubygems/pull/2229) by Elias Hernandis.
* Fix activation when multiple platforms installed. Pull request [#2339](https://github.com/ruby/rubygems/pull/2339) by
  MSP-Greg.
* Fix required_ruby_version with prereleases and improve error message.
  Pull request [#2344](https://github.com/ruby/rubygems/pull/2344) by David Rodríguez.
* Update tests for 'newer' Windows builds. Pull request [#2348](https://github.com/ruby/rubygems/pull/2348) by MSP-Greg.
* Fix broken rubocop task by upgrading to 0.58.1. Pull request [#2356](https://github.com/ruby/rubygems/pull/2356) by
  David Rodríguez.
* Gem::Version should handle nil like it used to before. Pull request
  [#2363](https://github.com/ruby/rubygems/pull/2363) by Luis Sagastume.
* Avoid need of C++ compiler to pass the test suite. Pull request [#2367](https://github.com/ruby/rubygems/pull/2367) by
  Vít Ondruch.
* Fix auto resign expired certificate. Pull request [#2380](https://github.com/ruby/rubygems/pull/2380) by Luis
  Sagastume.
* Skip permissions-dependent test when root. Pull request [#2386](https://github.com/ruby/rubygems/pull/2386) by Alyssa
  Ross.
* Fix test that depended on /usr/bin being in PATH. Pull request [#2387](https://github.com/ruby/rubygems/pull/2387) by
  Alyssa Ross.
* Fixed test fail with mswin environment. Pull request [#2390](https://github.com/ruby/rubygems/pull/2390) by SHIBATA
  Hiroshi.
* Fix broken builds using the correct rubocop version. Pull request [#2396](https://github.com/ruby/rubygems/pull/2396)
  by Luis Sagastume.
* Fix extension builder failure when verbose. Pull request [#2457](https://github.com/ruby/rubygems/pull/2457) by Sorah
  Fukumori.
* Fix test warnings. Pull request [#2472](https://github.com/ruby/rubygems/pull/2472) by MSP-Greg.
* The test suite of bundler is not present ruby description. Pull request
  [#2484](https://github.com/ruby/rubygems/pull/2484) by SHIBATA Hiroshi.
* Fix crash on certain gemspecs. Pull request [#2506](https://github.com/ruby/rubygems/pull/2506) by David Rodríguez.
* Fixed test fails with the newer version of OpenSSL. Pull request [#2507](https://github.com/ruby/rubygems/pull/2507)
  by SHIBATA Hiroshi.
* Fix broken symlink that points to ../*. Pull request [#2516](https://github.com/ruby/rubygems/pull/2516) by Akira
  Matsuda.
* Fix remote fetcher tests. Pull request [#2520](https://github.com/ruby/rubygems/pull/2520) by Luis Sagastume.
* Fix tests when --program-suffix and similar ruby configure options are
  used. Pull request [#2529](https://github.com/ruby/rubygems/pull/2529) by Jeremy Evans.

### Breaking changes:

* IO.binread is not provided at Ruby 1.8. Pull request [#2093](https://github.com/ruby/rubygems/pull/2093) by SHIBATA
  Hiroshi.
* Ignored to publish rdoc documentation of rubygems for
  docs.seattlerb.org. Pull request [#2105](https://github.com/ruby/rubygems/pull/2105) by SHIBATA Hiroshi.
* Support pre-release RubyGems. Pull request [#2128](https://github.com/ruby/rubygems/pull/2128) by SHIBATA Hiroshi.
* Relax minitest version for 5. Pull request [#2131](https://github.com/ruby/rubygems/pull/2131) by SHIBATA Hiroshi.
* Remove zentest from dev dependency. Pull request [#2132](https://github.com/ruby/rubygems/pull/2132) by SHIBATA
  Hiroshi.
* Remove hoe for test suite. Pull request [#2160](https://github.com/ruby/rubygems/pull/2160) by SHIBATA Hiroshi.
* Cleanup deprecated tasks. Pull request [#2162](https://github.com/ruby/rubygems/pull/2162) by SHIBATA Hiroshi.
* Drop to support Ruby < 2.2. Pull request [#2182](https://github.com/ruby/rubygems/pull/2182) by SHIBATA Hiroshi.
* Cleanup deprecated style. Pull request [#2193](https://github.com/ruby/rubygems/pull/2193) by SHIBATA Hiroshi.
* Remove CVEs from the rubygems repo. Pull request [#2195](https://github.com/ruby/rubygems/pull/2195) by Colby
  Swandale.
* Removed needless condition for old version of ruby. Pull request [#2206](https://github.com/ruby/rubygems/pull/2206)
  by SHIBATA Hiroshi.
* Removed deprecated methods over the limit day. Pull request [#2216](https://github.com/ruby/rubygems/pull/2216) by
  SHIBATA Hiroshi.
* Remove syck support. Pull request [#2222](https://github.com/ruby/rubygems/pull/2222) by SHIBATA Hiroshi.
* Removed needless condition for Encoding. Pull request [#2223](https://github.com/ruby/rubygems/pull/2223) by SHIBATA
  Hiroshi.
* Removed needless condition for String#force_encoding. Pull request [#2225](https://github.com/ruby/rubygems/pull/2225)
  by SHIBATA Hiroshi.
* Removed needless OpenSSL patch for Ruby 1.8. Pull request [#2243](https://github.com/ruby/rubygems/pull/2243) by
  SHIBATA Hiroshi.
* Removed compatibility code for Ruby 1.9.2. Pull request [#2244](https://github.com/ruby/rubygems/pull/2244) by SHIBATA
  Hiroshi.
* Removed needless version condition for the old ruby. Pull request [#2252](https://github.com/ruby/rubygems/pull/2252)
  by SHIBATA Hiroshi.
* Remove needless define/respond_to condition. Pull request [#2255](https://github.com/ruby/rubygems/pull/2255) by
  SHIBATA Hiroshi.
* Use File.realpath directly in Gem::Package. Pull request [#2284](https://github.com/ruby/rubygems/pull/2284) by
  SHIBATA Hiroshi.
* Removed needless condition for old versions of Ruby. Pull request [#2286](https://github.com/ruby/rubygems/pull/2286)
  by SHIBATA Hiroshi.
* Remove the --rdoc and --ri options from install/update. Pull request
  [#2354](https://github.com/ruby/rubygems/pull/2354) by Colby Swandale.
* Move authors assigner to required attributes section of
  Gem::Specification. Pull request [#2406](https://github.com/ruby/rubygems/pull/2406) by Grey Baker.
* Remove rubyforge_page functionality. Pull request [#2436](https://github.com/ruby/rubygems/pull/2436) by Nick
  Schwaderer.
* Drop ruby 1.8 support and use IO.popen. Pull request [#2441](https://github.com/ruby/rubygems/pull/2441) by Nobuyoshi
  Nakada.
* Drop ruby 2.2 support. Pull request [#2487](https://github.com/ruby/rubygems/pull/2487) by David Rodríguez.
* Remove some old compatibility code. Pull request [#2488](https://github.com/ruby/rubygems/pull/2488) by David
  Rodríguez.
* Remove .document from src. Pull request [#2489](https://github.com/ruby/rubygems/pull/2489) by Colby Swandale.
* Remove old version support. Pull request [#2493](https://github.com/ruby/rubygems/pull/2493) by Nobuyoshi Nakada.
* [BudlerVersionFinder] set .filter! and .compatible? to match only on
  major versions. Pull request [#2515](https://github.com/ruby/rubygems/pull/2515) by Colby Swandale.

## 2.7.10 / 2019-06-14

### Enhancements:

* Fix bundler rubygems binstub not properly looking for bundler. Pull request [#2426](https://github.com/ruby/rubygems/pull/2426)
  by David Rodríguez.
* [BudlerVersionFinder] set .filter! and .compatible? to match only on major versions.
  Pull request [#2515](https://github.com/ruby/rubygems/pull/2515) by Colby Swandale.
+ Update for compatibility with new minitest. Pull request [#2118](https://github.com/ruby/rubygems/pull/2118) by MSP-Greg.

## 2.7.9 / 2019-03-05

Security fixes:

  * CVE-2019-8320: Delete directory using symlink when decompressing tar
  * CVE-2019-8321: Escape sequence injection vulnerability in `verbose`
  * CVE-2019-8322: Escape sequence injection vulnerability in `gem owner`
  * CVE-2019-8323: Escape sequence injection vulnerability in API response handling
  * CVE-2019-8324: Installing a malicious gem may lead to arbitrary code execution
  * CVE-2019-8325: Escape sequence injection vulnerability in errors

## 2.7.8 / 2018-11-02

### Enhancements:

* [Requirement] Treat requirements with == versions as equal. Pull
  request [#2230](https://github.com/ruby/rubygems/pull/2230) by Samuel Giddins.
* Fix exec_name documentation. Pull request [#2239](https://github.com/ruby/rubygems/pull/2239) by Luis Sagastume.
* [TarHeader] Extract the empty header into a constant. Pull request [#2247](https://github.com/ruby/rubygems/pull/2247)
  by Samuel Giddins.
* Simplify the code that lets us call the original, non-monkeypatched
  Kernel#require. Pull request [#2267](https://github.com/ruby/rubygems/pull/2267) by Leon Miller-Out.
* Add install alias documentation. Pull request [#2320](https://github.com/ruby/rubygems/pull/2320) by ota42y.
* [Rakefile] Set bundler build metadata when doing a release. Pull request
  [#2335](https://github.com/ruby/rubygems/pull/2335) by Samuel Giddins.
* Backport commits from ruby core . Pull request [#2347](https://github.com/ruby/rubygems/pull/2347) by SHIBATA Hiroshi.
* Sign in to the correct host before push. Pull request [#2366](https://github.com/ruby/rubygems/pull/2366) by Luis
  Sagastume.
* Bump bundler-1.16.4. Pull request [#2381](https://github.com/ruby/rubygems/pull/2381) by SHIBATA Hiroshi.
* Improve bindir flag description. Pull request [#2383](https://github.com/ruby/rubygems/pull/2383) by Luis Sagastume.
* Update bundler-1.16.6. Pull request [#2423](https://github.com/ruby/rubygems/pull/2423) by SHIBATA Hiroshi.

### Bug fixes:

* Fix #1470: generate documentation when --install-dir is present. Pull
  request [#2229](https://github.com/ruby/rubygems/pull/2229) by Elias Hernandis.
* Fix no proxy checking. Pull request [#2249](https://github.com/ruby/rubygems/pull/2249) by Luis Sagastume.
* Validate SPDX license exceptions. Pull request [#2257](https://github.com/ruby/rubygems/pull/2257) by Mikit.
* Retry api specification spec with original platform. Pull request [#2275](https://github.com/ruby/rubygems/pull/2275)
  by Luis Sagastume.
* Fix approximate recommendation with prereleases. Pull request [#2345](https://github.com/ruby/rubygems/pull/2345) by
  David Rodríguez.
* Gem::Version should handle nil like it used to before. Pull request
  [#2363](https://github.com/ruby/rubygems/pull/2363) by Luis Sagastume.

## 2.7.7 / 2018-05-08

### Enhancements:

* [RequestSet] Only suggest a gem version with an installable platform.
  Pull request [#2175](https://github.com/ruby/rubygems/pull/2175) by Samuel Giddins.
* Fixed no assignment variables about default gems installation. Pull
  request [#2181](https://github.com/ruby/rubygems/pull/2181) by SHIBATA Hiroshi.
* Backport improvements for test-case from Ruby core. Pull request [#2189](https://github.com/ruby/rubygems/pull/2189)
  by SHIBATA Hiroshi.
* Fix ruby warnings in test suite. Pull request [#2205](https://github.com/ruby/rubygems/pull/2205) by Colby Swandale.
* To use Gem::Specification#bindir of bundler instead of hard coded path.
  Pull request [#2208](https://github.com/ruby/rubygems/pull/2208) by SHIBATA Hiroshi.
* Update gem push --help description. Pull request [#2215](https://github.com/ruby/rubygems/pull/2215) by Luis
  Sagastume.
* Backport ruby core commits. Pull request [#2264](https://github.com/ruby/rubygems/pull/2264) by SHIBATA Hiroshi.

### Bug fixes:

* Frozen string fix - lib/rubygems/bundler_version_finder.rb. Pull request
  [#2115](https://github.com/ruby/rubygems/pull/2115) by MSP-Greg.
* Fixed tempfile leak for RubyGems 2.7.6. Pull request [#2194](https://github.com/ruby/rubygems/pull/2194) by SHIBATA
  Hiroshi.
* Add missing requires. Pull request [#2196](https://github.com/ruby/rubygems/pull/2196) by David Rodríguez.
* Fix Gem::Version.correct?. Pull request [#2203](https://github.com/ruby/rubygems/pull/2203) by Masato Nakamura.
* Fix verify_entry regex for metadata. Pull request [#2212](https://github.com/ruby/rubygems/pull/2212) by Luis
  Sagastume.
* Fix path checks for case insensitive filesystem. Pull request [#2211](https://github.com/ruby/rubygems/pull/2211) by
  Lars Kanis.

### Deprecations:

* Deprecate unused code before removing them at #1524. Pull request [#2197](https://github.com/ruby/rubygems/pull/2197)
  by SHIBATA Hiroshi.
* Deprecate for rubygems 3. Pull request [#2214](https://github.com/ruby/rubygems/pull/2214) by SHIBATA Hiroshi.
* Mark deprecation to `ubygems.rb` for RubyGems 4. Pull request [#2269](https://github.com/ruby/rubygems/pull/2269) by
  SHIBATA Hiroshi.

### Breaking changes:

* Update bundler-1.16.2. Pull request [#2291](https://github.com/ruby/rubygems/pull/2291) by SHIBATA Hiroshi.

## 2.7.6 / 2018-02-16

Security fixes:

* Prevent path traversal when writing to a symlinked basedir outside of the root.
  Discovered by nmalkin, fixed by Jonathan Claudius and Samuel Giddins.
* Fix possible Unsafe Object Deserialization Vulnerability in gem owner.
  Fixed by Jonathan Claudius.
* Strictly interpret octal fields in tar headers.
  Discovered by plover, fixed by Samuel Giddins.
* Raise a security error when there are duplicate files in a package.
  Discovered by plover, fixed by Samuel Giddins.
* Enforce URL validation on spec homepage attribute.
  Discovered by Yasin Soliman, fixed by Jonathan Claudius.
* Mitigate XSS vulnerability in homepage attribute when displayed via `gem server`.
  Discovered by Yasin Soliman, fixed by Jonathan Claudius.
* Prevent Path Traversal issue during gem installation.
  Discovered by nmalkin.

## 2.7.5

### Bug fixes:

* To use bundler-1.16.1 #2121 by SHIBATA Hiroshi.
* Fixed leaked FDs. Pull request [#2127](https://github.com/ruby/rubygems/pull/2127) by Nobuyoshi Nakada.
* Support option for `--destdir` with upgrade installer. #2169 by Thibault Jouan.
* Remove PID from gem index directory. #2155 by SHIBATA Hiroshi.
* Avoid a #mkdir race condition #2148 by Samuel Giddins.
* Gem::Util.traverse_parents should not crash on permissions error #2147 by Robert Ulejczyk.
* Use `File.open` instead of `open`. #2142 by SHIBATA Hiroshi.
* Set whether bundler is used for gemdeps with an environmental variable #2126 by SHIBATA Hiroshi.
* Fix undefined method error when printing alert #1884 by Robert Ross.

## 2.7.4

### Bug fixes:

* Fixed leaked FDs. Pull request [#2127](https://github.com/ruby/rubygems/pull/2127) by Nobuyoshi Nakada.
* Avoid to warnings about gemspec loadings in rubygems tests. Pull request
  [#2125](https://github.com/ruby/rubygems/pull/2125) by SHIBATA Hiroshi.
* Fix updater with rubygems-2.7.3 Pull request [#2124](https://github.com/ruby/rubygems/pull/2124) by SHIBATA Hiroshi.
* Handle environment that does not have `flock` system call. Pull request
  [#2107](https://github.com/ruby/rubygems/pull/2107) by SHIBATA Hiroshi.

## 2.7.3

### Enhancements:

* Removed needless version lock. Pull request [#2074](https://github.com/ruby/rubygems/pull/2074) by SHIBATA Hiroshi.
* Add --[no-]check-development option to cleanup command. Pull request
  [#2061](https://github.com/ruby/rubygems/pull/2061) by Lin Jen-Shin (godfat).
* Merge glob pattern using braces. Pull request [#2072](https://github.com/ruby/rubygems/pull/2072) by Kazuhiro
  NISHIYAMA.
* Removed warnings of unused variables. Pull request [#2084](https://github.com/ruby/rubygems/pull/2084) by SHIBATA
  Hiroshi.
* Call SPDX.org using HTTPS. Pull request [#2102](https://github.com/ruby/rubygems/pull/2102) by Olle Jonsson.
* Remove multi load warning from plugins documentation. Pull request [#2103](https://github.com/ruby/rubygems/pull/2103)
  by Thibault Jouan.

### Bug fixes:

* Fix test failure on Alpine Linux. Pull request [#2079](https://github.com/ruby/rubygems/pull/2079) by Ellen Marie
  Dash.
* Avoid encoding issues by using binread in setup. Pull request [#2089](https://github.com/ruby/rubygems/pull/2089) by
  Mauro Morales.
* Fix rake install_test_deps once the rake clean_env does not exist. Pull
  request [#2090](https://github.com/ruby/rubygems/pull/2090) by Lucas Oliveira.
* Prevent to delete to "bundler-" prefix gem like bundler-audit. Pull
  request [#2086](https://github.com/ruby/rubygems/pull/2086) by SHIBATA Hiroshi.
* Generate .bat files on Windows platform. Pull request [#2094](https://github.com/ruby/rubygems/pull/2094) by SHIBATA
  Hiroshi.
* Workaround common options mutation in Gem::Command test. Pull request
  [#2098](https://github.com/ruby/rubygems/pull/2098) by Thibault Jouan.
* Check gems dir existence before removing bundler. Pull request [#2104](https://github.com/ruby/rubygems/pull/2104) by
  Thibault Jouan.
* Use setup command --regenerate-binstubs option flag. Pull request [#2099](https://github.com/ruby/rubygems/pull/2099)
  by Thibault Jouan.

## 2.7.2

### Bug fixes:

* Added template files to vendoerd bundler. Pull request [#2065](https://github.com/ruby/rubygems/pull/2065) by SHIBATA
  Hiroshi.
* Added workaround for non-git environment. Pull request [#2066](https://github.com/ruby/rubygems/pull/2066) by SHIBATA
  Hiroshi.

## 2.7.1 (2017-11-03)

### Bug fixes:

* Fix `gem update --system` with RubyGems 2.7+. Pull request [#2054](https://github.com/ruby/rubygems/pull/2054) by
  Samuel Giddins.

## 2.7.0 (2017-11-02)

### Enhancements:

* Update vendored bundler-1.16.0. Pull request [#2051](https://github.com/ruby/rubygems/pull/2051) by Samuel Giddins.
* Use Bundler for Gem.use_gemdeps. Pull request [#1674](https://github.com/ruby/rubygems/pull/1674) by Samuel Giddins.
* Add command `signin` to `gem` CLI. Pull request [#1944](https://github.com/ruby/rubygems/pull/1944) by Shiva Bhusal.
* Add Logout feature to CLI. Pull request [#1938](https://github.com/ruby/rubygems/pull/1938) by Shiva Bhusal.
* Added message to uninstall command for gem that is not installed. Pull
  request [#1979](https://github.com/ruby/rubygems/pull/1979) by anant anil kolvankar.
* Add --trust-policy option to unpack command. Pull request [#1718](https://github.com/ruby/rubygems/pull/1718) by
  Nobuyoshi Nakada.
* Show default gems for all platforms. Pull request [#1685](https://github.com/ruby/rubygems/pull/1685) by Konstantin
  Shabanov.
* Add Travis and Appveyor build status to README. Pull request [#1918](https://github.com/ruby/rubygems/pull/1918) by
  Jun Aruga.
* Remove warning `no email specified` when no email. Pull request [#1675](https://github.com/ruby/rubygems/pull/1675) by
  Leigh McCulloch.
* Improve -rubygems performance. Pull request [#1801](https://github.com/ruby/rubygems/pull/1801) by Samuel Giddins.
* Improve the performance of Kernel#require. Pull request [#1678](https://github.com/ruby/rubygems/pull/1678) by Samuel
  Giddins.
* Improve user-facing messages by consistent casing of Ruby/RubyGems. Pull
  request [#1771](https://github.com/ruby/rubygems/pull/1771) by John Labovitz.
* Improve error message when Gem::RuntimeRequirementNotMetError is raised.
  Pull request [#1789](https://github.com/ruby/rubygems/pull/1789) by Luis Sagastume.
* Code Improvement: Inheritance corrected. Pull request [#1942](https://github.com/ruby/rubygems/pull/1942) by Shiva
  Bhusal.
* [Source] Autoload fileutils. Pull request [#1906](https://github.com/ruby/rubygems/pull/1906) by Samuel Giddins.
* Use Hash#fetch instead of if/else in Gem::ConfigFile. Pull request [#1824](https://github.com/ruby/rubygems/pull/1824)
  by Daniel Berger.
* Require digest when it is used. Pull request [#2006](https://github.com/ruby/rubygems/pull/2006) by Samuel Giddins.
* Do not index the doc folder in the `update_manifest` task. Pull request
  [#2031](https://github.com/ruby/rubygems/pull/2031) by Colby Swandale.
* Don't use two postfix conditionals on one line. Pull request [#2038](https://github.com/ruby/rubygems/pull/2038) by
  Ellen Marie Dash.
* [SafeYAML] Avoid warning when Gem::Deprecate.skip is set. Pull request
  [#2034](https://github.com/ruby/rubygems/pull/2034) by Samuel Giddins.
* Update gem yank description. Pull request [#2009](https://github.com/ruby/rubygems/pull/2009) by David Radcliffe.
* Fix formatting of installation instructions in README. Pull request
  [#2018](https://github.com/ruby/rubygems/pull/2018) by Jordan Danford.
* Do not use #quick_spec internally. Pull request [#1733](https://github.com/ruby/rubygems/pull/1733) by Jon Moss.
* Switch from docs to guides reference. Pull request [#1886](https://github.com/ruby/rubygems/pull/1886) by Jonathan
  Claudius.
* Happier message when latest version is already installed. Pull request
  [#1956](https://github.com/ruby/rubygems/pull/1956) by Jared Beck.
* Update specification reference docs. Pull request [#1960](https://github.com/ruby/rubygems/pull/1960) by Grey Baker.
* Allow Gem.finish_resolve to respect already-activated specs. Pull
  request [#1910](https://github.com/ruby/rubygems/pull/1910) by Samuel Giddins.
* Update cryptography for Gem::Security. Pull request [#1691](https://github.com/ruby/rubygems/pull/1691) by Sylvain
  Daubert.
* Don't output mkmf.log message if compilation didn't fail. Pull request
  [#1808](https://github.com/ruby/rubygems/pull/1808) by Jeremy Evans.
* Matches_for_glob - remove root path. Pull request [#2010](https://github.com/ruby/rubygems/pull/2010) by ahorek.
* Gem::Resolver#search_for update for reliable searching/sorting. Pull
  request [#1993](https://github.com/ruby/rubygems/pull/1993) by MSP-Greg.
* Allow local installs with transitive prerelease requirements. Pull
  request [#1990](https://github.com/ruby/rubygems/pull/1990) by Samuel Giddins.
* Small style fixes to Installer Set. Pull request [#1985](https://github.com/ruby/rubygems/pull/1985) by Arthur
  Marzinkovskiy.
* Setup cmd: Avoid terminating option string w/ dot. Pull request [#1825](https://github.com/ruby/rubygems/pull/1825) by
  Olle Jonsson.
* Warn when no files are set. Pull request [#1773](https://github.com/ruby/rubygems/pull/1773) by Aidan Coyle.
* Ensure `to_spec` falls back on prerelease specs. Pull request [#1755](https://github.com/ruby/rubygems/pull/1755) by
  André Arko.
* [Specification] Eval setting default attributes in #initialize. Pull
  request [#1739](https://github.com/ruby/rubygems/pull/1739) by Samuel Giddins.
* Sort ordering of sources is preserved. Pull request [#1633](https://github.com/ruby/rubygems/pull/1633) by Nathan
  Ladd.
* Retry with :prerelease when no suggestions are found. Pull request [#1696](https://github.com/ruby/rubygems/pull/1696)
  by Aditya Prakash.
* [Rakefile] Run `git submodule update --init` in `rake newb`. Pull
  request [#1694](https://github.com/ruby/rubygems/pull/1694) by Samuel Giddins.
* [TestCase] Address comments around ui changes. Pull request [#1677](https://github.com/ruby/rubygems/pull/1677) by
  Samuel Giddins.
* Eagerly resolve in activate_bin_path. Pull request [#1666](https://github.com/ruby/rubygems/pull/1666) by Samuel
  Giddins.
* [Version] Make hash based upon canonical segments. Pull request [#1659](https://github.com/ruby/rubygems/pull/1659) by
  Samuel Giddins.
* Add Ruby Together CTA, rearrange README a bit. Pull request [#1775](https://github.com/ruby/rubygems/pull/1775) by
  Michael Bernstein.
* Update Contributing.rdoc with new label usage. Pull request [#1716](https://github.com/ruby/rubygems/pull/1716) by
  Lynn Cyrin.
* Add --host sample to help. Pull request [#1709](https://github.com/ruby/rubygems/pull/1709) by Code Ahss.
* Add a helpful suggestion when `gem install` fails due to required_rub….
  Pull request [#1697](https://github.com/ruby/rubygems/pull/1697) by Samuel Giddins.
* Add cert expiration length flag. Pull request [#1725](https://github.com/ruby/rubygems/pull/1725) by Luis Sagastume.
* Add submodule instructions to manual install. Pull request [#1727](https://github.com/ruby/rubygems/pull/1727) by
  Joseph Frazier.
* Allow usage of multiple `--version` operators. Pull request [#1546](https://github.com/ruby/rubygems/pull/1546) by
  James Wen.
* Warn when requiring deprecated files. Pull request [#1939](https://github.com/ruby/rubygems/pull/1939) by Ellen Marie
  Dash.

### Deprecations:

* Deprecate Gem::InstallerTestCase#util_gem_bindir and
  Gem::InstallerTestCase#util_gem_dir. Pull request [#1729](https://github.com/ruby/rubygems/pull/1729) by Jon Moss.
* Deprecate passing options to Gem::GemRunner. Pull request [#1730](https://github.com/ruby/rubygems/pull/1730) by Jon
  Moss.
* Add deprecation for Gem#datadir. Pull request [#1732](https://github.com/ruby/rubygems/pull/1732) by Jon Moss.
* Add deprecation warning for Gem::DependencyInstaller#gems_to_install.
  Pull request [#1731](https://github.com/ruby/rubygems/pull/1731) by Jon Moss.

### Breaking changes:

* Use `-rrubygems` instead of `-rubygems.rb`. Because ubygems.rb is
  unavailable on Ruby 2.5. Pull request [#2028](https://github.com/ruby/rubygems/pull/2028) #2027 #2029
  by SHIBATA Hiroshi.
* Update Code of Conduct to Contributor Covenant v1.4.0. Pull request
  [#1796](https://github.com/ruby/rubygems/pull/1796) by Matej.

### Bug fixes:

* Fix issue for MinGW / MSYS2 builds and testing. Pull request [#1876](https://github.com/ruby/rubygems/pull/1876) by
  MSP-Greg.
* Fixed broken links and overzealous URL encoding in gem server. Pull
  request [#1809](https://github.com/ruby/rubygems/pull/1809) by Nicole Orchard.
* Fix a typo. Pull request [#1722](https://github.com/ruby/rubygems/pull/1722) by Koichi ITO.
* Fix error message Gem::Security::Policy. Pull request [#1724](https://github.com/ruby/rubygems/pull/1724) by Nobuyoshi
  Nakada.
* Fixing links markdown formatting in README. Pull request [#1791](https://github.com/ruby/rubygems/pull/1791) by Piotr
  Kuczynski.
* Fix failing Bundler 1.8.7 CI builds. Pull request [#1820](https://github.com/ruby/rubygems/pull/1820) by Samuel
  Giddins.
* Fixed test broken on ruby-head . Pull request [#1842](https://github.com/ruby/rubygems/pull/1842) by SHIBATA Hiroshi.
* Fix typos with misspell. Pull request [#1846](https://github.com/ruby/rubygems/pull/1846) by SHIBATA Hiroshi.
* Fix gem open to open highest version number rather than lowest. Pull
  request [#1877](https://github.com/ruby/rubygems/pull/1877) by Tim Pope.
* Fix test_self_find_files_with_gemfile to sort expected files. Pull
  request [#1878](https://github.com/ruby/rubygems/pull/1878) by Kazuaki Matsuo.
* Fix typos in CONTRIBUTING.rdoc. Pull request [#1909](https://github.com/ruby/rubygems/pull/1909) by Mark Sayson.
* Fix some small documentation issues in installer. Pull request [#1972](https://github.com/ruby/rubygems/pull/1972) by
  Colby Swandale.
* Fix links in Policies document. Pull request [#1964](https://github.com/ruby/rubygems/pull/1964) by Alyssa Ross.
* Fix NoMethodError on bundler/inline environment. Pull request [#2042](https://github.com/ruby/rubygems/pull/2042) by
  SHIBATA Hiroshi.
* Correct comments for Gem::InstallerTestCase#setup. Pull request [#1741](https://github.com/ruby/rubygems/pull/1741) by
  MSP-Greg.
* Use File.expand_path for certification and key location. Pull request
  [#1987](https://github.com/ruby/rubygems/pull/1987) by SHIBATA Hiroshi.
* Rescue EROFS. Pull request [#1417](https://github.com/ruby/rubygems/pull/1417) by Nobuyoshi Nakada.
* Fix spelling of 'vulnerability'. Pull request [#2022](https://github.com/ruby/rubygems/pull/2022) by Philip Arndt.
* Fix metadata link key names. Pull request [#1896](https://github.com/ruby/rubygems/pull/1896) by Aditya Prakash.
* Fix a typo in uninstall_command.rb. Pull request [#1934](https://github.com/ruby/rubygems/pull/1934) by Yasuhiro
  Horimoto.
* Gem::Requirement.create treat arguments as variable-length. Pull request
  [#1830](https://github.com/ruby/rubygems/pull/1830) by Toru YAGI.
* Display an explanation when rake encounters an ontological problem. Pull
  request [#1982](https://github.com/ruby/rubygems/pull/1982) by Wilson Bilkovich.
* [Server] Handle gems with names ending in `-\d`. Pull request [#1926](https://github.com/ruby/rubygems/pull/1926) by
  Samuel Giddins.
* [InstallerSet] Avoid reloading _all_ local gems multiple times during
  dependency resolution. Pull request [#1925](https://github.com/ruby/rubygems/pull/1925) by Samuel Giddins.
* Modify the return value of Gem::Version.correct?. Pull request [#1916](https://github.com/ruby/rubygems/pull/1916) by
  Tsukuru Tanimichi.
* Validate metadata link keys. Pull request [#1834](https://github.com/ruby/rubygems/pull/1834) by Aditya Prakash.
* Add changelog to metadata validation. Pull request [#1885](https://github.com/ruby/rubygems/pull/1885) by Aditya
  Prakash.
* Replace socket error text message. Pull request [#1823](https://github.com/ruby/rubygems/pull/1823) by Daniel Berger.
* Raise error if the email is invalid when building cert. Pull request
  [#1779](https://github.com/ruby/rubygems/pull/1779) by Luis Sagastume.
* [StubSpecification] Don’t iterate through all loaded specs in #to_spec.
  Pull request [#1738](https://github.com/ruby/rubygems/pull/1738) by Samuel Giddins.

## 2.6.14 / 2017-10-09

Security fixes:

* Whitelist classes and symbols that are in loaded YAML.
  See CVE-2017-0903 for full details.
  Fix by Aaron Patterson.

## 2.6.13 / 2017-08-27

Security fixes:

* Fix a DNS request hijacking vulnerability. (CVE-2017-0902)
  Discovered by Jonathan Claudius, fix by Samuel Giddins.
* Fix an ANSI escape sequence vulnerability. (CVE-2017-0899)
  Discovered by Yusuke Endoh, fix by Evan Phoenix.
* Fix a DOS vulnerability in the `query` command. (CVE-2017-0900)
  Discovered by Yusuke Endoh, fix by Samuel Giddins.
* Fix a vulnerability in the gem installer that allowed a malicious gem
  to overwrite arbitrary files. (CVE-2017-0901)
  Discovered by Yusuke Endoh, fix by Samuel Giddins.

## 2.6.12 / 2017-04-30

### Bug fixes:

* Fix test_self_find_files_with_gemfile to sort expected files. Pull
  request [#1880](https://github.com/ruby/rubygems/pull/1880) by Kazuaki Matsuo.
* Fix issue for MinGW / MSYS2 builds and testing. Pull request [#1879](https://github.com/ruby/rubygems/pull/1879) by
  MSP-Greg.
* Fix gem open to open highest version number rather than lowest. Pull
  request [#1877](https://github.com/ruby/rubygems/pull/1877) by Tim Pope.
* Add a test for requiring a default spec as installed by the ruby
  installer. Pull request [#1899](https://github.com/ruby/rubygems/pull/1899) by Samuel Giddins.
* Fix broken --exact parameter to gem command. Pull request [#1873](https://github.com/ruby/rubygems/pull/1873) by Jason
  Frey.
* [Installer] Generate backwards-compatible binstubs. Pull request [#1904](https://github.com/ruby/rubygems/pull/1904)
  by Samuel Giddins.
* Fix pre-existing source recognition on add action. Pull request [#1883](https://github.com/ruby/rubygems/pull/1883) by
  Jonathan Claudius.
* Prevent negative IDs in output of #inspect. Pull request [#1908](https://github.com/ruby/rubygems/pull/1908) by Vít
  Ondruch.
* Allow Gem.finish_resolve to respect already-activated specs. Pull
  request [#1910](https://github.com/ruby/rubygems/pull/1910) by Samuel Giddins.

## 2.6.11 / 2017-03-16

### Bug fixes:

* Fixed broken tests on ruby-head. Pull request [#1841](https://github.com/ruby/rubygems/pull/1841) by
  SHIBATA Hiroshi.
* Update vendored Molinillo to 0.5.7. Pull request [#1859](https://github.com/ruby/rubygems/pull/1859) by Samuel
  Giddins.
* Avoid activating Ruby 2.5 default gems when possible. Pull request [#1843](https://github.com/ruby/rubygems/pull/1843)
  by Samuel Giddins.
* Use improved resolver sorting algorithm. Pull request [#1856](https://github.com/ruby/rubygems/pull/1856) by
  Samuel Giddins.

## 2.6.10 / 2017-01-23

### Bug fixes:

* Fix `require` calling the wrong `gem` method when it is overridden.
  Pull request [#1822](https://github.com/ruby/rubygems/pull/1822) by Samuel Giddins.

## 2.6.9 / 2017-01-20

### Bug fixes:

* Allow initializing versions with empty strings. Pull request [#1767](https://github.com/ruby/rubygems/pull/1767) by
  Luis Sagastume.
* Fix TypeError on 2.4. Pull request [#1788](https://github.com/ruby/rubygems/pull/1788) by Nobuyoshi Nakada.
* Don't output mkmf.log message if compilation didn't fail. Pull request
  [#1808](https://github.com/ruby/rubygems/pull/1808) by Jeremy Evans.
* Fixed broken links and overzealous URL encoding in gem server. Pull
  request [#1809](https://github.com/ruby/rubygems/pull/1809) by Nicole Orchard.
* Update vendored Molinillo to 0.5.5. Pull request [#1812](https://github.com/ruby/rubygems/pull/1812) by Samuel
  Giddins.
* RakeBuilder: avoid frozen string issue. Pull request [#1819](https://github.com/ruby/rubygems/pull/1819) by Olle
  Jonsson.

## 2.6.8 / 2016-10-29

### Bug fixes:

* Improve SSL verification failure message. Pull request [#1751](https://github.com/ruby/rubygems/pull/1751)
  by Eric Hodel.
* Ensure `to_spec` falls back on prerelease specs. Pull request
  [#1755](https://github.com/ruby/rubygems/pull/1755) by André Arko.
* Update vendored Molinillo to 0.5.3. Pull request [#1763](https://github.com/ruby/rubygems/pull/1763) by
  Samuel Giddins.

## 2.6.7 / 2016-09-26

### Bug fixes:

* Install native extensions in the correct location when using the
  `--user-install` flag. Pull request [#1683](https://github.com/ruby/rubygems/pull/1683) by Noah Kantrowitz.
* When calling `Gem.sources`, load sources from `configuration`
  if present, else use the default sources. Pull request [#1699](https://github.com/ruby/rubygems/pull/1699)
  by Luis Sagastume.
* Fail gracefully when attempting to redirect without a Location.
  Pull request [#1711](https://github.com/ruby/rubygems/pull/1711) by Samuel Giddins.
* Update vendored Molinillo to 0.5.1. Pull request [#1714](https://github.com/ruby/rubygems/pull/1714) by
  Samuel Giddins.

## 2.6.6 / 2016-06-22

### Bug fixes:

* Sort installed versions to make sure we install the latest version when
  running `gem update --system`. As a one-time fix, run
  `gem update --system=2.6.6`. Pull request [#1601](https://github.com/ruby/rubygems/pull/1601) by David Radcliffe.

## 2.6.5 / 2016-06-21

### Enhancements:

* Support for unified Integer in Ruby 2.4. Pull request [#1618](https://github.com/ruby/rubygems/pull/1618)
  by SHIBATA Hiroshi.
* Update vendored Molinillo to 0.5.0 for performance improvements.
  Pull request [#1638](https://github.com/ruby/rubygems/pull/1638) by Samuel Giddins.

### Bug fixes:

* Raise an explicit error if Signer#sign is called with no certs. Pull
  request [#1605](https://github.com/ruby/rubygems/pull/1605) by Daniel Berger.
* Update `update_bundled_ca_certificates` utility script for directory
  nesting. Pull request [#1583](https://github.com/ruby/rubygems/pull/1583) by James Wen.
* Fix broken symlink support in tar writer (+ fix broken test). Pull
  request [#1578](https://github.com/ruby/rubygems/pull/1578) by Cezary Baginski.
* Remove extension directory before (re-)installing. Pull request [#1576](https://github.com/ruby/rubygems/pull/1576)
  by Jeremy Hinegardner.
* Regenerate test CA certificates with appropriate extensions. Pull
  request [#1611](https://github.com/ruby/rubygems/pull/1611) by rhenium.
* Rubygems does not terminate on failed file lock when not superuser. Pull
  request [#1582](https://github.com/ruby/rubygems/pull/1582) by Ellen Marie Dash.
* Fix tar headers with a 101 character name. Pull request [#1612](https://github.com/ruby/rubygems/pull/1612) by Paweł
  Tomulik.
* Add Gem.platform_defaults to allow implementations to override defaults.
  Pull request [#1644](https://github.com/ruby/rubygems/pull/1644) by Charles Oliver Nutter.
* Run Bundler tests on TravisCI. Pull request [#1650](https://github.com/ruby/rubygems/pull/1650) by Samuel Giddins.

## 2.6.4 / 2016-04-26

### Enhancements:

* Use Gem::Util::NULL_DEVICE instead of hard coded strings. Pull request [#1588](https://github.com/ruby/rubygems/pull/1588)
  by Chris Charabaruk.
* Use File.symlink on MS Windows if supported. Pull request [#1418](https://github.com/ruby/rubygems/pull/1418)
  by Nobuyoshi Nakada.

### Bug fixes:

* Redact uri password from error output when gem fetch fails. Pull request
  [#1565](https://github.com/ruby/rubygems/pull/1565) by Brian Fletcher.
* Suppress warnings. Pull request [#1594](https://github.com/ruby/rubygems/pull/1594) by Nobuyoshi Nakada.
* Escape user-supplied content served on web pages by `gem server` to avoid
  potential XSS vulnerabilities. Samuel Giddins.

## 2.6.3 / 2016-04-05

### Enhancements:

* Lazily calculate Gem::LoadError exception messages. Pull request [#1550](https://github.com/ruby/rubygems/pull/1550)
  by Aaron Patterson.
* New fastly cert. Pull request [#1548](https://github.com/ruby/rubygems/pull/1548) by David Radcliffe.
* Organize and cleanup SSL certs. Pull request [#1555](https://github.com/ruby/rubygems/pull/1555) by James Wen.
* [RubyGems] Make deprecation message for paths= more helpful. Pull
  request [#1562](https://github.com/ruby/rubygems/pull/1562) by Samuel Giddins.
* Show default gems when using "gem list". Pull request [#1570](https://github.com/ruby/rubygems/pull/1570) by Luis
  Sagastume.

### Bug fixes:

* Stub ordering should be consistent regardless of how cache is populated.
  Pull request [#1552](https://github.com/ruby/rubygems/pull/1552) by Aaron Patterson.
* Handle cases when the @@stubs variable contains non-stubs. Pull request
  [#1558](https://github.com/ruby/rubygems/pull/1558) by Per Lundberg.
* Fix test on Windows for inconsistent temp path. Pull request [#1554](https://github.com/ruby/rubygems/pull/1554) by
  Hiroshi Shirosaki.
* Fix `Gem.find_spec_for_exe` picks oldest gem. Pull request [#1566](https://github.com/ruby/rubygems/pull/1566) by
  Shinichi Maeshima.
* [Owner] Fallback to email and userid when owner email is missing. Pull
  request [#1569](https://github.com/ruby/rubygems/pull/1569) by Samuel Giddins.
* [Installer] Handle nil existing executable. Pull request [#1561](https://github.com/ruby/rubygems/pull/1561) by Samuel
  Giddins.
* Allow two digit version numbers in the tests. Pull request [#1575](https://github.com/ruby/rubygems/pull/1575) by unak.

## 2.6.2 / 2016-03-12

### Bug fixes:

* Fix wrong version of gem activation for bin stub. Pull request [#1527](https://github.com/ruby/rubygems/pull/1527) by
  Aaron Patterson.
* Speed up gem activation failures. Pull request [#1539](https://github.com/ruby/rubygems/pull/1539) by Aaron Patterson.
* Fix platform sorting in the resolver. Pull request [#1542](https://github.com/ruby/rubygems/pull/1542) by Samuel E.
  Giddins.
* Ensure we unlock the monitor even if try_activate throws. Pull request
  [#1538](https://github.com/ruby/rubygems/pull/1538) by Charles Oliver Nutter.


## 2.6.1 / 2016-02-28

### Bug fixes:

* Ensure `default_path` and `home` are set for paths. Pull request [#1513](https://github.com/ruby/rubygems/pull/1513)
  by Aaron Patterson.
* Restore but deprecate support for Array values on `Gem.paths=`. Pull
  request [#1514](https://github.com/ruby/rubygems/pull/1514) by Aaron Patterson.
* Fix invalid gem file preventing gem install from working. Pull request
  [#1499](https://github.com/ruby/rubygems/pull/1499) by Luis Sagastume.

## 2.6.0 / 2016-02-26

### Enhancements:

* RubyGems now defaults the `gem push` to the gem's "allowed_push_host"
  metadata setting.  Pull request [#1486](https://github.com/ruby/rubygems/pull/1486) by Josh Lane.
* Update bundled Molinillo to 0.4.3. Pull request [#1493](https://github.com/ruby/rubygems/pull/1493) by Samuel E. Giddins.
* Add version option to gem open command. Pull request [#1483](https://github.com/ruby/rubygems/pull/1483) by Hrvoje
  Šimić.
* Feature/add silent flag. Pull request [#1455](https://github.com/ruby/rubygems/pull/1455) by Luis Sagastume.
* Allow specifying gem requirements via env variables. Pull request [#1472](https://github.com/ruby/rubygems/pull/1472)
  by Samuel E. Giddins.

### Bug fixes:

* RubyGems now stores `gem push` credentials under the host you signed-in for.
  Pull request [#1485](https://github.com/ruby/rubygems/pull/1485) by Josh Lane.
* Move `coding` location to first line. Pull request [#1471](https://github.com/ruby/rubygems/pull/1471) by SHIBATA
  Hiroshi.
* [PathSupport] Handle a regexp path separator. Pull request [#1469](https://github.com/ruby/rubygems/pull/1469) by
  Samuel E. Giddins.
* Clean up the PathSupport object. Pull request [#1094](https://github.com/ruby/rubygems/pull/1094) by Aaron Patterson.
* Join with File::PATH_SEPARATOR in Gem.use_paths. Pull request [#1476](https://github.com/ruby/rubygems/pull/1476) by
  Samuel E. Giddins.
* Handle when the gem home and gem path aren't set in the config file. Pull
  request [#1478](https://github.com/ruby/rubygems/pull/1478) by Samuel E. Giddins.
* Terminate TimeoutHandler. Pull request [#1479](https://github.com/ruby/rubygems/pull/1479) by Nobuyoshi Nakada.
* Remove redundant cache. Pull request [#1482](https://github.com/ruby/rubygems/pull/1482) by Eileen M. Uchitelle.
* Freeze `Gem::Version@segments` instance variable. Pull request [#1487](https://github.com/ruby/rubygems/pull/1487) by
  Ben Dean.
* Gem cleanup is trying to uninstall gems outside GEM_HOME and reporting
  an error after it tries. Pull request [#1353](https://github.com/ruby/rubygems/pull/1353) by Luis Sagastume.
* Avoid duplicated sources. Pull request [#1489](https://github.com/ruby/rubygems/pull/1489) by Luis Sagastume.
* Better description for quiet flag. Pull request [#1491](https://github.com/ruby/rubygems/pull/1491) by Luis Sagastume.
* Raise error if find_by_name returns with nil. Pull request [#1494](https://github.com/ruby/rubygems/pull/1494) by
  Zoltán Hegedüs.
* Find_files only from loaded_gems when using gemdeps. Pull request [#1277](https://github.com/ruby/rubygems/pull/1277)
  by Michal Papis.

## 2.5.2 / 2016-01-31

### Bug fixes:

* Fix memoization of Gem::Version#prerelease? Pull request [#1125](https://github.com/ruby/rubygems/pull/1125) by Matijs van
  Zuijlen.
* Handle trailing colons in GEM_PATH, by Damien Robert.
* Improve the Gemfile `gemspec` method, fixing #1204 and #1033. Pull request
  [#1276](https://github.com/ruby/rubygems/pull/1276) by Michael Papis.
* Warn only once when a gemspec license is invalid. Pull request [#1414](https://github.com/ruby/rubygems/pull/1414) by Samuel
  E. Giddins.
* Check for exact constants before using them, fixing Ruby bug #11940. Pull
  request [#1438](https://github.com/ruby/rubygems/pull/1438) by Nobuyoshi Nakada.
* Fix building C extensions on Ruby 1.9.x on Windows. Pull request [#1453](https://github.com/ruby/rubygems/pull/1453) by Marie
  Markwell.
* Handle symlinks containing ".." correctly. Pull request [#1457](https://github.com/ruby/rubygems/pull/1457) by Samuel E.
  Giddins.

### Enhancements:

* Add `--no-rc` flag, which skips loading `.gemrc`. Pull request [#1329](https://github.com/ruby/rubygems/pull/1329) by Luis
  Sagastume.
* Allow basic auth to be excluded from `allowed_push_host`. By Josh Lane.
* Add `gem list --exact`, which finds gems by string match instead of regex. Pull
  request [#1344](https://github.com/ruby/rubygems/pull/1344) by Luis Sagastume.
* Suggest alternatives when gem license is unknown. Pull request [#1443](https://github.com/ruby/rubygems/pull/1443) by Samuel
  E. Giddins.
* Print a useful error if a binstub expects a newer version of a gem than is
  installed. Pull request [#1407](https://github.com/ruby/rubygems/pull/1407) by Samuel E. Giddins.
* Allow the (supported) s3:// scheme to be used with `--source`. Pull request
  [#1416](https://github.com/ruby/rubygems/pull/1416) by Dave Adams.
* Add `--[no-]post-install-message` to `install` and `update`. Pull request [#1162](https://github.com/ruby/rubygems/pull/1162)
  by Josef Šimánek.
* Add `--host` option to `yank`, providing symmetry with `pull`. Pull request
  [#1361](https://github.com/ruby/rubygems/pull/1361) by Mike Virata-Stone.
* Update bundled Molinillo to 0.4.1. Pull request [#1452](https://github.com/ruby/rubygems/pull/1452) by Samuel E. Giddins.
* Allow calling `build` without '.gemspec'. Pull request [#1454](https://github.com/ruby/rubygems/pull/1454) by Stephen
  Blackstone.
* Add support for `source` option on gems in Gemfile. Pull request [#1355](https://github.com/ruby/rubygems/pull/1355) by
  Michael Papis.
* Function correctly when string literals are frozen on Ruby 2.3. Pull request
  [#1408](https://github.com/ruby/rubygems/pull/1408) by Samuel E. Giddins.

## 2.5.1 / 2015-12-10

### Bug fixes:

* Ensure platform sorting only uses strings. Affected binary installs on Windows.
  Issue #1369 reported by Ryan Atball (among others).
  Pull request [#1375](https://github.com/ruby/rubygems/pull/1375) by Samuel E. Giddins.
* Revert PR #1332. Unable to reproduce, and nil should be impossible.
* Gem::Specification#to_fullpath now returns .rb extensions when such a file
  exists.  Pull request [#1114](https://github.com/ruby/rubygems/pull/1114) by y-yagi.
* RubyGems now handles Net::HTTPFatalError instead of crashing.  Pull
  request [#1314](https://github.com/ruby/rubygems/pull/1314) by Samuel E. Giddins.
* Updated bundled Molinillo to 0.4.0.  Pull request [#1322](https://github.com/ruby/rubygems/pull/1322), #1396 by Samuel E.
  Giddins.
* Improved performance of spec loading by reducing likelihood of loading the
  complete specification.  Pull request [#1373](https://github.com/ruby/rubygems/pull/1373) by Aaron Patterson.
* Improved caching of requirable files  Pull request [#1377](https://github.com/ruby/rubygems/pull/1377) by Aaron Patterson.
* Fixed activation of gems with development dependencies.  Pull request [#1388](https://github.com/ruby/rubygems/pull/1388)
  by Samuel E. Giddins.
* RubyGems now uses the same Molinillo vendoring strategy as Bundler.  Pull
  request [#1397](https://github.com/ruby/rubygems/pull/1397) by Samuel E. Giddins.
* Fixed documentation of Gem::Requirement.parse.  Pull request [#1398](https://github.com/ruby/rubygems/pull/1398) by
  Juanito Fatas.
* RubyGems no longer warns when a prerelease gem has prerelease dependencies.
  Pull request [#1399](https://github.com/ruby/rubygems/pull/1399) by Samuel E. Giddins.
* Fixed Gem::Version documentation example.  Pull request [#1401](https://github.com/ruby/rubygems/pull/1401) by Guilherme
  Goettems Schneider.
* Updated documentation links to https://.  Pull request [#1404](https://github.com/ruby/rubygems/pull/1404) by Suriyaa
  Kudo.
* Fixed double word typo.  Pull request [#1411](https://github.com/ruby/rubygems/pull/1411) by Jake Worth.

## 2.5.0 / 2015-11-03

### Enhancements:

* Added the Gem::Licenses class which provides a set of standard license
  identifiers as set by spdx.org. This is now used by the
  Gem::Specification#license attribute to try to standardize (though not
  enforce) licenses set by gem authors.

  Pull request [#1249](https://github.com/ruby/rubygems/pull/1249) by Kyle Mitchell.

* Use Molinillo as the resolver library.  This is the same resolver as used by
  Bundler.  Pull request [#1189](https://github.com/ruby/rubygems/pull/1189) by Samuel E. Giddins.
* Add `--skip=gem_name` to Pristine command.  Pull request [#1018](https://github.com/ruby/rubygems/pull/1018) by windwiny.
* The parsed gem dependencies file is now available via Gem.gemdeps following
  Gem.use_gemdeps.  Pull request [#1224](https://github.com/ruby/rubygems/pull/1224) by Hsing-Hui Hsu, issue #1213 by
  Michal Papis.
* Moved description attribute to recommended for Gem::Specification.
  Pull request [#1046](https://github.com/ruby/rubygems/pull/1046) by Michal Papis
* Moved `Gem::Indexer#abbreviate` and `#sanitize` to `Gem::Specification`.
  Pull request [#1145](https://github.com/ruby/rubygems/pull/1145) by Arthur Nogueira Neves
* Cache Gem::Version segments for `#bump` and `#release`.
  Pull request [#1131](https://github.com/ruby/rubygems/pull/1131) by Matijs van Zuijlen
* Fix edge case in `levenshtein_distance` for comparing longer strings.
  Pull request [#1173](https://github.com/ruby/rubygems/pull/1173) by Richard Schneeman
* Remove duplication from List#to_a, improving from O(n^2) to O(n) time.
  Pull request [#1200](https://github.com/ruby/rubygems/pull/1200) by Marc Siegel.
* Gem::Specification.add_specs is deprecated and will be removed from version
  3.0 with no replacement.  To add specs, install the gem, then reset the
  cache.
* Gem::Specification.add_spec is deprecated and will be removed from version
  3.0 with no replacement.  To add specs, install the gem, then reset the
  cache.
* Gem::Specification.remove_spec is deprecated and will be removed from version
  3.0 with no replacement.  To remove specs, uninstall the gem, then reset the
  cache by calling Gem::Specification.reset.
* Call Array#compact before calling Array#uniq for minor speed improvement in
  the Gem::Specification#files method.
  Pull request [#1253](https://github.com/ruby/rubygems/pull/1253) by Marat Amerov.
* Use stringio instead of custom String classes.
  Pull request [#1250](https://github.com/ruby/rubygems/pull/1250) by Petr Skocik.
* Use URI#host instead of URI#hostname to retain backwards compatibility with
  Ruby 1.9.2 and earlier in util library.
  Pull request [#1288](https://github.com/ruby/rubygems/pull/1288) by Joe Rafaniello.
* Documentation update for gem sources.
  Pull request [#1324](https://github.com/ruby/rubygems/pull/1324) by Ilya Vassilevsky.
* Documentation update for required_ruby_version.
  Pull request [#1321](https://github.com/ruby/rubygems/pull/1321) by Matt Patterson.
* Documentation update for gem update.
  Pull request [#1306](https://github.com/ruby/rubygems/pull/1306) by Tim Blair.
* Emit a warning on SRV resolve failure.
  Pull request [#1023](https://github.com/ruby/rubygems/pull/1023) by Ivan Kuchin.
* Allow duplicate dependencies between runtime and development.
  Pull request [#1032](https://github.com/ruby/rubygems/pull/1032) by Murray Steele.
* The gem env command now shows the user installation directory.
  Pull request [#1343](https://github.com/ruby/rubygems/pull/1343) by Luis Sagastume.
* The Gem::Platform#=== method now treats a nil cpu arch the same as 'universal'.
  Pull request [#1356](https://github.com/ruby/rubygems/pull/1356) by Daniel Berger.
* Improved memory performance in Gem::Specification.traverse.  Pull request
  [#1188](https://github.com/ruby/rubygems/pull/1188) by Aaron Patterson.
* RubyGems packages now support symlinks.  Pull request [#1209](https://github.com/ruby/rubygems/pull/1209) by Samuel E.
  Giddins.
* RubyGems no longer outputs mkmf.log if it does not exist.  Pull request
  [#1222](https://github.com/ruby/rubygems/pull/1222) by Andrew Hooker.
* Added Bitrig platform.  Pull request [#1233](https://github.com/ruby/rubygems/pull/1233) by John C. Vernaleo.
* Improved error message for first-time RubyGems developers.  Pull request
  [#1241](https://github.com/ruby/rubygems/pull/1241) by André Arko
* Improved performance of Gem::Specification#load with cached specs.  Pull
  request [#1297](https://github.com/ruby/rubygems/pull/1297) by Samuel E. Giddins.
* Gem::RemoteFetcher allows users to set HTTP headers.  Pull request [#1363](https://github.com/ruby/rubygems/pull/1363) by
  Agis Anastasopoulos.

### Bug fixes:

* Fixed Rake homepage url in example for Gem::Specification#homepage.
  Pull request [#1171](https://github.com/ruby/rubygems/pull/1171) by Arthur Nogueira Neves
* Don't crash if partially uninstalled gem can't be found.
  Pull request [#1283](https://github.com/ruby/rubygems/pull/1283) by Cezary Baginski.
* Test warning cleanup.
  Pull request [#1298](https://github.com/ruby/rubygems/pull/1298) by Samuel E. Giddins.
* Documentation fix for GemDependencyAPI.
  Pull request [#1308](https://github.com/ruby/rubygems/pull/1308) by Michael Papis.
* Fetcher now ignores ENOLCK errors in single threaded environments. This
  handles an issue with gem installation on NFS as best we can. Addresses
  issue #1176 by Ryan Moore.
  Pull request [#1327](https://github.com/ruby/rubygems/pull/1327) by Daniel Berger.
* Fix some path quoting issues in the test suite.
  Pull request [#1328](https://github.com/ruby/rubygems/pull/1328) by Gavin Miller.
* Fix NoMethodError in running ruby processes when gems are uninstalled.
  Pull request [#1332](https://github.com/ruby/rubygems/pull/1332) by Peter Drake.
* Fixed a potential NoMethodError for gem cleanup.
  Pull request [#1333](https://github.com/ruby/rubygems/pull/1333) by Peter Drake.
* Fixed gem help bug.
  Issue #1352 reported by bogem, pull request [#1357](https://github.com/ruby/rubygems/pull/1357) by Luis Sagastume.
* Remove temporary directories after tests finish.  Pull request [#1181](https://github.com/ruby/rubygems/pull/1181) by
  Nobuyoshi Nokada.
* Update links in RubyGems documentation.  Pull request [#1185](https://github.com/ruby/rubygems/pull/1185) by Darío Hereñú.
* Prerelease gem executables can now be run.  Pull request [#1186](https://github.com/ruby/rubygems/pull/1186) by Samuel E.
  Giddins.
* Updated RubyGems travis-ci ruby versions.  Pull request [#1187](https://github.com/ruby/rubygems/pull/1187) by Samuel E.
  Giddins.
* Fixed release date of RubyGems 2.4.6.  Pull request [#1190](https://github.com/ruby/rubygems/pull/1190) by Frieder
  Bluemle.
* Fixed bugs in gem activation.  Pull request [#1202](https://github.com/ruby/rubygems/pull/1202) by Miklós Fazekas.
* Fixed documentation for `gem list`.  Pull request [#1228](https://github.com/ruby/rubygems/pull/1228) by Godfrey Chan.
* Fixed #1200 history entry.  Pull request [#1234](https://github.com/ruby/rubygems/pull/1234) by Marc Siegel.
* Fixed synchronization issue when resetting the Gem::Specification gem list.
  Pull request [#1239](https://github.com/ruby/rubygems/pull/1239) by Samuel E. Giddins.
* Fixed running tests in parallel.  Pull request [#1257](https://github.com/ruby/rubygems/pull/1257) by SHIBATA Hiroshi.
* Fixed running tests with `--program-prefix` or `--program-suffix` for ruby.
  Pull request [#1258](https://github.com/ruby/rubygems/pull/1258) by Shane Gibbs.
* Fixed Gem::Specification#to_yaml.  Pull request [#1262](https://github.com/ruby/rubygems/pull/1262) by Hiroaki Izu.
* Fixed taintedness of Gem::Specification#raw_require_paths.  Pull request
  [#1268](https://github.com/ruby/rubygems/pull/1268) by Sam Ruby.
* Fixed sorting of platforms when installing gems.  Pull request [#1271](https://github.com/ruby/rubygems/pull/1271) by
  nonsequitur.
* Use `--no-document` over deprecated documentation options when installing
  dependencies on travis.  Pull request [#1272](https://github.com/ruby/rubygems/pull/1272) by takiy33.
* Improved support for IPv6 addresses in URIs.  Pull request [#1275](https://github.com/ruby/rubygems/pull/1275) by Joe
  Rafaniello.
* Spec validation no longer crashes if a file does not exist.  Pull request
  [#1278](https://github.com/ruby/rubygems/pull/1278) by Samuel E. Giddins.
* Gems can now be installed within `rescue`.  Pull request [#1282](https://github.com/ruby/rubygems/pull/1282) by Samuel E.
  Giddins.
* Increased Diffie-Hellman key size for tests for modern OpenSSL.  Pull
  request [#1290](https://github.com/ruby/rubygems/pull/1290) by Vít Ondruch.
* RubyGems handles invalid config files better.  Pull request [#1367](https://github.com/ruby/rubygems/pull/1367) by Agis
  Anastasopoulos.

## 2.4.8 / 2015-06-08

### Bug fixes:

* Tightened API endpoint checks for CVE-2015-3900

## 2.4.7 / 2015-05-14

### Bug fixes:

* Limit API endpoint to original security domain for CVE-2015-3900.
  Fix by claudijd

## 2.4.6 / 2015-02-05

### Bug fixes:

* Fixed resolving gems with both upper and lower requirement boundaries.
  Issue #1141 by Jakub Jirutka.
* Moved extension directory after require_paths to fix missing constant bugs
  in some gems with C extensions.  Issue #784 by André Arko, pull request
  [#1137](https://github.com/ruby/rubygems/pull/1137) by Barry Allard.
* Use Gem::Dependency#requirement when adding a dependency to an existing
  dependency instance.  Pull request [#1101](https://github.com/ruby/rubygems/pull/1101) by Josh Cheek.
* Fixed warning of shadowed local variable in Gem::Specification.  Pull request
  [#1109](https://github.com/ruby/rubygems/pull/1109) by Rohit Arondekar
* Gem::Requirement should always sort requirements before coercion to Hash.
  Pull request [#1139](https://github.com/ruby/rubygems/pull/1139) by Eito Katagiri.
* The `gem open` command should change the current working directory before
  opening the editor.  Pull request [#1142](https://github.com/ruby/rubygems/pull/1142) by Alex Wood.
* Ensure quotes are stripped from the Windows launcher script used to install
  gems.  Pull request [#1115](https://github.com/ruby/rubygems/pull/1115) by Youngjun Song.
* Fixed errors when writing to NFS to to 0444 files.  Issue #1161 by Emmanuel
  Hadoux.
* Removed dead code in Gem::StreamUI.  Pull request [#1117](https://github.com/ruby/rubygems/pull/1117) by mediaslave24.
* Fixed typos.  Pull request [#1096](https://github.com/ruby/rubygems/pull/1096) by hakeda.
* Relaxed CMake dependency for RHEL 6 and CentOS 6.  Pull request [#1124](https://github.com/ruby/rubygems/pull/1124) by Vít
  Ondruch.
* Relaxed Psych dependency.  Pull request [#1128](https://github.com/ruby/rubygems/pull/1128) by Vít Ondruch.

## 2.4.5 / 2014-12-03

### Bug fixes:

* Improved speed of requiring gems.  (Around 25% for a 60 gem test).  Pull
  request [#1060](https://github.com/ruby/rubygems/pull/1060) by unak.
* RubyGems no longer attempts to look up gems remotely with the --local flag.
  Pull request [#1084](https://github.com/ruby/rubygems/pull/1084) by Jeremy Evans.
* Executable stubs use the correct gem version when RUBYGEMS_GEMDEPS is
  active.  Issue #1072 by Michael Kaiser-Nyman.
* Fixed handling of pinned gems in lockfiles with versions.  Issue #1078 by
  Ian Ker-Seymer.
* Fixed handling of git@example:gem.git URIs.  Issue #1054 by Mogutan Mogu.
* Fixed handling of platforms retrieved from the dependencies API.  Issue
  #1058 and patch suggestion by tux-mind.
* RubyGems now suggests a copy-pasteable `gem pristine` command when
  extensions are missing.  Pull request [#1057](https://github.com/ruby/rubygems/pull/1057) by Shannon Skipper.
* Improved errors for long file names when packaging.  Pull request [#1016](https://github.com/ruby/rubygems/pull/1016) by
  Piotrek Bator.
* `gem pristine` now skips gems cannot be found remotely.  Pull request [#1064](https://github.com/ruby/rubygems/pull/1064)
  by Tuomas Kareinen.
* `gem pristine` now caches gems to the proper directory.  Pull request [#1064](https://github.com/ruby/rubygems/pull/1064)
  by Tuomas Kareinen.
* `gem pristine` now skips bundled gems properly.  Pull request [#1064](https://github.com/ruby/rubygems/pull/1064) by
  Tuomas Kareinen.
* Improved interoperability of Vagrant with RubyGems.  Pull request [#1057](https://github.com/ruby/rubygems/pull/1057) by
  Vít Ondruch.
* Renamed CONTRIBUTING to CONTRIBUTING.rdoc to allow markup.  Pull request
  [#1090](https://github.com/ruby/rubygems/pull/1090) by Roberto Miranda.
* Switched from #partition to #reject as only one collection is used.  Pull
  request [#1074](https://github.com/ruby/rubygems/pull/1074) by Tuomas Kareinen.
* Fixed installation of gems on systems using memory-mapped files.  Pull
  request [#1038](https://github.com/ruby/rubygems/pull/1038) by Justin Li.
* Fixed bug in Gem::Text#min3 where `a == b < c`.  Pull request [#1026](https://github.com/ruby/rubygems/pull/1026) by
  fortissimo1997.
* Fixed uninitialized variable warning in BasicSpecification.  Pull request
  [#1019](https://github.com/ruby/rubygems/pull/1019) by Piotr Szotkowski.
* Removed unneeded exception handling for cyclic dependencies.  Pull request
  [#1043](https://github.com/ruby/rubygems/pull/1043) by Jens Wille.
* Fixed grouped expression warning.  Pull request [#1081](https://github.com/ruby/rubygems/pull/1081) by André Arko.
* Fixed handling of platforms when writing lockfiles.

## 2.4.4 / 2014-11-12

### Bug fixes:

* Add alternate Root CA for upcoming certificate change. Fixes #1050 by
  Protosac

## 2.4.3 / 2014-11-10

### Bug fixes:

* Fix redefine MirrorCommand issue. Pull request [#1044](https://github.com/ruby/rubygems/pull/1044) by @akr.
* Fix typo in platform= docs.  Pull request [#1048](https://github.com/ruby/rubygems/pull/1048) by @jasonrclark
* Add root SSL certificates for upcoming certificate change.  Fixes #1050 by
  Protosac

## 2.4.2 / 2014-10-01

This release was sponsored by Ruby Central.

### Bug fixes:

* RubyGems now correctly matches wildcard no_proxy hosts.  Issue #997 by
  voelzemo.
* Added support for missing git_source method in the gem dependencies API.
* Fixed handling of git gems with an alternate install directory.
* Lockfiles will no longer be truncated upon resolution errors.
* Fixed messaging for `gem owner -a`.  Issue #1004 by Aaron Patterson, Ryan
  Davis.
* Removed meaningless ensure.  Pull request [#1003](https://github.com/ruby/rubygems/pull/1003) by gogotanaka.
* Improved wording of --source option help.  Pull request [#989](https://github.com/ruby/rubygems/pull/989) by Jason Clark.
* Empty build_info files are now ignored.  Issue #903 by Adan Alvarado.
* Gem::Installer ignores dependency checks when installing development
  dependencies.  Issue #994 by Jens Willie.
* `gem update` now continues after dependency errors.  Issue #993 by aaronchi.
* RubyGems no longer warns about semantic version dependencies for the 0.x
  range.  Issue #987 by Jeff Felchner, pull request [#1006](https://github.com/ruby/rubygems/pull/1006) by Hsing-Hui Hsu.
* Added minimal lock to allow multithread installation of gems.  Issue #982
  and pull request [#1005](https://github.com/ruby/rubygems/pull/1005) by Yorick Peterse
* RubyGems now considers prerelease dependencies as it did in earlier versions
  when --prerelease is given.  Issue #990 by Jeremy Tryba.
* Updated capitalization in README.  Issue #1010 by Ben Bodenmiller.
* Fixed activating gems from a Gemfile for default gems.  Issue #991 by khoan.
* Fixed windows stub script generation for Cygwin.  Issue #1000 by Brett
  DiFrischia.
* Allow gem bindir and ruby.exe to live in separate directories.  Pull request
  [#942](https://github.com/ruby/rubygems/pull/942) by Ian Flynn.
* Fixed handling of gemspec in gem dependencies files to match Bundler
  behavior.  Issue #1020 by Michal Papis.
* Fixed `gem update` when updating to prereleases.  Issue #1028 by Santiago
  Pastorino.
* RubyGems now fails immediately when a git reference cannot be found instead
  of spewing git errors.  Issue #1031 by Michal Papis

## 2.4.1 / 2014-07-17

### Bug fixes:

* RubyGems can now be updated on Ruby implementations that do not support
  vendordir in RbConfig::CONFIG.  Issue #974 by net1957.

## 2.4.0 / 2014-07-16

### Enhancements:

* The contents command now supports a --show-install-dir option that shows
  only the directory the gem is installed in.  Feature request [#966](https://github.com/ruby/rubygems/pull/966) by Akinori
  MUSHA.
* Added a --build-root option to the install command for packagers.  Pull
  request [#965](https://github.com/ruby/rubygems/pull/965) by Marcus Rückert.
* Added vendor gem support to RubyGems.  Package managers may now install gems
  in Gem.vendor_dir with the --vendor option to gem install.  Issue #943 by
  Marcus Rückert.

### Bug fixes:

* Kernel#gem now respects the prerelease flag when activating gems.
  Previously this behavior was undefined which could lead to bugs when a
  prerelease version was unintentionally activated.  Bug #938 by Joe Ferris.
* RubyGems now prefers gems from git over installed gems.  This allows gems
  from git to override an installed gem with the same name and version.  Bug
  #944 by Thomas Kriechbaumer.
* Fixed handling of git gems in a lockfile with unversioned dependencies.  Bug
  #940 by Michael Kaiser-Nyman.
* The ruby directive in a gem dependencies file is ignored when installing.
  Bug #941 by Michael Kaiser-Nyman.
* Added open to list of builtin commands (`gem open` now works).  Reported by
  Espen Antonsen.
* `gem open` now works with command-line editors.  Pull request [#962](https://github.com/ruby/rubygems/pull/962) by Tim
  Pope.
* `gem install -g` now respects `--conservative`.  Pull request [#950](https://github.com/ruby/rubygems/pull/950) by Jeremy
  Evans.
* RubyGems releases announcements now now include checksums.  Bug #939 by
  Alexander E. Fischer.
* RubyGems now expands ~ in $PATH when checking if installed executables will
  be runnable.  Pull request [#945](https://github.com/ruby/rubygems/pull/945) by Alex Talker.
* Fixed `gem install -g --explain`.  Issue #947 by Luis Lavena.  Patch by
  Hsing-Hui Hsu.
* RubyGems locks less during gem activation.  Pull request [#951](https://github.com/ruby/rubygems/pull/951) by Aaron
  Patterson and Justin Searls, #969 by Jeremy Tryba.
* Kernel#gem is now thread-safe.  Pull request [#967](https://github.com/ruby/rubygems/pull/967) by Aaron Patterson.
* RubyGems now handles spaces in directory names for some parts of extension
  building.  Pull request [#949](https://github.com/ruby/rubygems/pull/949) by Tristan Hill.
* RubyGems no longer defines an empty Date class.  Pull Request #948 by Benoit
  Daloze.
* RubyGems respects --document options for `gem update` again.  Bug 946 by
  jonforums.  Patch by Hsing-Hui Hsu.
* RubyGems generates documentation again with --ignore-dependencies.  Bug #961
  by Pulfer.
* RubyGems can install extensions across partitions now.  Pull request [#970](https://github.com/ruby/rubygems/pull/970) by
  Michael Scherer.
* `-s` is now short for `--source` which resolves an ambiguity with
  --no-suggestions.  Pull request [#955](https://github.com/ruby/rubygems/pull/955) by Alexander Kahn.
* Added extra test for ~> for 0.0.X versions.  Pull request [#958](https://github.com/ruby/rubygems/pull/958) by Mark
  Lorenz.
* Fixed typo in gem updated help.  Pull request [#952](https://github.com/ruby/rubygems/pull/952) by Per Modin.
* Clarified that the gem description should not be excessively long.  Part of
  bug #956 by Renier Morales.
* Hid documentation of outdated test_files related methods in Specification.
  Guides issue #90 by Emil Soman.
* RubyGems now falls back to the old index if the rubygems.org API fails
  during gem resolution.


## 2.3.0 / 2014-06-10

### Enhancements:

* Added the `open` command which allows you to inspect the source of a gem
  using your editor.
  Issue #789 by Mike Perham. Pull request [#804](https://github.com/ruby/rubygems/pull/804) by Vitali F.
* The `update` command shows a summary of which gems were and were not
  updated.  Issue #544 by Mark D. Blackwell.
  Pull request [#777](https://github.com/ruby/rubygems/pull/777) by Tejas Bubane.
* Improved "could not find 'gem'" error reporting.  Pull request [#913](https://github.com/ruby/rubygems/pull/913) by
  Richard Schneeman.
* Gem.use_gemdeps now accepts an argument specifying the path of the gem
  dependencies file.  When the file is not found an ArgumentError is raised.
* Writing a .lock file for a gem dependencies file is now controlled by the
  --[no-]lock option.  Pull request [#774](https://github.com/ruby/rubygems/pull/774) by Jeremy Evans.
* Suggestion of alternate names and spelling corrections during install can be
  suppressed with the --no-suggestions option.  Issue #867 by Jimmy Cuadra.
* Added mswin64 support.  Pull request [#881](https://github.com/ruby/rubygems/pull/881) by U. Nakamura.
* A gem is installable from an IO again (as in RubyGems 1.8.x and older).
  Pull request [#716](https://github.com/ruby/rubygems/pull/716) by Xavier Shay.
* RubyGems no longer attempts to build extensions during activation.  Instead
  a warning is issued instructing you to run `gem pristine` which will build
  the extensions for the current platform.  Issue #796 by dunric.
* Added Gem::UserInteraction#verbose which prints when the --verbose option is
  given.  Pull request [#811](https://github.com/ruby/rubygems/pull/811) by Aaron Patterson.
* RubyGems can now fetch gems from private repositories using S3.  Pull
  request [#856](https://github.com/ruby/rubygems/pull/856) by Brian Palmer.
* Added Gem::ConflictError subclass of Gem::LoadError so you can distinguish
  conflicts from other problems.  Pull request [#841](https://github.com/ruby/rubygems/pull/841) by Aaron Patterson.
* Cleaned up unneeded load_yaml bootstrapping in Rakefile.  Pull request [#815](https://github.com/ruby/rubygems/pull/815)
  by Zachary Scott.
* Improved performance of conflict resolution.  Pull request [#842](https://github.com/ruby/rubygems/pull/842) by Aaron
  Patterson.
* Add documentation of "~> 0" to Gem::Version.  Issue #896 by Aaron Suggs.
* Added CONTRIBUTING file.  Pull request [#849](https://github.com/ruby/rubygems/pull/849) by Mark Turner.
* Allow use of bindir in windows_stub_script in .bat
  Pull request [#818](https://github.com/ruby/rubygems/pull/818) by @unak and @nobu
* Use native File::PATH_SEPARATOR and remove $ before gem env on
  Gem::Dependency#to_specs. Pull request [#915](https://github.com/ruby/rubygems/pull/915) by @parkr
* RubyGems recommends SPDX IDs for licenses now.  Pull request [#917](https://github.com/ruby/rubygems/pull/917) by
  Benjamin Fleischer.

### Bug fixes:

* RubyGems now only fetches the latest specs to find misspellings which speeds
  up gem suggestions.  Pull request [#808](https://github.com/ruby/rubygems/pull/808) by Aaron Patterson.
* The given .gem is installed again when multiple versions of the same gem
  exist in the current directory.  Bug #875 by Prem Sichanugrist.
* Local gems are preferred by name over remote gems again.  Bug #834 by
  jonforums.
* RubyGems can install local prerelease gems again.  Pull request [#866](https://github.com/ruby/rubygems/pull/866) by
  Aaron Patterson.  Issue #813 by André Arko.
* RubyGems installs development dependencies correctly again.  Issue #893 by
  Jens Wille.
* RubyGems only installs prerelease versions when they are requested again.
  Issue #853 by Seth Vargo, special thanks to Zachary Scott and Ben Moss.
  Issue #884 by Nathaniel Bibler.
* Fixed RubyGems list and search command help.  Pull request [#905](https://github.com/ruby/rubygems/pull/905) and #928 by
  Gabriel Gilder.
* The list of gems to uninstall is always sorted now.  Bug #918 by postmodern.
* The update command only updates exactly matching gem names now.  Bug #919 by
  postmodern.
* Gem::Server now supports prerelease versions.  Bug #857 by Marcelo Alvim.
* RubyGems no longer raises an exception immediately when gems are missing
  with RUBYGEMS_GEMDEPS.  A warning is printed instead.  Issue #886 by Michael
  Kaiser-Nyman.
* Commands using the rubygems.org API no longer try to sign-in when a
  non-rubygems API key has been chosen.  Bug #826 by Ben Sedat.
* Updated documentation of Gem::Specification#executables to indicate that
  only ruby scripts are allowed.  Bug #830 by Geoff Nixon.
* Gem dependency API supports multiple platforms for #platform and #platforms
  now.  Bug #821 by johnny5-.
* Gem dependency API supports lockfiles without explicit sources.  Bug #820 by
  johnny5-.
* Gem dependency API supports lockfiles with multiple sources.  Bug #822 by
  johnny5-, bug #851 by sumit shah.
* Gem dependency API supports lockfiles with git sources using branch, tag and
  ref.  Bug #822 by johnny5-, #931 by Christoph Blank.
* Gem dependency API no longer raises an exception when a gem does not exist
  in one of the configured sources.  Bug #897 by Michael Kaiser-Nyman.
* Gem dependency API no longer lists development dependencies in the lockfile.
  Bug #768 by Diego Viola, #916 by Santiago Pastorino.
* SSL configuration entries in ~/.gemrc are properly round-tripped.  Bug #837
  by Noah Luck Easterly.
* The environment command now shows the system configuration directory where
  the all-users gemrc lives.  Bug #827 by Ben Langfeld.
* Improved speed of conflict checking when activating gems.  Pull request [#843](https://github.com/ruby/rubygems/pull/843)
  by Aaron Patterson.
* Improved speed of levenshtein distance for gem suggestion misspellings.
  Pull requests #809, #812 by Aaron Patterson.
* Restored persistent connections.  Pull request [#869](https://github.com/ruby/rubygems/pull/869) by Aaron Patterson.
* Reduced requests when fetching gems with the bundler API.  Pull request [#773](https://github.com/ruby/rubygems/pull/773)
  by Charlie Somerville.
* Reduced dependency prefetching to improve install speed.  Pull requests
  #871, #872 by Matthew Draper.
* RubyGems now avoids net/http auto-proxy detection.  Issue #824 by HINOHARA
  Hiroshi.
* Removed conversion of Gem::List (used for debugging installs) to unless
  necessary.  Pull request [#870](https://github.com/ruby/rubygems/pull/870) by Aaron Patterson.
* RubyGems now prints release notes from the current release.  Bug #814 by
  André Arko.
* RubyGems allows installation of unsigned gems again with -P MediumSecurity
  and lower.  Bug #859 by Justin S. Collins.
* Fixed typo in Jim Weirich's name.  Ruby pull request [#577](https://github.com/ruby/rubygems/pull/577) by Mo Khan.
* Fixed typo in Gem.datadir documentation.  Pull request [#868](https://github.com/ruby/rubygems/pull/868) by Patrick
  Jones.
* Fixed File.exists? warnings.  Pull request [#829](https://github.com/ruby/rubygems/pull/829) by SHIBATA Hiroshi.
* Fixed show_release_notes test for LANG=C.  Issue #862 by Luis Lavena.
* Fixed Gem::Package from IO tests on windows.  Patch from issue #861 by Luis
  Lavena.
* Check for nil extensions as BasicSpecification does not initialize them.
  Pull request [#882](https://github.com/ruby/rubygems/pull/882) by André Arko.
* Fixed Gem::BasicSpecification#require_paths receives a String for
  @require_paths. Pull request [#904](https://github.com/ruby/rubygems/pull/904) by @danielpclark
* Fixed circular require warnings.  Bug #908 by Zachary Scott.
* Gem::Specification#require_paths can no longer accidentally be an Array.
  Pull requests #904, #909 by Daniel P. Clark.
* Don't build extensions if `build_dir/extensions` isn't writable.
  Pull request [#912](https://github.com/ruby/rubygems/pull/912) by @dunric
* Gem::BasicSpecification#require_paths respects default_ext_dir_for now.  Bug
  #852 by Vít Ondruch.

## 2.2.5 / 2015-06-08

### Bug fixes:

* Tightened API endpoint checks for CVE-2015-3900

## 2.2.4 / 2015-05-14

### Bug fixes:

* Backport: Limit API endpoint to original security domain for CVE-2015-3900.
  Fix by claudijd

## 2.2.3 / 2014-12-21

### Bug fixes:

* Backport: Add alternate Root CA for upcoming certificate change.
  Fixes #1050 by Protosac

## 2.2.2 / 2014-02-05

### Bug fixes:

* Fixed ruby tests when BASERUBY is not set.  Patch for #778 by Nobuyoshi
  Nakada.
* Removed double requests in RemoteFetcher#cache_update_path to improve remote
  install speed.  Pull request [#772](https://github.com/ruby/rubygems/pull/772) by Charlie Somerville.
* The mkmf.log is now placed next to gem_make.out when building extensions.
* `gem install -g --local` no longer accesses the network.  Bug #776 by Jeremy
  Evans.
* RubyGems now correctly handles URL passwords with encoded characters.  Pull
  request [#781](https://github.com/ruby/rubygems/pull/781) by Brian Fletcher.
* RubyGems now correctly escapes URL characters.  Pull request [#788](https://github.com/ruby/rubygems/pull/788) by Brian
  Fletcher.
* RubyGems can now unpack tar files where the type flag is not given.  Pull
  request [#790](https://github.com/ruby/rubygems/pull/790) by Cody Russell.
* Typo corrections.  Pull request ruby/ruby#506 by windwiny.
* RubyGems now uses both the default certificates and ssl_ca_cert instead of
  one or the other.  Pull request [#795](https://github.com/ruby/rubygems/pull/795) by zebardy.
* RubyGems can now use the bundler API against hosted gem servers in a
  directory.  Pull request [#801](https://github.com/ruby/rubygems/pull/801) by Brian Fletcher.
* RubyGems bin stubs now ignore non-versions.  This allows RubyGems bin stubs
  to list file names like "_foo_".  Issue #799 by Postmodern.
* Restored behavior of Gem::Version::new when subclassed.  Issue #805 by
  Sergio Rubio.

## 2.2.1 / 2014-01-06

### Bug fixes:

* Platforms in the Gemfile.lock GEM section are now handled correctly.  Bug
  #767 by Diego Viola.
* RubyGems now displays which gem couldn't be uninstalled from the home
  directory.  Pull request [#757](https://github.com/ruby/rubygems/pull/757) by Michal Papis.
* Removed unused method Gem::Resolver#find_conflict_state.  Pull request [#759](https://github.com/ruby/rubygems/pull/759)
  by Smit Shah.
* Fixed installing gems from local files without dependencies.  Issue #760 by
  Arash Mousavi, pull request [#764](https://github.com/ruby/rubygems/pull/764) by Tim Moore.
* Removed TODO about syntax that works in Ruby 1.8.7.  Pull request [#765](https://github.com/ruby/rubygems/pull/765) by
  Benjamin Fleischer.
* Switched Gem.ruby_api_version to use RbConfig::CONFIG['ruby_version'] which
  has the same value but is overridable by packagers through
  --with-ruby-version= when configuring ruby.  Bug #770 by Jeremy Evans.
* RubyGems now prefers the bundler API for `gem install` to reduce HTTP
  requests.  (This change was intended for RubyGems 2.2.0 but was missed.)
  This should address bug #762 by Dan Peterson and bug #766 by mipearson.
* Added Gem::BasicSpecification#source_paths so documentation or analysis
  tools can work properly as require_paths no longer returns extension source
  directories.  Bug #758 Vít Ondruch.
* Gem.read_binary can read read-only files again.  This caused file://
  repositories to stop working.  Bug #761 by John Anderson.
* Fixed specification file sorting for Ruby 1.8.7 compatibility.  Pull
  request [#763](https://github.com/ruby/rubygems/pull/763) by James Mead

## 2.2.0 / 2013-12-26

Special thanks to Vít Ondruch and Michal Papis for testing and finding bugs in
RubyGems as it was prepared for the 2.2.0 release.

### Enhancements:

* RubyGems can check for gem dependencies files (gem.deps.rb or Gemfile) when
  rubygems executables are started and uses the found dependencies.  This
  means `rake` will work similar to `bundle exec rake`.  To enable this set
  the `RUBYGEMS_GEMDEPS` environment variable to the location of your
  dependencies file.

  See Gem::use_gemdeps for further details.

* A RubyGems directory may now be shared amongst multiple ruby versions.  Upon
  activation RubyGems will automatically compile missing extensions for the
  current platform when the built objects are missing.  Issue #596 by Michal
  Papis

  By default different platforms do not share gem install locations so this
  must be configured by setting GEM_HOME to a common directory.  Some gems use
  fixed paths for requiring extensions and are not compatible with sharing gem
  directories.

  The default sharing location may be configured by RubyGems packagers through
  Gem.default_ext_dir_for.  Pull Request #744 by Vít Ondruch.

* RubyGems checks the 'allowed_push_host' metadata value when pushing a gem to
  prevent an accidental push to a public repository (such as rubygems.org).
  If you have private gems you should set this value in your gem specification
  metadata.  Pull request [#603](https://github.com/ruby/rubygems/pull/603) by Seamus Abshere.
* `gem list` now shows results for multiple arguments.  Pull request [#604](https://github.com/ruby/rubygems/pull/604) by
  Zach Rabinovich.
* `gem pristine --extensions` will restore only gems with extensions.  Issue
  #619 by Postmodern.
* Gem::Specification#files is now sorted.  Pull request [#612](https://github.com/ruby/rubygems/pull/612) by Justin George.
* For `gem list` and friends, "LOCAL" and "REMOTE" headers are omitted if
  only local or remote gem information is requested with --quiet.  Pull
  request [#615](https://github.com/ruby/rubygems/pull/615) by Michal Papis.
* Added Gem::Specification#full_require_paths which is like require_paths, but
  returns a fully-qualified results.  Pull request [#632](https://github.com/ruby/rubygems/pull/632) by Vít Ondruch.
* RubyGems now looks for the https_proxy environment variable for https://
  sources.  RubyGems will fall back to http_proxy if there is no https_proxy.
  Issue #610 by mkristian.
* RubyGems now creates directories in .gem files.  Issue #631 by marksolaris.
* RubyGems raises an exception when a specification includes its gem.  Issue
  #623 by notEthan.
* RubyGems now displays relevant release note information when updating
  RubyGems.  Issue #647 by Trevor Wennblom.
* Deprecated Gem::Installer::ExtensionBuildError in favor of
  Gem::Ext::BuildError.  The old constant is an alias for the new constant.
* When extensions are built the gem_make.out file is always written now, even
  on success.  This will help with debugging bad builds that report success.
* If a specification fails to validate RubyGems shows a link to the
  specification reference guide.  Issue #656 by Markus Heiler.
* When using `gem install -g`, RubyGems now detects the presence of an
  Isolate, Gemfile or gem.deps.rb file.
* Added Gem::StubSpecification#stubbed? to help determine if a user should run
  `gem pristine` to speed up gem loading.  Pull request [#694](https://github.com/ruby/rubygems/pull/694) and #701 by Jon
  Leighton.
* RubyGems now warns when a gem has a pessimistic version dependency that may
  be too strict.
* RubyGems now warns when a gem has an open-ended dependency.
* RubyGems now raises an exception when a dependency for a gem is defined
  twice.
* Marked the license specification attribute as recommended.  Pull request
  [#713](https://github.com/ruby/rubygems/pull/713) by Benjamin Fleischer.
* RubyGems uses io/console instead of `stty` when available.  Pull request
  [#740](https://github.com/ruby/rubygems/pull/740) by Nobuyoshi Nakada
* Relaxed Gem.ruby tests for platforms that override where ruby lives.  Pull
  Request #755 by strzibny.

### Bug fixes:

* RubyGems now returns an error status when any file given to `gem which`
  cannot be found.  Ruby bug #9004 by Eugene Vilensky.
* Fixed command escaping when building rake extensions.  Pull request [#721](https://github.com/ruby/rubygems/pull/721) by
  Dmitry Ratnikov.
* Fixed uninstallation of gems when GEM_HOME is a relative directory.  Issue
  #708 by Ryan Davis.
* Default gems are now ignored by Gem::Validator#alien.  Issue #717 by David
  Bahar.
* Fixed typos in RubyGems.  Pull requests #723, #725, #731 by Akira Matsuda,
  pull request [#736](https://github.com/ruby/rubygems/pull/736) by Leo Gallucci, pull request [#746](https://github.com/ruby/rubygems/pull/746) by DV Suresh.
* RubyGems now holds exclusive locks on cached gem files to prevent incorrect
  updates.  Pull Request #737 by Smit Shah
* Improved speed of `gem install --ignore-dependencies`.  Patch by Terence
  Lee.

## 2.1.11 / 2013-11-12

### Bug fixes:

* Gem::Specification::remove_spec no longer checks for existence of the spec
  to be removed.  Issue #698 by Tiago Macedo.
* Restored wildcard handling when installing gems.  Issue #697 by Chuck Remes.
* Added DigiCert High Assurance EV Root CA certificate for the cloudfront.net
  certificate change.
* The Gem::RemoteFetcher tests now choose the test server port more reliably.
  Pull Request #706 by akr.

## 2.1.10 / 2013-10-24

### Bug fixes:

* Use class check instead of :version method check when creating Gem::Version
  objects.  Fixes #674 by jkanywhere.
* Fail during `gem update` when an error occurs checking for newer versions.
  This means RubyGems no longer reports "nothing to update" when it cannot
  communicate with the server.  Issue #688 by Jimmy Dee.
* Allow installation of gems when the home directory does not exist.  Issue
  #689 by Laurence Rowe
* Fix updating gems which have multiple platforms.  Issue #693 by Ookami
  Kenrou.
* The gem server now uses user-provided directories.  Issue #696 by Marcelo
  Alvim.
* Improved resolution of gems when specific versions have conflicting
  dependencies.
* RubyGems installs local gems regardless of platform again.  Issue #695
* The --ignore-dependencies option for gem installation works again.  Issue
  #695

## 2.1.9 / 2013-10-14

### Bug fixes:

* Reduce sorting when fetching specifications.  This speeds up the update and
  outdated commands, and others.  Issue #657 by windwiny.
* Proxy usernames and passwords are now escaped properly.  Ruby Bug #8979 by
  Masahiro Tomita, Issue #668 by Kouhei Sutou.

## 2.1.8 / 2013-10-10

### Bug fixes:

* Fixed local installation of platform gem files.  Issue #664 by Ryan Melton.
* Files starting with "." in the root directory are installed again.  Issue
  #680 by Ivo Wever, Pull Request #681 by Jeremy Evans.
* The index generator no longer indexes default gems.  Issue #661 by
  Jeremy Hinegardner.

## 2.1.7 / 2013-10-09

### Bug fixes:

* `gem sources --list` now displays a list of sources.  Pull request [#672](https://github.com/ruby/rubygems/pull/672) by
  Nathan Marley.
* RubyGems no longer alters Gem::Specification.dirs when installing.  Pull
  Request #670 by Vít Ondruch
* Use RFC 2616-compatible time in HTTP headers.  Pull request [#655](https://github.com/ruby/rubygems/pull/655) by Larry
  Marburger.
* RubyGems now gives a more descriptive message for missing licenses on
  validation.  Issue #656 by Markus Heiler.
* Expand unpack destination directory.  This fixes problems when File.realpath
  is missing and $GEM_HOME contains "..".  Issue #679 by Charles Nutter.

## 2.1.6 / 2013-10-08

### Bug fixes:

* Added certificates to follow the s3.amazonaws.com certificate change.  Fixes
  #665 by emeyekayee.  Fixes #671 by jonforums.
* Remove redundant built-in certificates not needed for https://rubygems.org
  Fixes #654 by Vít Ondruch.
* Added test for missing certificates for https://s3.amazonaws.com or
  https://rubygems.org.  Pull request [#673](https://github.com/ruby/rubygems/pull/673) by Hannes Georg.
* RubyGems now allows a Pathname for Kernel#require like the built-in
  Kernel#require.  Pull request [#663](https://github.com/ruby/rubygems/pull/663) by Aaron Patterson.
* Required rbconfig in Gem::ConfigFile for Ruby 1.9.1 compatibility.  (Ruby
  1.9.1 is no longer receiving security fixes, so please update to a newer
  version.)  Issue #676 by Michal Papis.  Issue wayneeseguin/rvm#2262 by
  Thomas Sänger.

## 2.1.5 / 2013-09-24

Security fixes:

* RubyGems 2.1.4 and earlier are vulnerable to excessive CPU usage due to a
  backtracking in Gem::Version validation.  See CVE-2013-4363 for full details
  including vulnerable APIs.  Fixed versions include 2.1.5, 2.0.10, 1.8.27 and
  1.8.23.2 (for Ruby 1.9.3).

## 2.1.4 / 2013-09-17

### Bug fixes:

* `gem uninstall foo --all` now force-uninstalls all versions of foo.  Issue
  #650 by Kyle (remkade).
* Fixed uninstalling gems installed in the home directory (as in
  `--user-install`).  Issue #653 by Lin Jen-Shin.

## 2.1.3 / 2013-09-12

### Bug fixes:

* Gems with files entries starting with "./" no longer install 0 files.  Issue
  #644 by Darragh Curran, #645 by Brandon Turner, #646 by Alex Tambellini

## 2.1.2 / 2013-09-11

### Bug fixes:

* Restore concurrent requires following the fix for ruby bug #8374.  Pull
  request [#637](https://github.com/ruby/rubygems/pull/637) and issue #640 by Charles Nutter.
* Gems with extensions are now installed correctly when the --install-dir
  option is used.  Issue #642 by Lin Jen-Shin.
* Gem fetch now fetches the newest (not oldest) gem when --version is given.
  Issue #643 by Brian Shirai.

## 2.1.1 / 2013-09-10

### Bug fixes:

* Only matching gems matching your local platform are considered for
  installation.  Issue #638 by José M. Prieto, issue #639 by sawanoboly.

## 2.1.0 / 2013-09-09

Security fixes:

* RubyGems 2.0.7 and earlier are vulnerable to excessive CPU usage due to a
  backtracking in Gem::Version validation.  See CVE-2013-4287 for full details
  including vulnerable APIs.  Fixed versions include 2.0.8, 1.8.26 and
  1.8.23.1 (for Ruby 1.9.3).  Issue #626 by Damir Sharipov.

### Enhancements:

* RubyGems uses a new dependency resolver for gem installation which works
  similar to the bundler resolver.  The new resolver can resolve conflicts the
  previous resolver could not and offers improved diagnostics when conflicts
  are discovered.

* RubyGems now has improved platform matching for the ARM architecture.  Gems
  built with a CPU of "arm" will match any specific ARM CPU.  See `gem help
  platform` for further details.  Fixes #532 by Kim Burgestrand.
* The --version option now accepts compound requirements the same as in a gem
  dependency.  The following invocation will install rails between 4.0.0.beta
  and 4.2:

    gem install rails -v '>= 4.0.0.beta, < 4.2'

  Fixes #531 by Gary S. Weaver
* `gem clean` now allows `-n` as an alias for `--dryrun`.  Pull Request #517
  by Gastón Ramos
* Added `gem update --system` to `gem help`.  Pull Request #514 by Vince
  Wadhwani
* Added PATH to `gem env` output.  Pull Request #490 by Michal Papis
* Added --host option to `gem owner` to match other commands using the
  gemcutter API.  Pull Request #462 and issue #461 by Hugo Lopes Tavares
* Added --abort-on-dependent to `gem uninstall`.  This will abort instead of
  asking to uninstall a gem that is depended upon by another gem.  Pull
  request [#549](https://github.com/ruby/rubygems/pull/549) by Philip Arndt.
* RubyGems no longer alters Gem::Specification.dirs when installing.  Based on
  Pull Request #452 by Vít Ondruch
* RubyGems uses ENV['MAKE'] or ENV['make'] over rbconfig.rb's make if present.
  Pull Request #443 by Erik Hollensbe
* RubyGems can now save remote source cache files in an alternate directory
  controlled by `ENV["GEM_SPEC_CACHE"]`.  Pull Request #489 by Michal Papis
* Generated private keys are now encrypted.  Pull Request #453 by pietro
* Separated Gem::Request from Gem::RemoteFetcher.  Pull Request #283 by Steve
  Klabnik.
* RubyGems indicates when a .gem's content is corrupt while verifying.  Bug
  #519 by William T Nelson.
* Refactored common installer setup.  Pull request [#520](https://github.com/ruby/rubygems/pull/520) by Gastón Ramos
* Moved activation tests to Gem::Specification.  Pull request [#521](https://github.com/ruby/rubygems/pull/521) by Gastón
  Ramos
* When a --version option with a prerelease version is given RubyGems
  automatically enables prerelease versions but only the last version is
  used.  If the first version is a prerelease version this is no longer sticky
  unless an explicit --[no-]prerelease was also given.  Fixes part of #531.
* RubyGems now supports an SSL client certificate.  Pull request [#550](https://github.com/ruby/rubygems/pull/550) by
  Robert Kenny.
* RubyGems now suggests how to fix permission errors.  Pull request [#553](https://github.com/ruby/rubygems/pull/553) by
  Odin Dutton.
* Added support for installing a gem as default gems for alternate ruby
  implementations.  Pull request [#566](https://github.com/ruby/rubygems/pull/566) by Charles Nutter.
* Improved performance of Gem::Specification#load by caching the loaded
  gemspec.  Pull request [#569](https://github.com/ruby/rubygems/pull/569) by Charlie Somerville.
* RubyGems now warns when an unsigned gem is verified if -P was given during
  installation even if the security policy allows unsigned gems and warns when
  an untrusted certificate is seen even if the security policy allows
  untrusted certificates.  Issue #474 by Grant Olson
* RubyGems can now rewrite executables with or without a shebang of
  /usr/bin/env via <code>gem pristine --all --only-executables
  --env-[no-]shebang</code>.  Issue #579 by Paul Annesley.
* RubyGems can now run its tests without OpenSSL.  Ruby Bug #8557 by nobu.
* Improved performance by caching Gem::Version objects and avoiding
  method_missing in Gem::Specification.  Pull request [#447](https://github.com/ruby/rubygems/pull/447) by Jon Leighton.
* Files in a .gem now preserve their modification times.  Pull request [#582](https://github.com/ruby/rubygems/pull/582) by
  Jesse Bowes
* Improved speed of looking up dependencies in SpecFetcher through
  Array#bsearch (when present).  Pull request [#595](https://github.com/ruby/rubygems/pull/595) by Andras Suller
* Added `--all` option to `gem uninstall` which removes all gems in GEM_HOME.
  Pull request [#584](https://github.com/ruby/rubygems/pull/584) by Shannon Skipper.
* Added Gem.find_latest_files which is equivalent to Gem.find_files but only
  returns matching files from the latest version of each gem.  Issue #186 by
  Ryan Davis.
* Improved performance of `gem outdated` by reducing duplicate work (it is
  still slow, but I see a near 50% improvement for 250 gems on a fast
  connection).  See also Gem::Specification::outdated_and_latest_version

### Bug fixes:

* rubygems_plugin.rb files are now only loaded from the latest installed gem.
* Fixed Gem.clear_paths when Security is defined at top-level.  Pull request
  [#625](https://github.com/ruby/rubygems/pull/625) by elarkin
* Fixed credential creation for `gem push` when `--host` is not given.  Pull
  request [#622](https://github.com/ruby/rubygems/pull/622) by Arthur Nogueira Neves

## 2.0.17 / 2015-06-08

### Bug fixes:

* Tightened API endpoint checks for CVE-2015-3900

## 2.0.16 / 2015-05-14

### Bug fixes:

* Backport: Limit API endpoint to original security domain for CVE-2015-3900.
  Fix by claudijd

## 2.0.15 / 2014-12-21

### Bug fixes:

* Backport: Add alternate Root CA for upcoming certificate change.
  Fixes #1050 by Protosac

## 2.0.14 / 2013-11-12

### Bug fixes:

* Gem::Specification::remove_spec no longer checks for existence of the spec
  to be removed.  Issue #698 by Tiago Macedo.
* Restored wildcard handling when installing gems.  Issue #697 by Chuck Remes.
* Added DigiCert High Assurance EV Root CA certificate for the cloudfront.net
  certificate change.
* The Gem::RemoteFetcher tests now choose the test server port more reliably.
  Pull Request #706 by akr.

## 2.0.13 / 2013-10-24

### Bug fixes:

* Use class check instead of :version method check when creating Gem::Version
  objects.  Fixes #674 by jkanywhere.
* Allow installation of gems when the home directory does not exist.  Issue
  #689 by Laurence Rowe
* Fix updating gems which have multiple platforms.  Issue #693 by Ookami
  Kenrou.

## 2.0.12 / 2013-10-14

### Bug fixes:

* Proxy usernames and passwords are now escaped properly.  Ruby Bug #8979 by
  Masahiro Tomita, Issue #668 by Kouhei Sutou.

## 2.0.11 / 2013-10-08

### Bug fixes:

* Added certificates to follow the s3.amazonaws.com certificate change.  Fixes
  #665 by emeyekayee.  Fixes #671 by jonforums.
* Remove redundant built-in certificates not needed for https://rubygems.org
  Fixes #654 by Vít Ondruch.
* Added test for missing certificates for https://s3.amazonaws.com or
  https://rubygems.org.  Pull request [#673](https://github.com/ruby/rubygems/pull/673) by Hannes Georg.
* RubyGems now allows a Pathname for Kernel#require like the built-in
  Kernel#require.  Pull request [#663](https://github.com/ruby/rubygems/pull/663) by Aaron Patterson.
* Required rbconfig in Gem::ConfigFile for Ruby 1.9.1 compatibility.  (Ruby
  1.9.1 is no longer receiving security fixes, so please update to a newer
  version.)  Issue #676 by Michal Papis.  Issue wayneeseguin/rvm#2262 by
  Thomas Sänger.

## 2.0.10 / 2013-09-24

Security fixes:

* RubyGems 2.1.4 and earlier are vulnerable to excessive CPU usage due to a
  backtracking in Gem::Version validation.  See CVE-2013-4363 for full details
  including vulnerable APIs.  Fixed versions include 2.1.5, 2.0.10, 1.8.27 and
  1.8.23.2 (for Ruby 1.9.3).

## 2.0.9 / 2013-09-13

### Bug fixes:

* Gem fetch now fetches the newest (not oldest) gem when --version is given.
  Issue #643 by Brian Shirai.
* Fixed credential creation for `gem push` when `--host` is not given.  Pull
  request [#622](https://github.com/ruby/rubygems/pull/622) by Arthur Nogueira Neves

## 2.0.8 / 2013-09-09

Security fixes:

* RubyGems 2.0.7 and earlier are vulnerable to excessive CPU usage due to a
  backtracking in Gem::Version validation.  See CVE-2013-4287 for full details
  including vulnerable APIs.  Fixed versions include 2.0.8, 1.8.26 and
  1.8.23.1 (for Ruby 1.9.3).  Issue #626 by Damir Sharipov.

### Bug fixes:

* Fixed Gem.clear_paths when Security is defined at top-level.  Pull request
  [#625](https://github.com/ruby/rubygems/pull/625) by elarkin

## 2.0.7 / 2013-08-15

### Bug fixes:

* Extensions may now be built in parallel (therefore gems may be installed in
  parallel).  Bug #607 by Hemant Kumar.
* Changed broken link to RubyGems Bookshelf to point to RubyGems guides.  Ruby
  pull request [#369](https://github.com/ruby/rubygems/pull/369) by 謝致邦.
* Fixed various test failures due to platform differences or poor tests.
  Patches by Yui Naruse and Koichi Sasada.
* Fixed documentation for Kernel#require.

## 2.0.6 / 2013-07-24

### Bug fixes:

* Fixed the `--no-install` and `-I` options to `gem list` and friends.  Bug
  #593 by Blargel.
* Fixed crash when installing gems with extensions under the `-V` flag.  Bug
  #601 by Nick Hoffman.
* Fixed race condition retrieving HTTP connections in Gem::Request on JRuby.
  Bug #597 by Hemant Kumar.
* Fixed building extensions on ruby 1.9.3 under mingw.  Bug #594 by jonforums,
  Bug #599 by Chris Riesbeck
* Restored default of remote search to `gem search`.

## 2.0.5 / 2013-07-11

* Fixed building of extensions that run ruby in their makefiles.  Bug #589 by
  Zachary Salzbank.

## 2.0.4 / 2013-07-09

### Bug fixes:

* Fixed error caused by gem install not finding the right platform for your
  platform. Bug #576 by John Anderson
* Fixed pushing gems with the default host.  Bug #495 by Utkarsh Kukreti
* Improved unhelpful error message from `gem owner --remove`.  Bug #488 by
  Steve Klabnik
* Fixed typo in `gem spec` help.  Pull request [#563](https://github.com/ruby/rubygems/pull/563) by oooooooo
* Fixed creation of build_info with --install-dir.  Bug #457 by Vít Ondruch.
* RubyGems converts non-string dependency names to strings now.  Bug #505 by
  Terence Lee
* Outdated prerelease versions are now listed in `gem outdated`.
* RubyGems now only calls fsync() on the specification when installing, not
  every file from the gem.  This improves the performance of gem installation
  on some systems.  Pull Request #556 by Grzesiek Kolodziejczyk
* Removed surprise search term anchoring in `gem search` to restore 1.8-like
  search behavior while still defaulting to --remote.  Pull request [#562](https://github.com/ruby/rubygems/pull/562) by
  Ben Bleything
* Fixed handling of DESTDIR when building extensions.  Pull request [#573](https://github.com/ruby/rubygems/pull/573) by
  Akinori MUSHA
* Fixed documentation of `gem pristine` defaults (--all is not a default).
  Pull request [#577](https://github.com/ruby/rubygems/pull/577) by Shannon Skipper
* Fixed a windows extension-building test failure.  Pull request [#575](https://github.com/ruby/rubygems/pull/575) by
  Hiroshi Shirosaki
* Fixed issue with `gem update` where it would attempt to use a Version
  instead of a Requirement to find the latest gem.  Fixes #570 by Nick Cox.
* RubyGems now ignores an empty but set RUBYGEMS_HOST environment variable.
  Based on pull request [#558](https://github.com/ruby/rubygems/pull/558) by Robin Dupret.
* Removed duplicate creation of gem subdirectories in
  Gem::DependencyInstaller.  Pull Request #456 by Vít Ondruch
* RubyGems now works with Ruby built with `--with-ruby-version=''`.  Pull
  Request #455 by Vít Ondruch
* Fixed race condition when two threads require the same gem.  Ruby bug report
  #8374 by Joel VanderWerf
* Cleaned up siteconf between extension build and extension install.  Pull
  request [#587](https://github.com/ruby/rubygems/pull/587) by Dominic Cleal
* Fix deprecation warnings when converting gemspecs to yaml.  Ruby commit
  r41148 by Yui Naruse

## 2.0.3 / 2013-03-11

### Bug fixes:
  * Reverted automatic upgrade to HTTPS as it breaks RubyGems APIs.  Fixes
    #506 by André Arko
  * Use File.realpath to remove extra / while checking if files are
    installable.  Issue #508 by Jacob Evans.
  * When installing RubyGems on JRuby, the standard library is no longer
    deleted.  Fixes #504 by Juan Sanchez, #507 by Charles Oliver Nutter.
  * When building extconf.rb extensions use the intermediate destination
    directory.  This addresses further issues with C extension building.
  * Use the absolute path to the generated siteconf in case the extension
    changes directories to run extconf.rb (like memcached).  Fixes #498 by
    Chris Morris.
  * Fixed default gem key and cert locations.  Pull request [#511](https://github.com/ruby/rubygems/pull/511) by Samuel
    Cochran.

## 2.0.2 / 2013-03-06

### Bug fixes:
  * HTTPS URLs are preferred over HTTP URLs.  RubyGems will now attempt to
    upgrade any HTTP source to HTTPS.  Credit to Alex Gaynor.
  * SSL Certificates are now installed properly.  Fixes #491 by hemanth.hm
  * Fixed HTTP to HTTPS upgrade for rubygems.org.

## 2.0.1 / 2013-03-05

### Bug fixes:
  * Lazily load RubyGems.org API credentials to avoid failure during
    RubyGems installation.  Bug #465 by Isaac Sanders.
  * RubyGems now picks the latest prerelease to install.  Fixes bug #468 by
    Santiago Pastorino.
  * Improved detection of missing Zlib::GzipReader encoding support.  Works
    around JRuby-only bug #472 by Matt Beedle.
  * "Done installing documentation" is no longer displayed when documentation
    generation is disabled.  Fixes bug #469 by Jeff Sandberg
  * The existing executable check now respects --format-executable.  Pull
    request [#471](https://github.com/ruby/rubygems/pull/471) by Jeremy Evans.
  * RubyGems no longer creates gem subdirectories when fetching gems.  Fixes
    #482 by Loren Segal.
  * RubyGems does not require OpenSSL like RubyGems 1.8, but still prefers it.
    Fixes #481 by André Arko.
  * RubyGems only fetches specs for list, search and query commands when
    needed like RubyGems 1.x.  Fixes bug #487 by bitbuerster, Ruby bug #8019
    by Ike Miller.
  * Allow specification of mode for gem subdirectory creation.
    Ruby bug #7713 by nobu
  * Fix tests when an 'a.rb' exists.  Ruby bug #7749 by nobu.

## 2.0.0 / 2013-02-24

RubyGems 2.0 includes several new features and many breaking changes.  Some of
these changes will cause existing software to break.  These changes are a
result of improvements to the internals of RubyGems that make it more
maintainable and improve APIs for RubyGems users.

If you are using bundler be sure to install a 1.3.0.prerelease version or
newer.  Older versions of bundler will not work with RubyGems 2.0.

Changes since RubyGems 1.8.25 (including past pre-releases):

### Breaking changes:

  * Deprecated Gem.unresolved_deps in favor of
    Gem::Specification.unresolved_deps
  * Merged Gem::Builder into Gem::Package.  Use Gem::Package.build(spec)
    instead of Gem::Builder.new(spec).build
  * Merged Gem::Format into Gem::Package.  Use Gem::Package.new instead
    of Gem::Format.from_file_by_path
  * Moved Gem::OldFormat to Gem::Package::Old.  Gem::Package will
    automatically detect old gems for you, so there is no need to refer to it.
  * Removed Gem::DocManager, replaced by Gem::RDoc and done_installing hook
  * Removed Gem::Package::TarInput in favor of Gem::Package
  * Removed Gem::Package::TarOutput in favor of Gem::Package
  * Removed Gem::RemoteFetcher#open_uri_or_path. (steveklabnik)
  * Removed Gem::SSL in favor of using OpenSSL directly
  * Removed Gem.loaded_path
  * Removed RSS generation from the gem indexer
  * Removed benchmark option from .gemrc
  * Removed broken YAML gemspec support in `gem build`
  * Removed support for Ruby 1.9.1
  * Removed many deprecated methods

### Enhancements:

  * Improved support for default gems shipping with ruby 2.0.0+
  * A gem can have arbitrary metadata through Gem::Specification#metadata
  * `gem search` now defaults to --remote and is anchored like gem list.  Fixes
    #166
  * Added --document to replace --rdoc and --ri.  Use --no-document to disable
    documentation, --document=rdoc to only generate rdoc.
  * Only ri-format documentation is generated by default.
  * `gem server` uses RDoc::Servlet from RDoc 4.0 to generate HTML
    documentation.
  * Add ability to install gems directly from a compatible gemdep
    file (Gemfile, Isolate, gem.deps.rb)
    <code>gem install --file path</code>
  * Add ability to load gem activation information from a gemdeps
    file (Gemfile, Isolate, gem.deps.rb).
    Set RUBYGEMS_GEMDEPS=path to have it loaded. Use - as the path
    to autodetect (current and parent directories are searched).
  * Added `gem check --doctor` to clean up after failed uninstallation.  Bug
    #419 by Erik Hollensbe
  * RubyGems no longer defaults to uninstalling gems if a dependency would be
    broken.  Now you must manually say "yes".  Pull Request #406 by Shannon
    Skipper.
  * Gem::DependencyInstaller now passes build_args down to the installer.
    Pull Request #412 by Sam Rawlins.
  * Added a cmake builder.  Pull request [#265](https://github.com/ruby/rubygems/pull/265) by Allan Espinosa.
  * Removed rubyforge page from gem list output
  * Added --only-executables option to `gem pristine`.  Fixes #326
  * Added -I flag for 'gem query' to exclude installed items
  * Added Gem.install(name, version=default) for interactive sessions
  * Added Gem::FilePermissionError#directory
  * Added Gem::rubygems_version which is like Gem::ruby_version
  * Added RUBYGEMS_HOST documentation to `gem env`
  * Added a post_installs hook that runs after Gem::DependencyInstaller
    finishes installing a set of gems
  * Added a usage method for Gem::Commands::OwnerCommand. (ffmike)
  * Added an optional type parameter to Gem::Specification#doc_dir.
  * Added announcements url and clarified how to file tickets
  * Added guidance for how to use rdoc and ri in setup command. (jjb)
  * Attempting to install multiple gems with --version is now an error.  You
    can specify per-gem versions like <code>rake:0.9.5</code>
  * Clarified Gem::CommandManager example code to avoid multi load problems.
    (baroquebobcat)
  * Corrupt or bad cached specs are now re-downloaded. (cookrn)
  * Extension build arguments are saved from install and reused for pristine
  * If the OS allows it, documentation is built in a forked background
    process. (alexch)
  * Imported gem yank from the gemcutter gem.  Fixes #177, #343
  * Packaged gems now contain and verify SHA1 checksums
  * Removed commas from gem update summary so you can paste it back to
    cleanup.  (amatsuda)
  * RubyGems will now warn when building gems with prerelease dependencies.
    Fixes #255
  * The RUBYGEMS_HOST environment variable is used to determine appropriate
    API key for pushing or yanking gems
  * Uninstall is now performed in reverse topological order.
  * Users are told what to type when they try to uninstall a gem outside
    GEM_HOME
  * When building gems with non-world-readable files a warning is shown.

### Bug fixes:
  * Gem.refresh now maintains the active gem list.  Clearing the list would
    cause double-loads which would cause other bugs.  Pull Request #427 by
    Jeremy Evans
  * RubyGems now refuses to read the gem push credentials file if it has
    insecure permissions.  Pull Request #438 by Shannon Skipper
  * RubyGems now requires a local gem name to end in '.gem'.  Issue #407 by
    Santiago Pastorino.
  * Do not allow old-format gems to be installed with a security policy that
    verifies data.
  * Gem installation will fail if RubyGems cannot load the specification from
    the gem.  Bug #419 by Erik Hollensbe
  * RubyGems tests now run in FIPS mode.  Issue #365 by Vít Ondruch
  * Only update the spec cache when we have permission.  Ruby Bug #7509
  * gem install now ignores directories and non .gem files that match the gem
    to install.  Bug #407 by Santiago Pastorino.
  * Added PID to setup bin_file while installing RubyGems to protect against
    errors. Fixes #328 by ConradIrwin
  * Added missing require in Gem::Uninstaller when format_executable is set.
    (sakuro)
  * Exact gem command name matches are now chosen even if a longer command
    overlaps the exact name
  * Fixed Gem.loaded_path? with a Pathname instance. (mattetti)
  * Fixed Gem::Dependency.new mismatch with rubygems.org checks
  * Fixed SecurityError in Gem::Specification.load when $SAFE=1. (ged)
  * Fixed SystemStackError with "gem list -r -a" on 1.9 (cldwalker)
  * Fixed `gem owners` command so that exceptions don't stop the rest of the
    command from completing
  * Fixed `gem unpack uninstalled_gem` default version picker.
  * Fixed defunct rubyforge urls in gem command line help
  * Fixed documentation for the various hooks collections
  * Fixed documentation generation on setup when the gem directory does not
    exist.  Fixes #253
  * Fixed documentation to reflect where defaults overrides are loaded from.
    (ferrous26)
  * Fixed editing of a Makefile with 8-bit characters.  Fixes #181
  * Fixed gem loading issue caused by dependencies not resolving.
  * Fixed independent testing of test_gem_package_tar_output.  Ruby Bug #4686
    by Shota Fukumori
  * Fixed typo in uninstall message. (sandal)
  * Gem::Requirement#<=> returns nil on non-requirement arg.
  * Gem::Requirement.satisfied_by? raises ArgumentError if given a non-version
    argument
  * Gem::Version#initialize no longer modifies its parameter. (miaout17)
  * Group-writable permissions are now allowed for gem repositories. (ctcherry)
  * Memoized values in Gem::Specification are now reset the version or
    platform changes. Fixes #78
  * More specific errors are raised for bad requirements. (arsduo)
  * Removed reference to 'sources' gem in documentation
  * Removed unused block arguments to avoid creating Proc objects. (k-tsj)
  * RubyGems now asks before overwriting executable wrappers.  Ruby Bug #1800
  * The bindir is now created with mkdir_p during install. (voxik)
  * URI scheme matching is no longer case-sensitive.  Fixes #322
  * ext/builder now checks $MAKE as well as $make (okkez)

Changes since RubyGems 2.0.0.rc.2:

### Bug fixes:
  * Gem.gzip and Gem.gunzip now return strings with BINARY encoding.  Issue
    #450 by Jeremy Kemper
  * Fixed placement of executables with --user-install.  Ruby bug #7779 by Jon
    Forums.
  * Fixed `gem update` with --user-install.  Ruby bug #7779 by Jon Forums.
  * Fixed test_initialize_user_install for windows.  Ruby bug #7885 by Luis
    Lavena.
  * Create extension destination directory before building extensions.  Ruby
    Bug #7897 and patch by Kenta Murata.
  * Fixed verification of gems at LowSecurity due to missing signature.
    Thanks to André Arko.

## 2.0.0.rc.2 / 2013-02-08

### Bug fixes:
  * Fixed signature verification of gems which was broken only on master.
    Thanks to Brian Buchanan.
  * Proper exceptions are raised when verifying an unsigned gem.  Thanks to
    André Arko.

## 2.0.0.rc.1 / 2013-01-08

### Enhancements:
  * This release of RubyGems can push gems to rubygems.org.  Ordinarily
    prerelease versions of RubyGems cannot push gems.
  * Added `gem check --doctor` to clean up after failed uninstallation.  Bug
    #419 by Erik Hollensbe

### Bug fixes:
  * Fixed exception raised when attempting to push gems to rubygems.org.  Bug
    #418 by André Arko
  * Gem installation will fail if RubyGems cannot load the specification from
    the gem.  Bug #419 by Erik Hollensbe

## 2.0.0.preview2.2 / 2012-12-14

### Enhancements:
  * Added a cmake builder.  Pull request [#265](https://github.com/ruby/rubygems/pull/265) by Allan Espinosa.
  * Removed rubyforge page from gem list output

### Bug fixes:
  * Restored RubyGems 1.8 packaging behavior of omitting directories.  Bug
    #413 by Jeremy Kemper.

## 2.0.0.preview2.1 / 2012-12-08

### Enhancements:
  * Gem::DependencyInstaller now passes build_args down to the installer.
    Pull Request #412 by Sam Rawlins.
  * RubyGems no longer defaults to uninstalling gems if a dependency would be
    broken.  Now you must manually say "yes".  Pull Request #406 by Shannon
    Skipper.

### Bug fixes:
  * RubyGems tests now run in FIPS mode.  Issue #365 by Vít Ondruch
  * Fixed Gem::Specification#base_dir for default gems.  Ruby Bug #7469
  * Only update the spec cache when we have permission.  Ruby Bug #7509
  * Restored order of version marking.  Fixes an issue with bundler.  Thanks
    to Aaron Patterson and Terence Lee.
  * Gem cleanup now skips default gems.  Pull Request #409 by Kouhei Sutou
  * gem list, search and query can show remote gems again.  Bug #410 by
    Henry Maddocks
  * gem install now ignores directories that match the gem to install.  Bug
    #407 by Santiago Pastorino.

## 2.0.0.preview2 / 2012-12-01

This release contains two commits not present in Ruby 2.0.0.preview2.  One
commit is for ruby 1.8.7 support, the second allows RubyGems to work under
$SAFE=1.  There is no functional difference compared to Ruby 2.0.0.preview2

### Breaking changes:

  * Deprecated Gem.unresolved_deps in favor of
    Gem::Specification.unresolved_deps
  * Merged Gem::Builder into Gem::Package.  Use Gem::Package.build(spec)
    instead of Gem::Builder.new(spec).build
  * Merged Gem::Format into Gem::Package.  Use Gem::Package.new instead
    of Gem::Format.from_file_by_path
  * Moved Gem::OldFormat to Gem::Package::Old.  Gem::Package will
    automatically detect old gems for you, so there is no need to refer to it.
  * Removed Gem::DocManager, replaced by Gem::RDoc and done_installing hook
  * Removed Gem::Package::TarInput in favor of Gem::Package
  * Removed Gem::Package::TarOutput in favor of Gem::Package
  * Removed Gem::RemoteFetcher#open_uri_or_path. (steveklabnik)
  * Removed Gem::SSL in favor of using OpenSSL directly
  * Removed Gem.loaded_path
  * Removed RSS generation from the gem indexer
  * Removed benchmark option from .gemrc
  * Removed broken YAML gemspec support in `gem build`
  * Removed support for Ruby 1.9.1
  * Removed many deprecated methods

### Enhancements:

  * Improved support for default gems shipping with ruby 2.0.0+
  * A gem can have arbitrary metadata through Gem::Specification#metadata
  * `gem search` now defaults to --remote and is anchored like gem list.  Fixes
    #166
  * Added --document to replace --rdoc and --ri.  Use --no-document to disable
    documentation, --document=rdoc to only generate rdoc.
  * Only ri-format documentation is generated by default.
  * `gem server` uses RDoc::Servlet from RDoc 4.0 to generate HTML
    documentation.
  * Add ability to install gems directly from a compatible gemdep
    file (Gemfile, Isolate, gem.deps.rb)
    <code>gem install --file path</code>
  * Add ability to load gem activation information from a gemdeps
    file (Gemfile, Isolate, gem.deps.rb).
    Set RUBYGEMS_GEMDEPS=path to have it loaded. Use - as the path
    to autodetect (current and parent directories are searched).
  * Added --only-executables option to `gem pristine`.  Fixes #326
  * Added -I flag for 'gem query' to exclude installed items
  * Added Gem.install(name, version=default) for interactive sessions
  * Added Gem::FilePermissionError#directory
  * Added Gem::rubygems_version which is like Gem::ruby_version
  * Added RUBYGEMS_HOST documentation to `gem env`
  * Added a post_installs hook that runs after Gem::DependencyInstaller
    finishes installing a set of gems
  * Added a usage method for Gem::Commands::OwnerCommand. (ffmike)
  * Added an optional type parameter to Gem::Specification#doc_dir.
  * Added announcements url and clarified how to file tickets
  * Added guidance for how to use rdoc and ri in setup command. (jjb)
  * Attempting to install multiple gems with --version is now an error.  You
    can specify per-gem versions like <code>rake:0.9.5</code>
  * Clarified Gem::CommandManager example code to avoid multi load problems.
    (baroquebobcat)
  * Corrupt or bad cached specs are now re-downloaded. (cookrn)
  * Extension build arguments are saved from install and reused for pristine
  * If the OS allows it, documentation is built in a forked background
    process. (alexch)
  * Imported gem yank from the gemcutter gem.  Fixes #177, #343
  * Packaged gems now contain and verify SHA1 checksums
  * Removed commas from gem update summary so you can paste it back to
    cleanup.  (amatsuda)
  * RubyGems will now warn when building gems with prerelease dependencies.
    Fixes #255
  * The RUBYGEMS_HOST environment variable is used to determine appropriate
    API key for pushing or yanking gems
  * Uninstall is now performed in reverse topological order.
  * Users are told what to type when they try to uninstall a gem outside
    GEM_HOME
  * When building gems with non-world-readable files a warning is shown.

### Bug fixes:

  * Added PID to setup bin_file while installing RubyGems to protect against
    errors. Fixes #328 by ConradIrwin
  * Added missing require in Gem::Uninstaller when format_executable is set.
    (sakuro)
  * Exact gem command name matches are now chosen even if a longer command
    overlaps the exact name
  * Fixed Gem.loaded_path? with a Pathname instance. (mattetti)
  * Fixed Gem::Dependency.new mismatch with rubygems.org checks
  * Fixed SecurityError in Gem::Specification.load when $SAFE=1. (ged)
  * Fixed SystemStackError with "gem list -r -a" on 1.9 (cldwalker)
  * Fixed `gem owners` command so that exceptions don't stop the rest of the
    command from completing
  * Fixed `gem unpack uninstalled_gem` default version picker.
  * Fixed defunct rubyforge urls in gem command line help
  * Fixed documentation for the various hooks collections
  * Fixed documentation generation on setup when the gem directory does not
    exist.  Fixes #253
  * Fixed documentation to reflect where defaults overrides are loaded from.
    (ferrous26)
  * Fixed editing of a Makefile with 8-bit characters.  Fixes #181
  * Fixed gem loading issue caused by dependencies not resolving.
  * Fixed independent testing of test_gem_package_tar_output.  Ruby Bug #4686
    by Shota Fukumori
  * Fixed typo in uninstall message. (sandal)
  * Gem::Requirement#<=> returns nil on non-requirement arg.
  * Gem::Requirement.satisfied_by? raises ArgumentError if given a non-version
    argument
  * Gem::Version#initialize no longer modifies its parameter. (miaout17)
  * Group-writable permissions are now allowed for gem repositories. (ctcherry)
  * Memoized values in Gem::Specification are now reset the version or
    platform changes. Fixes #78
  * More specific errors are raised for bad requirements. (arsduo)
  * Removed reference to 'sources' gem in documentation
  * Removed unused block arguments to avoid creating Proc objects. (k-tsj)
  * RubyGems now asks before overwriting executable wrappers.  Ruby Bug #1800
  * The bindir is now created with mkdir_p during install. (voxik)
  * URI scheme matching is no longer case-sensitive.  Fixes #322
  * ext/builder now checks $MAKE as well as $make (okkez)

## 1.8.29 / 2013-11-23

### Bug fixes:

* Fixed installation when the LANG environment variable is empty.
* Added DigiCert High Assurance EV Root CA to the default SSL certificates for
  cloudfront.

## 1.8.28 / 2013-10-08

### Bug fixes:

* Added the Verisign Class 3 Public Primary Certification Authority G5
  certificate and its intermediary to follow the s3.amazonaws.com certificate
  change.  Fixes #665 by emeyekayee.  Fixes #671 by jonforums.
* Remove redundant built-in certificates not needed for https://rubygems.org
  Fixes #654 by Vít Ondruch.
* Added test for missing certificates for https://s3.amazonaws.com or
  https://rubygems.org.  Pull request [#673](https://github.com/ruby/rubygems/pull/673) by Hannes Georg.

## 1.8.27 / 2013-09-24

Security fixes:

* RubyGems 2.1.4 and earlier are vulnerable to excessive CPU usage due to a
  backtracking in Gem::Version validation.  See CVE-2013-4363 for full details
  including vulnerable APIs.  Fixed versions include 2.1.5, 2.0.10, 1.8.27 and
  1.8.23.2 (for Ruby 1.9.3).

## 1.8.26 / 2013-09-09

Security fixes:

* RubyGems 2.0.7 and earlier are vulnerable to excessive CPU usage due to a
  backtracking in Gem::Version validation.  See CVE-2013-4287 for full details
  including vulnerable APIs.  Fixed versions include 2.0.8, 1.8.26 and
  1.8.23.1 (for Ruby 1.9.3).  Issue #626 by Damir Sharipov.

### Bug fixes:

* Fixed editing of a Makefile with 8-bit characters.  Fixes #181

## 1.8.25 / 2013-01-24

### Bug fixes:
  * Added 11627 to setup bin_file location to protect against errors. Fixes
    #328 by ConradIrwin
  * Specification#ruby_code didn't handle Requirement with multiple
  * Fix error on creating a Version object with a frozen string.
  * Fix incremental index updates
  * Fix missing load_yaml in YAML-related requirement.rb code.
  * Manually backport encoding-aware YAML gemspec

## 1.8.24 / 2012-04-27

### Bug fixes:

  * Install the .pem files properly. Fixes #320
  * Remove OpenSSL dependency from the http code path

## 1.8.23.2 / 2013-09-24

Security fixes:

* RubyGems 2.1.4 and earlier are vulnerable to excessive CPU usage due to a
  backtracking in Gem::Version validation.  See CVE-2013-4363 for full details
  including vulnerable APIs.  Fixed versions include 2.1.5, 2.0.10, 1.8.27 and
  1.8.23.2 (for Ruby 1.9.3).

## 1.8.23.1 / 2013-09-09

Security fixes:

* RubyGems 2.0.7 and earlier are vulnerable to excessive CPU usage due to a
  backtracking in Gem::Version validation.  See CVE-2013-4287 for full details
  including vulnerable APIs.  Fixed versions include 2.0.8, 1.8.26 and
  1.8.23.1 (for Ruby 1.9.3).  Issue #626 by Damir Sharipov.

## 1.8.23 / 2012-04-19

This release increases the security used when RubyGems is talking to
an https server. If you use a custom RubyGems server over SSL, this
release will cause RubyGems to no longer connect unless your SSL cert
is globally valid.

You can configure SSL certificate usage in RubyGems through the
:ssl_ca_cert and :ssl_verify_mode options in ~/.gemrc and /etc/gemrc.
The recommended way is to set :ssl_ca_cert to the CA certificate for
your server or a certificate bundle containing your CA certification.

You may also set :ssl_verify_mode to 0 to completely disable SSL
certificate checks, but this is not recommended.


Security fixes:
  * Disallow redirects from https to http
  * Turn on verification of server SSL certs

### Enhancements:
  * Add --clear-sources to fetch

### Bug fixes:
  * Use File.identical? to check if two files are the same.
  * Fixed init_with warning when using psych

## 1.8.22 / 2012-04-13

### Bug fixes:

  * Workaround for psych/syck YAML date parsing issue
  * Don't trust the encoding of ARGV. Fixes #307
  * Quiet default warnings about missing spec variables
  * Read a binary file properly (windows fix)

## 1.8.21 / 2012-03-22

### Bug fixes:

  * Add workaround for buggy yaml output from 1.9.2
  * Force 1.9.1 to remove it's prelude code. Fixes #305

## 1.8.20 / 2012-03-21

### Bug fixes:

  * Add --force to `gem build` to skip validation. Fixes #297
  * Gracefully deal with YAML::PrivateType objects in Marshal'd gemspecs
  * Treat the source as a proper url base. Fixes #304
  * Warn when updating the specs cache fails. Fixes #300

## 1.8.19 / 2012-03-14

### Bug fixes:

  * Handle loading psych vs syck properly. Fixes #298
  * Make sure Date objects don't leak in via Marshal
  * Perform Date => Time coercion on yaml loading. Fixes #266

## 1.8.18 / 2012-03-11

### Bug fixes:

  * Use Psych API to emit more compatible YAML
  * Download and write inside `gem fetch` directly. Fixes #289
  * Honor sysconfdir on 1.8. Fixes #291
  * Search everywhere for a spec for `gem spec`. Fixes #288
  * Fix Gem.all_load_path. Fixes #171

## 1.8.17 / 2012-02-17

### Enhancements:

  * Add MacRuby to the list of special cases for platforms (ferrous26)
  * Add a default for where to install rubygems itself

### Bug fixes:

  * Fixed gem loading issue caused by dependencies not resolving.
  * Fixed umask error when stdlib is required and unresolved dependencies exist.
  * Shebang munging would only take one arg after the cmd
  * Define SUCKAGE better, ie only MRI 1.9.2
  * Propagate env-shebang to the pristine command if set for install.

## 1.8.16 / 2012-02-12

### Bug fixes:

  * Fix gem specification loading when encoding is not UTF-8. #146
  * Allow group writable if umask allows it already.
  * Uniquify the spec list based on directory order priority

## 1.8.15 / 2012-01-06

### Bug fixes:

  * Don't eager load yaml, it creates a bad loop. Fixes #256

## 1.8.14 / 2012-01-05

### Bug fixes:

  * Ignore old/bad cache data in Version
  * Make sure our YAML workarounds are loaded properly. Fixes #250.

## 1.8.13 / 2011-12-21

### Bug fixes:

  * Check loaded_specs properly when trying to satisfy a dep

### Enhancements:

  * Remove using #loaded_path? for performance
  * Remove Zlib workaround for Windows build.

## 1.8.12 / 2011-12-02

### Bug fixes:

  * Handle more cases where Syck's DefaultKey showed up in requirements
    and wasn't cleaned out.

## 1.8.11 / 2011-10-03

### Bug fixes:

  * Deprecate was moved to Gem::Deprecate to stop polluting the top-level
    namespace.

## 1.8.10 / 2011-08-25

RubyGems 1.8.10 contains a security fix that prevents malicious gems from
executing code when their specification is loaded.  See
https://github.com/ruby/rubygems/pull/165 for details.

### Bug fixes:

  * RubyGems escapes strings in ruby-format specs using #dump instead of #to_s
    and %q to prevent code injection.  Issue #165 by Postmodern
  * RubyGems attempt to activate the psych gem now to obtain bugfixes from
    psych.
  * Gem.dir has been restored to the front of Gem.path.  Fixes remaining
    problem with Issue #115
  * Fixed Syck DefaultKey infecting ruby-format specifications.
  * `gem uninstall a b` no longer stops if gem "a" is not installed.

## 1.8.9 / 2011-08-23

### Bug fixes:

  * Fixed uninstalling multiple gems using `gem uninstall`
  * Gem.use_paths splatted to take multiple paths!  Issue #148

## 1.8.8 / 2011-08-11

### Bug fixes:
  * The encoding of a gem's YAML spec is now UTF-8.  Issue #149

## 1.8.7 / 2011-08-04

### Bug fixes:
  * Added missing require for `gem uninstall --format-executable`
  * The correct name of the executable being uninstalled is now displayed with
    --format-executable
  * Fixed `gem unpack uninstalled_gem` default version picker
  * RubyGems no longer claims a nonexistent gem can be uninstalled
  * `gem which` no longer claims directories are requirable files
  * `gem cleanup` continues cleaning up gems if one can't be uninstalled due
    to permissions.  Issue #82
  * Gem repository directories are no longer created world-writable.  Patch by
    Sakuro OZAWA.  Ruby Bug #4930

## 1.8.6 / 2011-07-25

### Enhancements:

  * Add autorequires and delay startup of RubyGems until require is called.
    See Ruby bug #4962

### Bug fixes:

  * Restore behavior of Gem::Specification#loaded?  Ruby Bug #5032
  * Clean up SourceIndex.add_specs to not be so damn noisy. (tadman)
  * Added missing APPLE_GEM_HOME in paths.
  * Extend YAML::Syck::DefaultKey fixing to `marshal_dump` as well.
  * Fix #29216: check correct bin_dir in check_that_user_bin_dir_is_in_path.
  * Revert Gem.latest_load_paths to working order (PathSupport revert).
  * Restore normalization of GEM_HOME.
  * Handle the Syck DefaultKey problem once and for all.
  * Fix SystemStackError occurring with "gem list -r -a" on 1.9.

## 1.8.5 / 2011-05-31

### Enhancements:

  * The -u option to 'update local source cache' is official deprecated.
  * Remove has_rdoc deprecations from Specification.

### Bug fixes:

  * Handle bad specs more gracefully.
  * Reset any Gem paths changed in the installer.

## 1.8.4 / 2011-05-25

### Enhancements:

  * Removed default_executable deprecations from Specification.

## 1.8.3 / 2011-05-19

### Bug fixes:

  * Fix independent testing of test_gem_package_tar_output.  Ruby Bug #4686 by
    Shota Fukumori
  * Fix test failures for systems with separate ruby versions.  Ruby Bug #3808
    by Jeremy Evans
  * Fixed some bad calls left behind after rolling out some refactorings.
  * Syck has a parse error on (good) times output from Psych. (dazuma, et al)

## 1.8.2 / 2011-05-11

### Enhancements:

  * Moved #outdated from OutdatedCommand to Specification (for Isolate).
  * Print out a warning about missing executables.

### Bug fixes:

  * Added missing requires to fix various upgrade issues.
  * `gem pristine` respects multiple gem repositories.
  * setup.rb now execs with --disable-gems when possible

## 1.8.1 / 2011-05-05

### Enhancements:

  * Added Gem::Requirement#specific? and Gem::Dependency#specific?

### Bug fixes:

  * Typo on Indexer rendered it useless on Windows
  * gem dep can fetch remote dependencies for non-latest gems again.
  * gem uninstall with multiple versions no longer crashes with ArgumentError
  * Always use binary mode for File.open to keep Windows happy

## 1.8.0 / 2011-04-34

This release focused on properly encapsulating functionality.  Most of this
work focused on moving functionality out of Gem::SourceIndex and
Gem::GemPathSearcher into Gem::Specification where it belongs.

After installing RubyGems 1.8.0 you will see deprecations when loading your
existing gems.  Run `gem pristine --all --no-extensions` to regenerate your
gem specifications safely.

Currently RubyGems does not save the build arguments used to build gems with
extensions.  You will need to run `gem pristine gem_with_extension --
--build-arg` to regenerate a gem with an extension where it requires special
build arguments.

### Deprecations:

  * DependencyList.from_source_index deprecated the source_index argument.
  * Deprecated Dependency.new(/regex/).
  * Deprecated Gem.searcher.
  * Deprecated Gem.source_index and Gem.available?
  * Deprecated Gem: activate_dep, activate_spec, activate,
    report_activate_error, and required_location.
  * Deprecated Gem::all_partials
  * Deprecated Gem::cache_dir
  * Deprecated Gem::cache_gem
  * Deprecated Gem::default_system_source_cache_dir
  * Deprecated Gem::default_user_source_cache_dir
  * Deprecated Platform#empty?
  * Deprecated Specification.cache_gem
  * Deprecated Specification.installation_path
  * Deprecated Specification.loaded, loaded?, and loaded=
  * Deprecated all of Gem::SourceIndex.
  * Deprecated all of Gem::GemPathSearcher.
  * Deprecated Gem::Specification#default_executable.

### Enhancements:

  * Gem::SourceIndex functionality has been moved to Gem::Specification.
    Gem::SourceIndex is completely disconnected from Gem::Specification
  * Refactored GemPathSearcher entirely out. RIPMF
  * Added CommandManager#unregister_command
  * Added Dependency#matching_specs + to_specs.
  * Added Dependency#to_spec
  * Added Gem.pre_reset_hook/s and post_reset_hook/s.
  * Added GemCommand.reset to reinitialize the singleton
  * Added Specification#activate.
  * Added Specification#activated, activated=, and activated?
  * Added Specification#base_dir.
  * Added Specification#bin_dir and bin_file.
  * Added Specification#cache_dir and cache_file. Aliased cache_gem.
  * Added Specification#doc_dir and ri_dir.
  * Added Specification#find(name_or_dep, *requirements).
  * Added Specification#gem_dir and gems_dir.
  * Added Specification#spec_dir and spec_file.
  * Added Specification.add_spec, add_specs, and remove_spec.
  * Added Specification.all=. If you use this, we will light you on fire.
  * Added Specification.all_names.
  * Added Specification.dirs and dirs=. dirs= resets.
  * Added Specification.find_all_by_name(name, *reqs)
  * Added Specification.latest_specs. SO TINY!
  * Added TestCase#all_spec_names to help clean up tests
  * Added TestCase#assert_path_exists and refute_path_exists. Will move to
    minitest.
  * Gem.sources no longer tries to load sources gem. Only uses default_sources.
  * Installer no longer accepts a source_index option.
  * More low-level integration.
  * Removed Gem::FileOperations since it is a dummy class
  * Removed a comment because I am dumb
  * Removed pkgs/sources/lib/sources.rb
  * Revamped indexer to mostly not use SourceIndex (legacy index requires it).
  * Rewrote our last functional test suite to be happy and fast
  * RubyGems is now under the Ruby License or the MIT license
  * Specification#== now only checks name, version, and platform.
  * Specification#authors= now forcefully flattens contents (bad rspec! no
    cookie!)
  * Specification#eql? checks all fields.
  * Specification#installation_path no longer raises if it hasn't been
    activated.
  * Specification#validate now ensures that authors is not empty.
  * TestCase.util_setup_spec_fetcher no longer returns a SourceIndex.
  * Uninstaller no longer passes around SourceIndex instances
  * Warn on loading bad spec array values (ntlm-http gem has nil in its cert
    chain)
  * `gem pristine` now accepts --no-executables to skip restoring gems with
    extensions.
  * `gem pristine` can now restore multiple gems.

### Bug fixes:

  * DependencyInstaller passed around a source_index instance but used
    Gem.source_index.
  * Fixed Platform#== and #hash so instances may be used as hash keys.
  * Fixed broken Specification#original_platform. It should never be nil.
  * Gem::Text#format_text now strips trailing whitespace
  * Normalize LOAD_PATH with File.expand_path
  * `gem build` errors should exit 1.
  * `gem pristine` can now restore non-latest gems where the cached gem was
    removed.

## 1.7.1 / 2011-03-32

### Bug fixes:
  * Fixed missing file in Manifest.txt.  (Also a bug in hoe was fixed where
    `rake check_manifest` showing a diff would not exit with an error.)

## 1.7.0 / 2011-03-32

### Deprecations:
  * Deprecated Gem.all_load_paths, latest_load_paths, promote_load_path, and
    cache.
  * Deprecated RemoteFetcher#open_uri_or_path.
  * Deprecated SourceIndex#all_gems.
  * Deprecated SourceIndex#initialize(hash_of_specs).
  * Deprecated SourceIndex.from_installed_gems, from_gems_in, and
    load_specification.
  * Deprecated Specification#has_rdoc, default_executable, and
    test_suite_file(=).
  * Deprecated Specification#has_rdoc= and default_executable=

### Enhancements:
  * Added stupid simple deprecation module.
  * Added --spec option to `gem unpack` to output a gem's original metadata
  * Added packaging option to Specification#validate
  * Gem.bin_path requires the exec_name argument.
  * Read from cached specs if fetch fails for some reason
  * Refactored Specification#assign_defaults into #initialize.
  * RemoteFetcher#fetch_path now dispatches dynamically to 'fetch_<uri.schema>'
  * Removed Specification @@gather.
  * Removed Specification.attribute.
  * Removed Specification.attribute_alias_singular.
  * Removed Specification.attribute_defaults.
  * Removed Specification.attributes
  * Removed Specification.overwrite_accessor.
  * Removed Specification.read_only.
  * Removed Specification.required_attribute.
  * Removed Specification::SPECIFICATION_VERSION_HISTORY and turned into rdoc
  * Removed blanket rescue in default_executable. Hope it doesn't blow up! :P
  * Removed nearly all metaprogramming from Specification. Yay for
    attr_accessor!
  * SourceIndex#initialize changed to prefer an array of spec dirs, defaulting
    to none.
  * SourceIndex.new is now the preferred way to create SourceIndex instances.
    *gasp*
  * Specification#validate now checks that array attribs are indeed arrays.
  * Specification.default_value is now an instance method.
  * Switched Specification::TODAY to be proper midnight @ UTC
  * Update Gem::RemoteFetcher\'s User-Agent to handle RUBY_ENGINE and
    RUBY_REVISION when patchlevel is -1
  * UpdateCommand#gems_to_update now returns (name, version) pairs.
  * UpdateCommand#which_to_update now takes an optional system argument.

### Bug fixes:
  * Added missing remote fetcher require to pristine command (aarnell)
  * Building gems now checks to ensure all required fields are non-nil
  * Fix option parser when summary is nil.
  * Fixed `gem contents` to work with the lightweight specifications
  * Fixed `gem update --system x.y.z` where x.y.z == latest version. (MGPalmer)
  * Fixed gem contents sorting and tests. (MGPalmer)
  * Fixed intermittent problem in `gem fetch` with --platform specified (quix)
  * Fixed lightweight specifications so `gem rdoc` will generate proper
    documentation
  * MockGemUI#terminate_interaction should not raise Gem::SystemExitException.
    (MGPalmer)
  * RubyGems now raises a better error for broken .gem files.  Bug #29067 by
    Elias Baixas
  * `gem update` now uniq's command line arguments.

## 1.6.2 / 2011-03-08

### Bug fixes:

* require of an activated gem could cause activation conflicts.  Fixes
  Bug #29056 by Dave Verwer.
* `gem outdated` now works with up-to-date prerelease gems.

## 1.6.1 / 2011-03-03

### Bug fixes:

* Installation no longer fails when a dependency from a version that won't be
  installed is unsatisfied.
* README.rdoc now shows how to file tickets and get help.  Pull Request #40 by
  Aaron Patterson.
* Gem files are cached correctly again.  Patch #29051 by Mamoru Tasaka.
* Tests now pass with non-022 umask.  Patch #29050 by Mamoru Tasaka.

## 1.6.0 / 2011-02-29

### Deprecations:

* RubyGems no longer requires 'thread'.  Rails < 3 will need to add require
  'thread' to their applications.
* Gem.cache is deprecated.  Use Gem.source_index.
* RbConfig.datadir is deprecated.  Use Gem.datadir.
* Gem::LoadError#version_requirements has been removed.  Use
  Gem::LoadError#requirement.

### Enhancements:

* Rewrote how Gem::activate (gem and require) resolves dependencies.
* Gem::LoadError#version_requirement has been removed. Use
  Gem::LoadError#requirement.
* Added --key to `gem push` for setting alternate API keys.
* Added --format-executable support to gem uninstall.
* Added Gem::DependencyList#clear.
* Added Gem::DependencyList#remove_specs_unsatisfied_by
* Added Gem.latest_spec_for, latest_version_for, and latest_rubygems_version.
* Added Gem::Dependency#merge which merges requirements for two
  dependencies.
* Added Gem::TestCase#util_spec for faster tests.
* Added Gem::Specification#dependent_specs.
* Added Gem::TestCase#new_spec and Gem::TestCase#install_specs.
* Added flag to include prerelease gems in Gem::SourceIndex#latest_specs.
* Gem.cache_dir always references the proper cache dir.
  Pass true to support a user path.
* Gem.cache_gem, given a filename always references the cache gem.
  Pass true to support a user path.
* Added Gem::Specification#conflicts
* Removed rdoc gem/require from test_case.rb.
* Rubygems will no longer let you push if you're using beta or unreleased
  rubygems.
* Save RAM / GC churn by removing spec.files and rdoc options from
  locally cached gem specifications.
* SpecFetcher.fetch_spec can now take a string source_uri.

### Bug fixes:

* Added missing require of Gem::RemoteFetcher to the unpack command.
* RubyGems now completely removes a previous install when reinstalling.
* Fixed Gem::Installer#generate_bin to only chmod files that exist.
* Fixed handling of Windows style file:/// uris.
* Fixed requires in tests. (shota)
* Fixed script generation on Windows.
* Fixed test issues if you have older rubygems installed.
* Gem::DependencyInstaller tests use Gem::Security, add the missing require.
* Gem::Security used FileUtils but didn't require it.  Reported by Elia Schito.
* Gem::Uninstaller now respects --format-executable.

## 1.5.3 / 2011-02-26

### Bug fixes:

* Fix for a bug in Syck which causes install failures for gems packaged with
  Psych.  Bug #28965 by Aaron Patterson.

## 1.5.2 / 2011-02-10

### Bug fixes:

* Fixed <tt>gem update --system</tt>.  RubyGems can now update itself again.

## 1.5.1 / 2011-02-09

### Enhancements:

* Added ability to do gem update --system X.Y.Z.

### Bug fixes:

* Scrub !!null YAML from 1.9.2 (install and build).
* Added missing requires for user_interaction.
* Wrote option processing tests for gem update.
* Updated upgrading doco for new gem update --system option.
* Fixed SilentUI for cygwin; try /dev/null first then fall back to NUL.
* RubyGems now enforces ruby 1.8.7 or newer.

## 1.5.0 / 2011-01-31

### Enhancements:

* Finally fixed all known 1.9.x issues. Upgrading is now possible!
* Merged huge 1.3.7/ruby-core changes to master.
* Added UPGRADING.rdoc to help deal with 1.9 issues.
* Gem::Format now gives better errors for corrupt gem files and includes paths
* Pre-install hooks can now abort gem installation by returning false
* Move shareable TestCase classes to lib/ to help plugin authors with tests.
* Add post-build hooks that can cancel the gem install
* Always require custom_require now that require_gem is gone
* Added GemInstaller accessors for @options so plugins can reference them.
* Optimized Gem.find_files. ~10% faster than 1.4.2. ~40% faster than ruby 1.9.
* Gem::SilentUI now behaves like Gem::StreamUI for asking questions.  Patch by
  Erik Hollensbe.

### Bug fixes:

* `gem update` was implicitly doing --system.
* 1.9.3: Fixed encoding errors causing gem installs to die during rdoc phase.
* Add RubyForge URL to README. Closes #28825
* 1.9.3: Use chdir {} when building extensions to prevent warnings. Fixes #4337
* 1.9.2: Fix circular require warning.
* Make requiring openssl even lazier at request of NaHi
* `gem unpack` will now download the gem if it is not in the cache. Patch by
  Erik Hollensbe.
* rubygems-update lists its development dependencies again

## 1.4.2 / 2011-01-06

### Bug fixes:

* Gem::Versions: "1.b1" != "1.b.1", but "1.b1" eql? "1.b.1". Fixes gem indexing.
* Fixed Gem.find_files.
* Removed otherwise unused #find_all_dot_rb. Only 6 days old and hella buggy.

## 1.4.1 / 2010-12-31

Since apparently nobody reads my emails, blog posts or the README:

DO NOT UPDATE RUBYGEMS ON RUBY 1.9! See UPGRADING.rdoc for details.

### Bug fixes:

* Specification#load was untainting a frozen string (via `gem build *.spec`)

## 1.4.0 / 2010-12-30

NOTE: In order to better maintain rubygems and to get it in sync with
the world (eg, 1.9's 1.3.7 is different from our 1.3.7), rubygems is
switching to a 4-6 week release schedule. This release is the
precursor to that process and as such may be a bit on the wild side!
You have been warned!

NOTE: We've switched to git/github. See README.rdoc for details.

### Features:

* Added --launch option to `gem server`. (gthiesfeld)
* Added fuzzy name matching on install failures. (gstark/presidentbeef)
* Allow searching w/ file extensions: gem which fileutils.rb
* Progress indicator during download (Ryan Melton)
* Speed up Gem::Version#<=> by 2-3x in common cases. (raggi)
* --source is now additive with your current sources.
  Use --clear-sources first to maintain previous behavior.

### Bug fixes:

* Dependency "~>"s now respect lower-bound prerelease versions.
* Ensure the gem directories exist on download.
* Expand Windows user home candidates for Ruby 1.8. Bug #28371 & #28494
* Fix find_files to order by version.
* Fix ivar typo. [Josh Peek]
* Normalized requires and made many of them lazy.
  Do not depend on rubygems to require stdlib stuff for you. (raggi/tmm1)
* Treat 1.0.a10 like 1.0.a.10 for sorting, etc. Fixes #27903. (dchelimsky)

## 1.3.7 / 2010-05-13

NOTE:

https://rubygems.org/ is now the default source for downloading gems.

You may have sources set via ~/.gemrc, so you should replace
http://gems.rubyforge.org with https://rubygems.org/

http://gems.rubyforge.org will continue to work for the foreseeable future.

### Features:

* `gem` commands
  * `gem install` and `gem fetch` now report alternate platforms when a
    matching one couldn't be found.
  * `gem contents` --prefix is now the default as specified in --help.  Bug
    #27211 by Mamoru Tasaka.
  * `gem fetch` can fetch of old versions again.  Bug #27960 by Eric Hankins.
  * `gem query` and friends output now lists platforms.  Bug #27856 by Greg
    Hazel.
  * `gem server` now allows specification of multiple gem dirs for
    documentation.  Bug #27573 by Yuki Sonoda.
  * `gem unpack` can unpack gems again.  Bug #27872 by Timothy Jones.
  * `gem unpack` now unpacks remote gems.
  * --user-install is no longer the default.  If you really liked it, see
    Gem::ConfigFile to learn how to set it by default.  (This change was made
    in 1.3.6)
* RubyGems now has platform support for IronRuby.  Patch #27951 by Will Green.

### Bug fixes:

* Require rubygems/custom_require if --disable-gem was set.  Bug #27700 by
  Roger Pack.
* RubyGems now protects against exceptions being raised by plugins.
* rubygems/builder now requires user_interaction.  Ruby Bug #1040 by Phillip
  Toland.
* Gem::Dependency support #version_requirements= with a warning.  Fix for old
  Rails versions.  Bug #27868 by Wei Jen Lu.
* Gem::PackageTask depends on the package dir like the other rake package
  tasks so dependencies can be hooked up correctly.

## 1.3.6 / 2010-02-17

### Features:

* `gem` commands
  * Added `gem push` and `gem owner` for interacting with modern/Gemcutter
    sources
  * `gem dep` now supports --prerelease.
  * `gem fetch` now supports --prerelease.
  * `gem server` now supports --bind.  Patch #27357 by Bruno Michel.
  * `gem rdoc` no longer overwrites built documentation.  Use --overwrite
    force rebuilding.  Patch #25982 by Akinori MUSHA.
* Capital letters are now allowed in prerelease versions.

### Bug fixes:

* Development deps are no longer added to rubygems-update gem so older
  versions can update successfully.
* Installer bugs:
  * Prerelease gems can now depend on non-prerelease gems.
  * Development dependencies are ignored unless explicitly needed.  Bug #27608
    by Roger Pack.
* `gem` commands
  * `gem which` now fails if no paths were found.  Adapted patch #27681 by
    Caio Chassot.
  * `gem server` no longer has invalid markup.  Bug #27045 by Eric Young.
  * `gem list` and friends show both prerelease and regular gems when
    --prerelease --all is given
* Gem::Format no longer crashes on empty files.  Bug #27292 by Ian Ragsdale.
* Gem::GemPathSearcher handles nil require_paths. Patch #27334 by Roger Pack.
* Gem::RemoteFetcher no longer copies the file if it is where we want it.
  Patch #27409 by Jakub Šťastný.

### Deprecations:

* lib/rubygems/timer.rb has been removed.
* Gem::Dependency#version_requirements is deprecated and will be removed on or
  after August 2010.
* Bulk index update is no longer supported.
* Gem::manage_gems was removed in 1.3.3.
* Time::today was removed in 1.3.3.

## 1.3.5 / 2009-07-21

### Bug fixes:

* Fix use of prerelease gems.
* Gem.bin_path no longer escapes path with spaces. Bug #25935 and #26458.

### Deprecations:

* Bulk index update is no longer supported (the code currently remains, but not
  the tests)
* Gem::manage_gems was removed in 1.3.3.
* Time::today was removed in 1.3.3.

## 1.3.4 / 2009-05-03

### Bug fixes:

* Fixed various warnings
* Gem::ruby_version works correctly for 1.8 branch and trunk
* Prerelease gems now show up in `gem list` and can be used
* Fixed option name for `gem setup --format-executable`
* RubyGems now matches Ruby > 1.9.1 gem paths
* Gem::RemoteFetcher#download now works for explicit Windows paths across
  drives.  Bug #25882 by Lars Christensen
* Fix typo in Gem::Requirement#parse.  Bug #26000 by Mike Gunderloy.

### Deprecations:

* Bulk index update is no longer supported (the code currently remains, but not
  the tests)
* Gem::manage_gems was removed in 1.3.3.
* Time::today was removed in 1.3.3.

## 1.3.3 / 2009-05-04

### Features:

* `gem server` allows port names (from /etc/services) with --port.
* `gem server` now has search that jumps to RDoc.  Patch #22959 by Vladimir
  Dobriakov.
* `gem spec` can retrieve single fields from a spec (like `gem spec rake
  authors`).
* Gem::Specification#has_rdoc= is deprecated and ignored (defaults to true)
* RDoc is now generated regardless of Gem::Specification#has_rdoc?

### Bug fixes:

* `gem clean` now cleans up --user-install gems.  Bug #25516 by Brett
  Eisenberg.
* Gem.bin_path now escapes paths with spaces.
* Rake extension builder uses explicit correctly loads rubygems when invoking
  rake.
* Prerelease versions now match "~>" correctly.  Patch #25759 by Yossef
  Mendelssohn.
* Check bindir for executables, not root when validating.  Bug reported by
  David Chelimsky.
* Remove Time.today, no way to override it before RubyGems loads.  Bug #25564
  by Emanuele Vicentini
* Raise Gem::Exception for #installation_path when not installed.  Bug #25741
  by Daniel Berger.
* Don't raise in Gem::Specification#validate when homepage is nil.  Bug #25677
  by Mike Burrows.
* Uninstall executables from the correct directory.  Bug #25555 by Brett
  Eisenberg.
* Raise Gem::LoadError if Kernel#gem fails due to previously-loaded gem.  Bug
  reported by Alf Mikula.

### Deprecations:

* Gem::manage_gems has been removed.
* Time::today has been removed early.  There was no way to make it warn and be
  easy to override with user code.

## 1.3.2 / 2009-04-15

### Features:

* RubyGems now loads plugins from rubygems_plugin.rb in installed gems.
  This can be used to add commands (See Gem::CommandManager) or add
  install/uninstall hooks (See Gem::Installer and Gem::Uninstaller).
* Gem::Version now understands prerelease versions using letters. (eg.
  '1.2.1.b')  Thanks to Josh Susser, Alex Vollmer and Phil Hagelberg.
* RubyGems now includes a Rake task for creating gems which replaces rake's
  Rake::GemPackageTask.  See Gem::PackageTask.
* Gem::find_files now returns paths in $LOAD_PATH.
* Added Gem::promote_load_path for use with Gem::find_files
* Added Gem::bin_path to make finding executables easier.  Patch #24114 by
  James Tucker.
* Various improvements to build arguments for installing gems.
* `gem contents` added --all and --no-prefix.
* Gem::Specification
  * `#validate` strips directories and errors on not-files.
  * `#description` no longer removes newlines.
  * `#name` must be a String.
  * FIXME and TODO are no longer allowed in various fields.
  * Added support for a license attribute.  Feature #11041 (partial).
  * Removed Gem::Specification::list, too much process growth.  Bug #23668 by
    Steve Purcell.
* `gem generate_index`
  * Can now generate an RSS feed.
  * Modern indices can now be updated incrementally.
  * Legacy indices can be updated separately from modern.

### Bug fixes:

* Better gem activation error message. Patch #23082.
* Kernel methods are now private.  Patch #20801 by James M. Lawrence.
* Fixed various usability issues with `gem check`.
* `gem update` now rescues InstallError and continues.  Bug #19268 by Gabriel
  Wilkins.
* Allow 'https', 'file' as a valid schemes for --source.  Patch #22485.
* `gem install`
  * Now removes existing path before installing.  Bug #22837.
  * Uses Gem::bin_path in executable stubs to work around Kernel#load bug in
    1.9.
  * Correctly handle build args (after --) via the API.  Bug #23210.
* --user-install
  * `gem install --no-user-install` now works.  Patch #23573 by Alf Mikula.
  * `gem uninstall` can now uninstall from ~/.gem.  Bug #23760 by Roger Pack.
* setup.rb
  * Clarify RubyGems RDoc installation location.  Bug #22656 by Gian Marco
    Gherardi.
  * Allow setup to run from read-only location.  Patch #21862 by Luis Herrera.
  * Fixed overwriting ruby executable when BASERUBY was not set.  Bug #24958
    by Michael Soulier.
  * Ensure we're in a RubyGems dir when installing.
  * Deal with extraneous quotation mark when autogenerating .bat file on MS
    Windows.  Bug #22712.

### Deprecations:

* Gem::manage_gems has been removed.
* Time::today will be removed in RubyGems 1.4.

Special thanks to Chad Wooley for backwards compatibility testing and Luis
Lavena and Daniel Berger for continuing windows support.

## 1.3.1 / 2008-10-28

### Bug fixes:

* Disregard ownership of ~ under Windows while creating ~/.gem.  Fixes
  issues related to no uid support under Windows.
* Fix requires for Gem::inflate, Gem::deflate, etc.
* Make Gem.dir respect :gemhome value from config.  (Note: this feature may be
  removed since it is hard to implement on 1.9.)
* Kernel methods are now private.  Patch #20801 by James M. Lawrence.
* Gem::location_of_caller now behaves on Windows.  Patch by Daniel Berger.
* Silence PATH warning.

### Deprecations:

* Gem::manage_gems will be removed on or after March 2009.

## 1.3.0 / 2008-09-25

### Features:

* RubyGems doesn't print LOCAL/REMOTE titles for `gem query` and friends if
  stdout is not a TTY, except with --both.
* Added Gem.find_files, allows a gem to discover features provided by other
  gems.
* Added pre/post (un)install hooks for packagers of RubyGems.  (Not for gems
  themselves).
* RubyGems now installs gems into ~/.gem if GEM_HOME is not writable.  Use
  --no-user-install command-line switch to disable this behavior.
* Fetching specs for update now uses If-Modified-Since requests.
* RubyGems now updates the ri cache when the rdoc gem is installed and
  documentation is generated.

### Deprecations:

* Gem::manage_gems now warns when called.  It will be removed on or after March
  2009.

### Bug fixes:

* RubyGems 1.3.0+ now updates when no previous rubygems-update is installed.
  Bug #20775 by Hemant Kumar.
* RubyGems now uses the regexp we already have for `gem list --installed`.  Bug
  #20876 by Nick Hoffman.
* Platform is now forced to Gem::Platform::RUBY when nil or blank in the
  indexer.  Fixes various uninstallable gems.
* Handle EINVAL on seek.  Based on patch in bug #20791 by Neil Wilson.
* Fix HTTPS support.  Patch #21072 by Alex Arnell.
* RubyGems now loads all cache files even if latest has been loaded.  Bug
  #20776 by Uwe Kubosch.
* RubyGems checks for support of development dependencies for #to_ruby.  Bug
  #20778 by Evan Weaver.
* Now specifications from the future can be loaded.
* Binary script uninstallation fixed.  Bug #21234 by Neil Wilson.
* Uninstallation with -i fixed.  Bug #20812 by John Clayton.
* Gem::Uninstaller#remove_all now calls Gem::Uninstaller#uninstall_gem so hooks
  get called.  Bug #21242 by Neil Wilson.
* Gem.ruby now properly escaped on windows.  Fixes problem with extension
  compilation.
* `gem lock --strict` works again.  Patch #21814 by Sven Engelhardt.
* Platform detection for Solaris was improved.  Patch #21911 by Bob Remeika.

### Enhancements:

* `gem help install` now describes _version_ argument to executable stubs
* `gem help environment` describes environment variables and ~/.gemrc and
  /etc/gemrc
* On-disk gemspecs are now read in UTF-8 and written with a UTF-8 magic comment
* Rakefile
  * If the SETUP_OPTIONS environment variable is set, pass its contents as
    arguments to setup.rb
* lib/rubygems/platform.rb
  * Remove deprecated constant warnings and really deprecate them.  (WIN32,
    etc).
* lib/rubygems/remote_fetcher.rb
  * Now uses ~/.gem/cache if the cache dir in GEM_HOME is not writable.
* lib/rubygems/source_index.rb
  * Deprecate options to 'search' other than Gem::Dependency instances and
    issue warning until November 2008.
* setup.rb
  * --destdir folder structure now built using Pathname, so it works for
    Windows platforms.
* test/*
  * Fixes to run tests when under test/rubygems/.  Patch by Yusuke ENDOH
    [ruby-core:17353].
* test/test_ext_configure_builder.rb
  * Locale-free patch by Yusuke Endoh [ruby-core:17444].

## 1.2.0 / 2008-06-21

### Features:

* RubyGems no longer performs bulk updates and instead only fetches the gemspec
  files it needs.  Alternate sources will need to upgrade to RubyGems 1.2 to
  allow RubyGems to take advantage of the new metadata updater.  If a pre 1.2
  remote source is in the sources list, RubyGems will revert to the bulk update
  code for compatibility.
* RubyGems now has runtime and development dependency types.  Use
  #add_development_dependency and #add_runtime_dependency.  All typeless
  dependencies are considered to be runtime dependencies.
* RubyGems will now require rubygems/defaults/operating_system.rb and
  rubygems/defaults/#{RBX_ENGINE}.rb if they exist.  This allows packagers and
  ruby implementers to add custom behavior to RubyGems via these files.  (If
  the RubyGems API is insufficient, please suggest improvements via the
  RubyGems list.)
* /etc/gemrc (and windows equivalent) for global settings
* setup.rb now handles --vendor and --destdir for packagers
* `gem stale` command that lists gems by last access time

### Bug fixes:

* File modes from gems are now honored, patch #19737
* Marshal Gem::Specification objects from the future can now be loaded.
* A trailing / is now added to remote sources when missing, bug #20134
* Gems with legacy platforms will now be correctly uninstalled, patch #19877
* `gem install --no-wrappers` followed by `gem install --wrappers` no longer
  overwrites executables
* `gem pristine` now forces reinstallation of gems, bug #20387
* RubyGems gracefully handles ^C while loading .gemspec files from disk, bug
  #20523
* Paths are expanded in more places, bug #19317, bug #19896
* Gem::DependencyInstaller resets installed gems every install, bug #19444
* Gem.default_path is now honored if GEM_PATH is not set, patch #19502

### Enhancements:

* setup.rb
  * stub files created by RubyGems 0.7.x and older are no longer removed.  When
    upgrading from these ancient versions, upgrade to 1.1.x first to clean up
    stubs.
  * RDoc is no longer required until necessary, patch #20414
* `gem server`
  * Now completely matches the output of `gem generate_index` and
    has correct content types
  * Refreshes from source directories for every hit.  The server will no longer
    need to be restarted after installing gems.
* `gem query --details` and friends now display author, homepage, rubyforge url
  and installed location
* `gem install` without -i no longer reinstalls dependencies if they are in
  GEM_PATH but not in GEM_HOME
* Gem::RemoteFetcher now performs persistent connections for HEAD requests,
  bug #7973

## 1.1.1 / 2008-04-11

### Bug fixes:

* Gem.prefix now returns non-nil only when RubyGems was installed outside
  sitelibdir or libdir.
* The `gem server` gem list now correctly links to gem details.
* `gem update --system` now passes --no-format-executable to setup.rb.
* Gem::SourceIndex#refresh! now works with multiple gem repositories.
* Downloaded gems now go into --install-dir's cache directory.
* Various fixes to downloading gem metadata.
* `gem install --force` now ignores network errors too.
* `gem pristine` now rebuilds extensions.
* `gem update --system` now works on virgin Apple ruby.
* Gem::RemoteFetcher handles Errno::ECONNABORTED.
* Printing of release notes fixed.

## 1.1.0 / 2008-03-29

### Features:

* RubyGems now uses persistent connections on index updates.  Index updates are
  much faster now.
* RubyGems only updates from a latest index by default, cutting candidate gems
  for updates to roughly 1/4 (at present).  Index updates are even faster
  still.
  * `gem list -r` may only show the latest version of a gem, add --all to see
    all gems.
* `gem spec` now extracts specifications from .gem files.
* `gem query --installed` to aid automation of checking for gems.

### Bug fixes:

* RubyGems works with both Config and RbConfig now.
* Executables are now cleaned upon uninstall.
* You can now uninstall from a particular directory.
* Updating from non-default sources fixed.
* Executable stubs now use ruby install name in shebang.
* `gem unpack` checks every directory in Gem.path now.
* `gem install` now exits with non-zero exit code when appropriate.
* `gem update` only updates gems that need updates.
* `gem update` doesn't force remote-only updates.
* `gem update` handles dependencies properly when updating.
* Gems are now loaded in Gem.path order.
* Gem stub scripts on windows now work outside Gem.bindir.
* `gem sources -r` now works without network access.

### Enhancements:

* RubyGems now requires Ruby > 1.8.3.
* Release notes are now printed upon installation.
* `gem env path` now prints a usable path.
* `gem install` reverts to local-only installation upon network error.
* Tar handling code refactoring and cleanup.
* Gem::DependencyInstaller's API has changed.

For a full list of changes to RubyGems, see the git log.

## 1.0.1 / 2007-12-20

### Bug fixes:

* Installation on Ruby 1.8.3 through 1.8.5 fixed
* `gem build` on 1.8.3 fixed

### Enhancements:

* Since RubyGems 0.9.5, RubyGems is no longer supported on Ruby 1.8.2 or older,
  this is official in RubyGems 1.0.1.

## 1.0.0 / 2007-12-20

### Features:

* RubyGems warns about various problems with gemspecs during gem building
* More-consistent versioning for the RubyGems software

### Enhancements:

* Fixed various bugs and problems with installing gems on Windows
* Fixed using `gem server` for installing gems
* Various operations are even more verbose with --verbose
* Built gems are now backwards compatible with 0.9.4
* Improved detection of RUBYOPT loading rubygems
* `ruby setup.rb` now has a --help option
* Gem::Specification#bindir is now respected on installation
* Executable stubs can now be installed to match ruby's name, so if ruby is
  installed as 'ruby18', foo_exec will be installed as 'foo_exec18'
* `gem unpack` can now unpack into a specific directory with --target
* OpenSSL is no longer required by default

### Breaking changes:

* Kernel#require_gem has been removed
* Executables without a shebang will not be wrapped in a future version, this
  may cause such executables to fail to operate on installation
* Gem::Platform constants other than RUBY and CURRENT have been removed
* Gem::RemoteInstaller was removed
* Gem::Specification#test_suite_file and #test_suite_file= are deprecated in
  favor of #test_file and #test_file=
* Gem::Specification#autorequire= has been deprecated
* Time::today will be removed in a future version

## 0.9.5 / 2007-11-19

### Features:

* Platform support
* Automatic installation of platform gems
* New bandwidth and memory friendlier index file format
* "Offline" mode (--no-update-sources)
* Bulk update threshold can be specified (-B, --bulk-threshold)
* New `gem fetch` command
* `gem` now has "really verbose" output when you specify -v
* Improved stubs and `gem.bat` on mswin, including better compatibility
  with the One-Click Installer.

### Enhancements:

* Time::today is deprecated and will be removed at a future date
* Gem::manage_gems is deprecated and will be removed at a future date
* `gem install --include-dependencies` (-y) is now deprecated since it is the
  default, use --ignore-dependencies to turn off automatic dependency
  installation
* Multi-version diamond dependencies only are installed once
* Processing a YAML bulk index update takes less memory
* `gem install -i` makes sure all dependencies are installed
* `gem update --system` reinstalls into the prefix it was originally installed
  in
* `gem update --system` respects --no-rdoc and --no-ri flags
* HTTP basic authentication support for proxies
* Gem::Specification#platforms should no longer be a String, use
  Gem::Platform::CURRENT when building binary gems instead
* `gem env` has more diagnostic information
* require 'rubygems' loads less code
* sources.gem is gone, RubyGems now uses built-in defaults
* `gem install --source` will no longer add --source by default, use `gem
  sources --add` to make it a permanent extra source
* `gem query` (list) no longer prints details by default
* Exact gem names are matched in various places
* mkrf extensions are now supported
* A gem can depend on a specific RubyGems version
* `gem_server` is now `gem server`
* `gemlock` is now `gem lock`
* `gem_mirror` is now `gem mirror`
* `gemwhich` is now `gem which`
* `gemri` is no longer included with RubyGems
* `index_gem_repository.rb` is now `gem generate_index`
* `gem` performs more validation of parameters
* Custom rdoc styles are now supported
* Gem indexer no longer removes quick index during index creation
* Kernel#require only rescues a LoadError for the file being required now
* `gem dependencies` can now display some information for remote gems
* Updating RubyGems now works with RUBYOPT=-rubygems

Special thanks to:

* Daniel Berger
* Luis Lavena
* Tom Copeland
* Wilson Bilkovich

## 0.9.4 / 2007-05-23

If you are experiencing problems with the source index (e.g. strange
"No Method" errors), or problems with zlib (e.g. "Buffer Error"
message), we recommend upgrading to RubyGems 0.9.4.

### Bug fixes:

* Several people have been experiencing problems with no method errors
  on the source index cache.  The source index cache is now a bit more
  self healing.  Furthermore, if the source index cache is
  irreparable, then it is automatically dropped and reloaded.
* The source cache files may now be dropped with the "gem sources
  --clear-all" command.  (This command may require root is the system
  source cache is in a root protected area).
* Several sub-commands were accidentally dropped from the "gem" command.
  These commands have been restored.

## 0.9.3 / 2007-05-10

### Bug fixes:

The ZLib library on Windows will occasionally complains about a buffer error
when unpacking gems.  The Gems software has a workaround for that problem, but
the workaround was only enabled for versions of ZLib 1.2.1 or earlier.  We
have received several reports of the error occurring with ZLib 1.2.3, so we
have permanently enabled the work around on all versions.

## 0.9.2 / 2007-02-05

### Bug fixes:

* The "unpack" command now works properly.
* User name and password are now passed properly to the authenticating
  proxy when downloading gems.

## 0.9.1 / 2007-01-16

See git log

## 0.9.0 / 2006-06-28

Finally, the much anticipated RubyGems version 0.9.0 is now available.
This release includes a number of new features and bug fixes.  The
number one change is that we can now download the gem index
incrementally.  This will greatly speed up the gem command when only a
few gems are out of date.

### Enhancements:

* The gem index is now downloaded incrementally, only updating entries
  that are out of date.  If more than 50 entries are out of date, we
  revert back to a bulk download.
* Several patches related to allowing RubyGems to work with
  authenticating proxies (from Danie Roux and Anatol Pomozov).  Just
  put the user and password in the proxy URL (e.g. -p
  http://user:password@proxy.address.com:8080) or use the
  HTTP_PROXY_USER and HTTP_PROXY_PASS environment variables.
* The gem unpack command can now accept a file path rather than just a
  install gem name.
* Both RI and RDOC documents are now generated by default.
* A gemri command is included to read gem RI docs (only needed for
  Ruby 1.8.4 or earlier).
* Version 0.0.0 is now a valid gem version.
* Better detection of missing SSL functionality.
* SSL is not required if the security policy does not require
  signature checking.
* Rake built extensions are now supported (Tilman Sauerbeck).
* Several autorequire bug fixes.
* --traceback is now an alias for --backtrace (I can never remember
  which one it is).
* SAFE=1 compatibility fixes.
* .rbw is now a supported suffix for RubyGem's custom require.
* Several Ruby 1.9 compatibility fixes (Eric Hodel).

### Bug fixes:

* Added dashes to gemspecs generated in Ruby 1.8.3.  This solves some
  cross-Ruby version compatibility issues.
* Fixed bug where the wrong executables could be uninstalled (Eric
  Hodel).
* Fixed bug where gem unpack occasionally unpacked the wrong gem.
* Fixed bug where a fatal error occurred when permissions on .gemrc
  were too restrictive (reported by Luca Pireddu).
* Fixed prefix handling for native expressions (patch by Aaron Patterson).
* Fixed several Upgrade => Update typos.

## 0.8.11 / 2005-07-13

* -y is a synonym for --include-dependencies.
* Better handling of errors in the top level rescue clause.
* Package list command (e.g. gem inspect GEM).
* .gemrc now allows cvsrc-like options to set defaults per subcommand.
* The autorequire gem spec field will now accept a list.
* Substituted Time for Date in specs, increasing performance
  dramatically.
* Fixed reported bug of gem directories ending in "-" (reported by
  Erik Hatcher).
* Fixed but in installer that caused dependency installation to not
  work.
* Added Paul Duncan's gem signing patch.
* Added Mark Hubbart's Framework patch (for better integration with OS
  X).
* Added David Glasser's install-from-mirror patch.
* Additional internal structural cleanup and test reorganization.

## 0.8.10 / 2005-03-27

* In multi-user environments, it is common to supply multiple versions of gems
  (for example Rails), allowing individual users to select the version of the
  gem they desire.  This allows a user to be insulated from updates to that
  gem.  RubyGems 0.8.10 fixes a problem where gems could occasionally become
  confused about the current versions of libraries selected by the user.
* The other annoying bug is that if there are any existing rubygems-update gems
  installed, then the "gem update --system" command will download a new
  update, but install the latest update prior to the download.

## 0.8.9

Never released

## 0.8.8 / 2005-03-14

* Moved the master definition of class Requirement back under version.
  Kept the body of Requirement under Gem.

## 0.8.7 / 2005-03-14

Even though it has only been a few weeks since that last release,
there are quite a number of new features in 0.8.7.  A complete list of
new features will be given below, but here is a summary of the hot
items.

* The bug that prevented some users from installing rails has been
  squashed.  A big thanks to Bill Guindon (aGorilla) for helping track
  that one down.

There are several new commands available on the gem command:

* gem cleanup GEMNAME -- Cleanup (uninstall) all the old versions of
  gem.  If the gem name is omitted, the entire repository is cleaned.
* gem dependency GEMNAME -- Show the dependencies for the named gems.
  This is really helpful when trying to figure out what gem needs what
  other gem.

There changes to the existing commands as well.

* gem uninstall is much smarter about removing gems from the
  repository.  Lists of gems are now uninstalled in proper dependency
  order (ie. if A depends on B, A is uninstalled first).  Also,
  warnings about broken dependencies occur only when removing the
  *last* gem that supports a dependency is removed.

Both gem install and gem uninstall support some new command line
options that can reduce the amount of yes/no queries given the user.
For install we have:

* --ignore-dependencies -- Only install requests gems, no
  dependendecies are automatically installed.
* --include-dependencies -- Automatically install dependencies,
  without confirmation.

For gem uninstall, the new options are:

* --all -- Uninstall all matching gems without confirmation.
* --ignore-dependencies -- Uninstall, even if dependencies are broken.
* --executables -- Remove executables without confirmation

Under general cleanup, gems will not, by default, run RDoc on packages
that do not have the RDoc flag set.

And finally there is a new library file 'gemconfigure' to aid in
writing version sensitive applications (without undue dependencies on
RubyGems); and 'gemwhich', a short script to locate libraries in the
file system.  You can read more about them here:

* gemconfigure: http://docs.rubygems.org/read/chapter/4#page73
* gemwhich: http://docs.rubygems.org/read/chapter/17

## 0.8.6 / 2005-02-27

* Fixed a small bug with shebang construction

## 0.8.5 / 2005-02-26

Do you know how you used to dread getting the following message while
installing gems?

  Updating Gem source index for: http://gems.rubyforge.org

It could take up to 30 seconds (on my machine, even worse on others) for
that crazy source index to update.

This latest release of RubyGems speeds that wait time up considerably.
The following table gives the following times for installing RedCloth
with a required source index update on three system we had available to
us.  No RDoc generation was included in the following times.

  RubyGems    Linux         Mac OSX      Windows
  0.8.4       33 secs       73 secs      58 secs
  0.8.5        8 secs       14 secs      21 secs

The new caching code is at least 3x faster than previous versions.  Woo
Hoo!

## 0.8.4 / 2005-01-01

* Rubygems 0.8.3's installer was broken unless you already had an older
  version of RubyGems installed.  That's fixed.
* Change in the way Gem::Specification internally deals with lazy attributes
  and defaults, bringing (with some loadpath_manager changes) a fairly
  significant increase in speed.
* Support for lower-cased Gem file names (for you, Paul Duncan :)
* Erik Veenstra's patch for making Gem versions sortable.

## 0.8.3 / 2004-12-07

No real earth shattering news here, but there were a number of really
annoying issues involving other libraries that RubyGems depends upon.
0.8.3 contains some workarounds for these issues.  In particular:

* Added workaround for the null byte in Dir string issue. (see
  https://blade.ruby-lang.org/ruby-talk/121702).
  (Thanks to Mauricio Fernández for the quick response on this one).
* Added workaround for old version of Zlib on windows that caused
  Ruwiki to fail to install. (see
  https://blade.ruby-lang.org/ruby-talk/121770)
* Added workaround for large YAML file issues.  (We dynamically cut
  down the size of the source index YAML file and seem to have worked
  around immediate issues.

There has been some minor usability enhancements and changes ...

* A user specific source index cache can be used when the site-wide
  cache is unwritable (i.e. because you are running as a non-admin).
  This *greatly* speeds up gem commands run in non-admin mode when the
  site-wide cache is out of date.
* The gem command now used an HTTP HEAD command to detect if the
  server's source index needs to be downloaded.
* gem check gemname --test will run unit tests on installed gems that
  have unit tests.
* Multiple gem names are allowed on the gem install command line.
  This means you can do:

    gem install rake rails needle postgres-pr pimki

  (Ok, you get the idea)
* Multiple authors my be specified in a Gem spec.
* Switched to using setup.rb (rather than a custom install script) for
  the installation of RubyGems itself.  If you have installed RubyGems
  before, double check the installation instructions and make sure you
  use setup.rb instead of install.rb.
* Ryan Davis has provided a patch so you can use an env variable
  (GEM_SKIP), to tell loadpath_manager not to load gems of those
  names.  This was useful for him while testing libs that he had in
  development.

## 0.8.1 / 2004-09-17

* Quick release to capture some bug fixes.

## 0.8.0 / 2004-09-15

* Remove need for library stubs.  Set the RUBYOPT environment variable to
  include "rrubygems", and a normal require will find gem files.  Continue to
  use 'require_gem gem_name, version' to specify gem versions.
* Deprecated "test_suite_file" gemspec attribute in favor of "test_files" array.
* Generates rdoc by default on installs.
* Adopted tar/gzip file format, thanks to Mauricio Fernandez.
* "gem rdoc" allows generation of rdoc after gem installation (will add a "gem
  test"
* Application stubs can now accept an optional parameter of _VERSION_ that will
  run an arbitrary version of the application requested.
* Various bug fixes
* Various platform-independency improvements
* "gem spec --all" displays spec info for all installed version of a given gem.
* Dynamic caching of sources
* Support for user-definable sources on the command line (thanks Assaph Mehr)
* More intelligent support for platform-dependent gems.  Use Platform::CURRENT
  when building a gem to set its platform to the one you're building on.
  Installation displays a choice of platform-dependent gems, allowing the user
  to pick.
* Added "gem unpack" for "unpacking" a gem to the current directory

## 0.7.0 / 2004-07-09

See git log

## 0.6.1 / 2004-06-08

See git log

## 0.6.0 / 2004-06-08

* Collapse output of --search and --list (and gem_server) operations so that
  each gem is listed only once, with each of its versions listed on the same
  line.
* bin/gem: new --upgrade-all option allows one to upgrade every installed gem
* new #required_ruby_version attribute added to gem specification for
  specifying a dependency on which version of ruby the gem needs.  Format it
  accepts is the same as the Gem::Version::Requirement format:

    spec.required_ruby_version = "> 1.8.0"
* --install-stub defaults to true, so library stubs are created

## 0.5.0 / 2004-06-06

* Jim added the ability to specify version constraints to avoid API
  incompatibilities.  This has been the subject of much debate for the past
  couple of months, with many ideas and code contributed by Eivind Eklund and
  Mauricio Fernandez.  The following set of assertions shows how it works:

    assert_inadequate("1.3", "~> 1.4")
    assert_adequate(  "1.4", "~> 1.4")
    assert_adequate(  "1.5", "~> 1.4")
    assert_inadequate("2.0", "~> 1.4") # This one is key--the new operator
				       # disallows major version number
				       # differences.
* Group gem search output when multiple versions exist for a given gem:

    activerecord (0.7.8, 0.7.7, 0.7.6, 0.7.5)
      Implements the ActiveRecord pattern for ORM.
* Add arbitrary RDoc-able files via gemspec (not just Ruby source files) for
  people who have, for example, README.rdoc in their distributions.  Add to
  gemspec via: spec.extra_rdoc_files = ["list", "of", "files"].  Ruby files are
  automatically included.
* Some small bug fixes

## 0.4.0 / 2004-05-30

* Minor bug fixes including Windows compatibility issues

## 0.3.0 / 2004-04-30

* Cleanup of command-line arguments and handling.  Most commands accept a
  --local or --remote modifier.
* Creation of Application Gems (packages that include executable programs).
  See http://rubygems.rubyforge.org/wiki/wiki.pl?DeveloperGuide for information
  on how to use it.
* Basic functionality for installing binary gems from source (:extensions
  property of gem specification holds an array of paths to extconf.rb files to
  be used for compilation)
* Install library "stub" allowing a normal 'require' to work (which then does
  the rubygems require and 'require_gem'
* --run-tests runs the test suite specified by the "test_suite_file" property
  of a gem specification
* HTTP Proxy support works.  Rewrite of HTTP code.
* Unit and functional tests added (see Rakefile).
* Prompt before remote-installing dependencies during gem installation.
* Config file for storing preferences for 'gem' command usage.
* Generally improved error messages (still more work to do)
* Rearranged gem directory structure for cleanliness.

## 0.2.0 / 2004-03-14

* Initial public release
