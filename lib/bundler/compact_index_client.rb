# frozen_string_literal: true

# Bundler::CompactIndexClient was replaced by Gem::CompactIndexClient, which the
# Bundler gem ships a copy of under lib/rubygems. Keep the old name as a
# deprecated alias for code written against it.

require "rubygems/compact_index_client"

module Bundler
  unless const_defined?(:CompactIndexClient, false)
    CompactIndexClient = Gem::CompactIndexClient
    deprecate_constant :CompactIndexClient
  end
end
