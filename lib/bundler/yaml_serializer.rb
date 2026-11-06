# frozen_string_literal: true

# Bundler::YAMLSerializer was replaced by Gem::YAMLSerializer, which the Bundler
# gem ships a copy of under lib/rubygems. Keep the old name as a deprecated
# alias for code written against it.

require "rubygems/yaml_serializer"

module Bundler
  unless const_defined?(:YAMLSerializer, false)
    YAMLSerializer = Gem::YAMLSerializer
    deprecate_constant :YAMLSerializer
  end
end
