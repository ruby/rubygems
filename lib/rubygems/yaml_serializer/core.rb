# frozen_string_literal: true

# Skip reloading when an identical copy (e.g. the one shipped inside the Bundler
# gem) was already required from a different path, to avoid redefinition warnings.
return if defined?(Gem::YAMLSerializer)

require_relative "psych_errors"
require_relative "nodes"
require_relative "parser"
require_relative "builder"
require_relative "emitter"

module Gem
  module YAMLSerializer
    module_function

    def dump(obj)
      Emitter.new.emit(obj)
    end

    def load(str, permitted_classes: [], permitted_symbols: [], aliases: true)
      ast = Parser.new(str).parse
      result = Builder.new(
        permitted_classes: permitted_classes,
        permitted_symbols: permitted_symbols,
        aliases: aliases
      ).build(ast)
      # Bundler 4.0 and older call Hash methods on what this returns for
      # .bundle/config, which is just "---" once its last key is unset, so
      # nil stays a Hash here as it did in RubyGems 4.0.
      result.nil? ? {} : result
    end
  end
end
