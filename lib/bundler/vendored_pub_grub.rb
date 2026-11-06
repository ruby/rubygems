# frozen_string_literal: true

# Reuse RubyGems' vendored PubGrub (Gem::PubGrub). The Bundler gem ships a copy
# under lib/rubygems/vendor, so this resolves even on RubyGems versions that
# predate it.

require "rubygems/vendor/pub_grub/lib/pub_grub"

# Bundler used to ship its own copy as Bundler::PubGrub. Keep that name as a
# deprecated alias of the RubyGems copy for code written against it.
module Bundler
  unless const_defined?(:PubGrub, false)
    PubGrub = Gem::PubGrub
    deprecate_constant :PubGrub
  end
end
