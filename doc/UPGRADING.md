# How to upgrade/downgrade RubyGems and Bundler:

## Upgrade Recipe

    $ gem update --system

    $ gem install bundler
    $ bundle update --bundler

## Downgrade Recipe

    $ gem update --system 4.0.24

    $ gem install bundler -v 4.0.24
    $ bundle update --bundler=4.0.24

## Install a pre-release version

    $ gem update --system --pre

    $ gem install bundler --pre
    $ bundle update --bundler=4.1.0.beta3

## Install from source

*   Download from: https://rubygems.org/pages/download
*   Unpack into a directory and `cd` there
*   Install with: `ruby setup.rb`

## What changed in 4.1

RubyGems and Bundler 4.1 share more code than before, so a few things behave
differently after an upgrade. `CHANGELOG.md` lists every change; the ones most
likely to need attention are:

*   `gem install` and `gem update` resolve dependencies with PubGrub, the
    resolver Bundler already used, instead of Molinillo.
*   `gem` commands read the compact index when the source provides it, and
    fall back to the Marshal spec indexes otherwise.
*   Gem metadata and configuration are parsed with a pure Ruby YAML parser
    instead of Psych. Set `RUBYGEMS_USE_PSYCH=true` (or `:use_psych: true` in
    `.gemrc`) to switch back to Psych.
*   The Gemfile accepts an `override` directive that rewrites a gem's version,
    `required_ruby_version` or `required_rubygems_version` constraint before
    resolution. Overrides are recorded in a new `OVERRIDES` section of
    `Gemfile.lock`, so a lockfile that uses them needs Bundler 4.1 or later.
    See `bundle help gemfile` for the details.
*   A global gem cache shared by RubyGems and Bundler is available as an
    opt-in: `:global_gem_cache: true` in `.gemrc` or
    `RUBYGEMS_GLOBAL_GEM_CACHE=true` for `gem`, and `bundle config set
    global_gem_cache true` for Bundler. Cached `.gem` files live under
    `~/.cache/gem/gems` (or `$XDG_CACHE_HOME/gem/gems`).
*   A cooldown keeps freshly published gem versions out of resolution for a
    number of days. `gem install`, `gem update` and `gem outdated` accept
    `--cooldown`, `.gemrc` accepts `:cooldown:`, and Bundler has a `cooldown`
    setting plus a per-source `cooldown:` Gemfile option. A cooldown configured
    for either tool is honored by both.
*   `gem cert --build` can create ML-DSA keys (`--key-algorithm ML-DSA-44`,
    `ML-DSA-65` or `ML-DSA-87`) for signing gems. Using them needs OpenSSL 3.5
    or later, or another SSL library that supports ML-DSA.
*   An experimental, opt-in credential store keeps `gem` and Bundler
    credentials in the operating system's native store (macOS Keychain, Linux
    Secret Service, Windows Credential Manager) instead of plain text files:
    `:credential_store: true` in `.gemrc` or `RUBYGEMS_CREDENTIAL_STORE=true`
    for `gem`, and `bundle config set credential_store true` for Bundler.
*   Bundler plugins can hook into Gemfile evaluation and source fetching. See
    `bundle help plugin`.
*   The `patchlevel:` option of the Gemfile `ruby` directive is ignored. It is
    still accepted, but no longer checked against the running Ruby.
*   Bundler's `no_prune` setting is deprecated in favor of
    `keep_outdated_cache`, and a new `prune` setting controls which install
    artifacts are removed after `bundle install`.
*   `bundle env` no longer reports the versions of external tools such as Git.
*   `Gem::BasicSpecification#datadir` was removed, and native extension build
    logs (`gem_make.out`) are no longer installed with the gem.
*   Bundler no longer ships its own copies of the libraries RubyGems also
    vendors. Code that referenced `Bundler::URI`, `Bundler::PubGrub`,
    `Bundler::SecureRandom`, `Bundler::CompactIndexClient` or
    `Bundler::YAMLSerializer` should use `Gem::URI`, `Gem::PubGrub`,
    `Gem::SecureRandom`, `Gem::CompactIndexClient` and `Gem::YAMLSerializer`
    instead.
    `Bundler::ConnectionPool` and `Bundler::Persistent` (the vendored
    `net-http-persistent`) were removed without a replacement, since Bundler
    now fetches through `Gem::Request`.
*   For contributors: the `bundler/` subdirectory of this repository is gone.
    Bundler's sources live in `lib/bundler`, its specs in `spec`, and
    `bundler.gemspec` sits at the top level next to `rubygems-update.gemspec`.
