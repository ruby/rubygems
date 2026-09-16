#!/usr/bin/env ruby
# frozen_string_literal: true

require "rubygems"
require "bundler"
require "find"
require "fileutils"

VendoredGem = Struct.new(:name, :extra_dependencies, :namespace, :prefix, :vendor_lib, :license_path, :patch_name, :require_target, :skip_dependencies, keyword_init: true) do
  def vendor(spec)
    raise "#{name} missing license #{license_path.inspect}" unless File.file? File.join(spec.full_gem_path, license_path)
    FileUtils.rm_rf(vendor_lib)
    FileUtils.mkdir_p(File.dirname(vendor_lib))
    FileUtils.cp_r(spec.full_gem_path, vendor_lib)
    namespace_files(vendor_lib)

    clean

    raise "#{name} missing license #{license_path.inspect}" unless File.file? File.join(vendor_lib, license_path)
  end

  def namespace_files(folder)
    files = Dir.glob("#{folder}/**/*.rb")

    files.each do |file|
      contents = File.read(file)
      contents = namespace_file(file, contents, namespace)
      File.write(file, contents)
    end
  end

  def namespace_file(file, contents, namespace)
    contents.gsub!(/module Kernel/, "module #{prefix}")
    contents.gsub!(/#{prefix}::#{namespace}::/, "#{namespace}::")
    contents.gsub!(/#{namespace}::/, "#{prefix}::#{namespace}::")
    contents.gsub!(/(\s)::#{namespace}/, '\1' + "::#{prefix}::#{namespace}")
    contents.gsub!(/(?<!\w|def |:)#{namespace}\b/, "#{prefix}::#{namespace}")

    contents.gsub!(/^(\s*)require (["'])#{Regexp.escape require_entrypoint}/, "\\1require_relative \\2#{relative_require_target_from(file)}")
    contents.gsub!(/require (["'])#{Regexp.escape require_entrypoint}/, "require \\1#{require_target}/#{require_entrypoint}")

    contents.gsub!(%r{(autoload\s+[:\w]+,\s+["'])(#{Regexp.escape require_entrypoint}[\w\/]+["'])}, "\\1#{require_target}/\\2")
    contents
  end

  def clean
    Find.find(vendor_lib) do |f|
      if File.directory?(f) && File.dirname(f) == vendor_lib && f != File.join(vendor_lib, "lib")
        FileUtils.rm_r f
      end
      next unless File.file?(f)
      next if f.end_with?(".rb")
      next if f == File.join(vendor_lib, license_path)
      FileUtils.rm_r f
    end
  end

  def apply_patch
    return unless patch_name

    system("git", "apply", "--verbose", File.join("tool", "automatiek", patch_name), exception: true)
  end

  def require_entrypoint
    @require_entrypoint ||= gem_name.tr("-", "/")
  end

  alias_method :gem_name, :name

  def relative_require_target_from(file, entrypoint = require_entrypoint)
    Pathname.new("#{vendor_lib}/lib/#{entrypoint}").relative_path_from(File.dirname(file))
  end

  def require_target
    @require_target ||= vendor_lib.sub(%r{^(.+?/)?lib/}, "") << "/lib"
  end
end

ignore = ["bundler"]

vendored_gems = [
  # RubyGems
  VendoredGem.new(name: "molinillo", namespace: "Molinillo", prefix: "Gem", vendor_lib: "lib/rubygems/vendor/molinillo", license_path: "LICENSE", extra_dependencies: %w[tsort/lib/rubygems/vendor/tsort], patch_name: "molinillo-master.patch"),
  VendoredGem.new(name: "net-http", namespace: "Net", prefix: "Gem", vendor_lib: "lib/rubygems/vendor/net-http", license_path: "COPYING", extra_dependencies: %w[net-protocol timeout uri/lib/rubygems/vendor/uri], skip_dependencies: %w[uri], patch_name: "net-http-v0.7.0.patch"),
  VendoredGem.new(name: "net-http-persistent", namespace: "Net::HTTP::Persistent", prefix: "Gem", vendor_lib: "bundler/lib/bundler/vendor/net-http-persistent", license_path: "README.rdoc", extra_dependencies: %w[net-http uri/lib/rubygems/vendor/uri], patch_name: "net-http-persistent-v4.0.6.patch"),
  VendoredGem.new(name: "net-protocol", namespace: "Net", prefix: "Gem", vendor_lib: "lib/rubygems/vendor/net-protocol", license_path: "LICENSE.txt"),
  VendoredGem.new(name: "optparse", namespace: "OptionParser", prefix: "Gem", vendor_lib: "lib/rubygems/vendor/optparse", license_path: "COPYING", extra_dependencies: %w[uri/lib/rubygems/vendor/uri], patch_name: "optparse-v0.8.0.patch"),
  VendoredGem.new(name: "securerandom", namespace: "SecureRandom", prefix: "Gem", vendor_lib: "lib/rubygems/vendor/securerandom", license_path: "COPYING"),
  VendoredGem.new(name: "timeout", namespace: "Timeout", prefix: "Gem", vendor_lib: "lib/rubygems/vendor/timeout", license_path: "COPYING", patch_name: "timeout-v0.4.3.patch"),
  VendoredGem.new(name: "tsort", namespace: "TSort", prefix: "Gem", vendor_lib: "lib/rubygems/vendor/tsort", license_path: "LICENSE.txt"),
  VendoredGem.new(name: "uri", namespace: "URI", prefix: "Gem", vendor_lib: "lib/rubygems/vendor/uri", license_path: "COPYING"),
  # Bundler
  VendoredGem.new(name: "connection_pool", namespace: "ConnectionPool", prefix: "Bundler", vendor_lib: "bundler/lib/bundler/vendor/connection_pool", license_path: "LICENSE", patch_name: "connection_pool-v2.4.1.patch", extra_dependencies: %w[timeout]),
  VendoredGem.new(name: "fileutils", namespace: "FileUtils", prefix: "Bundler", vendor_lib: "bundler/lib/bundler/vendor/fileutils", license_path: "COPYING"),
  VendoredGem.new(name: "pub_grub", namespace: "PubGrub", prefix: "Bundler", vendor_lib: "bundler/lib/bundler/vendor/pub_grub", license_path: "LICENSE.txt"),
  VendoredGem.new(name: "thor", namespace: "Thor", prefix: "Bundler", vendor_lib: "bundler/lib/bundler/vendor/thor", license_path: "LICENSE.md", patch_name: "thor-v1.4.0.patch"),
  VendoredGem.new(name: "uri", namespace: "URI", prefix: "Bundler", vendor_lib: "bundler/lib/bundler/vendor/uri", license_path: "COPYING"),
  VendoredGem.new(name: "securerandom", namespace: "SecureRandom", prefix: "Bundler", vendor_lib: "bundler/lib/bundler/vendor/securerandom", license_path: "COPYING"),
].group_by(&:name)

Bundler.definition.resolve.materialized_for_all_platforms.reject {|s| ignore.include?(s.name) }.each do |s|
  raise "Vendoring default gem #{s.full_name} doesn't work..." if s.default_gem?

  vendored_gems.fetch(s.name)&.each do |vg|
    vg.vendor(s)
  end
end.each do |s|
  vendored_gems.fetch(s.name)&.each do |vg|
    dep_names = s.runtime_dependencies.map(&:name).uniq
    vg.skip_dependencies&.each {|sd| dep_names.delete(sd) || raise("#{vg.name} does not depend on #{sd} so cannot skip it") }
    if vg.extra_dependencies && (dupes = vg.extra_dependencies & dep_names) && !dupes.empty?
      raise "Extra dependencies #{dupes.inspect} are already in the list of dependencies for #{vg.name}"
    end
    dep_names.concat vg.extra_dependencies if vg.extra_dependencies

    dep_names.each do |ed|
      ed, vl = ed.split("/", 2)
      deps = vendored_gems.fetch(ed)
      deps = deps.select {|d| d.vendor_lib == vl } if vl
      raise "#{vg.name} (in #{vg.namespace}) missing dep on #{ed}: #{deps.inspect}" unless deps.size == 1
      deps.first.namespace_files(vg.vendor_lib)
    end

    vg.apply_patch
  end
end
