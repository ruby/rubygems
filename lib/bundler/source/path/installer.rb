# frozen_string_literal: true

require_relative "../../rubygems_gem_installer"
require_relative "../../vendored_fileutils"

module Bundler
  class Source
    class Path
      class Installer < Bundler::RubyGemsGemInstaller
        attr_reader :spec

        def initialize(spec, options = {})
          @options            = options
          @spec               = spec
          @gem_dir            = Bundler.rubygems.path(spec.full_gem_path)
          @wrappers           = true
          @env_shebang        = true
          @format_executable  = options[:format_executable] || false
          @build_args         = options[:build_args] || Bundler.rubygems.build_args
          @gem_bin_dir        = "#{Bundler.rubygems.gem_dir}/bin"
          @disable_extensions = options[:disable_extensions]
          @extension_build_dir = options[:extension_build_dir]
          @bin_dir = @gem_bin_dir
        end

        def post_install
          run_hooks(:pre_install)

          unless @disable_extensions || Bundler.settings[:no_build_extension]
            build_extensions
            run_hooks(:post_build)
          end

          generate_bin unless spec.executables.empty?

          run_hooks(:post_install)
        end

        def build_extensions
          return super unless @extension_build_dir

          stage_extension_sources

          real_spec = @spec
          @spec = staged_spec(real_spec)
          begin
            super
          ensure
            @spec = real_spec
            FileUtils.rm_rf(@extension_build_dir)
          end
        end

        private

        def stage_extension_sources
          SharedHelpers.filesystem_access(@extension_build_dir, :create) do |path|
            FileUtils.rm_rf(path)
            FileUtils.mkdir_p(path)
            FileUtils.cp_r(stage_extension_source_entries, path)
          end
        end

        def stage_extension_source_entries
          source_root = Pathname(@spec.full_gem_path)
          destination = Pathname(@extension_build_dir)

          entries = source_root.children(false).map {|entry| source_root.join(entry).to_s }
          return entries unless destination.to_s.start_with?(source_root.to_s + File::SEPARATOR)

          relative_destination = destination.relative_path_from(source_root)
          nested_entry = source_root.join(relative_destination.each_filename.first).to_s
          entries.reject {|entry| entry == nested_entry }
        end

        def staged_spec(spec)
          staged = spec.dup
          staged.source = nil
          staged.full_gem_path = @extension_build_dir
          staged.extension_dir = spec.extension_dir
          staged
        end

        def run_hooks(type)
          hooks_meth = "#{type}_hooks"
          return unless Gem.respond_to?(hooks_meth)
          Gem.send(hooks_meth).each do |hook|
            result = hook.call(self)
            next unless result == false
            location = " at #{$1}" if hook.inspect =~ /@(.*:\d+)/
            message = "#{type} hook#{location} failed for #{spec.full_name}"
            raise InstallHookError, message
          end
        end
      end
    end
  end
end
