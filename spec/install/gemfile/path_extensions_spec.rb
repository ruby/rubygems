# frozen_string_literal: true

RSpec.describe "bundle install with path sources that have extensions" do
  before do
    build_lib "foo", "1.0", path: lib_path("foo") do |s|
      s.extensions = ["ext/extconf.rb"]
      s.write "ext/extconf.rb", <<-RUBY
        require "mkmf"
        create_makefile("foo_c")
      RUBY

      s.write "ext/foo.h", <<-C
        #define FOO_VALUE 1
      C

      s.write "ext/foo.c", <<-C
        #include "ruby.h"
        #include "foo.h"

        void Init_foo_c(void) {
          rb_define_global_const("FOO_C", INT2NUM(FOO_VALUE));
        }
      C

      s.write "lib/foo.rb", <<-RUBY
        require "foo_c"
      RUBY
    end
  end

  let(:gemfile_source) do
    <<-G
      source "https://gem.repo1"
      gem "foo", :path => "#{lib_path("foo")}"
    G
  end

  def extension_dirs
    Pathname.glob(default_bundle_path("bundler/gems/extensions/*/*/foo-1.0-*"))
  end

  # Everything the gem shipped with, so that specs can assert Bundler did not
  # leave a Makefile, an object file or a `.so` behind in the user's checkout.
  def checkout_files
    Pathname.glob(lib_path("foo/**/*")).select(&:file?).map do |file|
      file.relative_path_from(lib_path("foo")).to_s
    end.sort
  end

  it "does not build extensions by default" do
    pristine_checkout = checkout_files

    install_gemfile gemfile_source

    expect(extension_dirs).to be_empty
    expect(checkout_files).to eq(pristine_checkout)

    run "begin; require 'foo'; rescue LoadError => e; puts e.message; end"
    expect(out).to include("cannot load such file -- foo_c")
  end

  context "when path extension building is enabled" do
    before { bundle_config "build_path_extensions true" }

    it "prints output when building native extensions" do
      install_gemfile gemfile_source, verbose: true

      expect(out).to include("Using foo 1.0 from source at `#{lib_path("foo")}` with native extensions")
    end

    it "builds the extension and makes it requirable" do
      install_gemfile gemfile_source

      expect(extension_dirs.size).to eq(1)

      run "require 'foo'; puts FOO_C"
      expect(out).to eq("1")
    end

    it "builds out of tree, leaving the path gem's checkout untouched" do
      pristine_checkout = checkout_files

      install_gemfile gemfile_source

      expect(checkout_files).to eq(pristine_checkout)
    end

    it "builds path gems from the bundled app without recursing into the bundle path" do
      build_lib "app", "1.0", path: bundled_app do |s|
        s.extensions = ["ext/extconf.rb"]
        s.write "ext/extconf.rb", <<-RUBY
          require "mkmf"
          create_makefile("app_c")
        RUBY
        s.write "ext/app.c", <<-C
          #include "ruby.h"

          void Init_app_c(void) {}
        C
        s.write "lib/app.rb", "require 'app_c'"
      end

      bundle_config "path vendor/bundle"

      install_gemfile <<-G
        source "https://gem.repo1"
        gem "app", :path => "."
      G

      expect(bundled_app("vendor/bundle")).to be_directory

      recursively_copied_bundle_paths = Pathname.glob(
        bundled_app("vendor/bundle/**/path_extensions/**/vendor")
      )
      expect(recursively_copied_bundle_paths).to be_empty

      expect(Pathname.glob(vendored_gems("bundler/gems/extensions/*/*/app-1.0-*"))).to have_attributes(size: 1)

      run "require 'app'; puts 'ok'"
      expect(out).to eq("ok")
    end

    it "puts the build directory ahead of the gem's own load paths" do
      install_gemfile gemfile_source

      bundle %(exec ruby -e 'puts Gem.loaded_specs["foo"].full_require_paths')
      expect(out.split("\n").take(2)).to eq([extension_dirs.first.to_s, lib_path("foo/lib").to_s])
    end

    it "does not rebuild the extension when nothing changed" do
      install_gemfile gemfile_source

      built_at = extension_dirs.first.join("gem.build_complete").mtime

      bundle :install

      expect(extension_dirs.size).to eq(1)
      expect(extension_dirs.first.join("gem.build_complete").mtime).to eq(built_at)
    end

    it "rebuilds the extension when its sources change" do
      install_gemfile gemfile_source

      run "require 'foo'; puts FOO_C"
      expect(out).to eq("1")

      File.write(lib_path("foo/ext/foo.c"), <<-C)
        #include "ruby.h"

        void Init_foo_c(void) {
          rb_define_global_const("FOO_C", INT2NUM(2));
        }
      C

      bundle :install

      run "require 'foo'; puts FOO_C"
      expect(out).to eq("2")
    end

    it "rebuilds the extension when a native extension file changes" do
      install_gemfile gemfile_source

      run "require 'foo'; puts FOO_C"
      expect(out).to eq("1")

      File.write(lib_path("foo/ext/foo.h"), <<-C)
        #define FOO_VALUE 2
      C

      bundle :install

      run "require 'foo'; puts FOO_C"
      expect(out).to eq("2")
    end

    it "fails under bundle exec when the native extension is stale" do
      install_gemfile gemfile_source

      bundle "exec ruby -e 'require \"foo\"; puts FOO_C'"
      expect(out).to eq("1")

      File.write(lib_path("foo/ext/foo.h"), <<-C)
        #define FOO_VALUE 2
      C

      bundle "exec ruby -e 'require \"foo\"; puts FOO_C'", raise_on_error: false

      expect(exitstatus).not_to eq(0)
      expect(err_without_deprecations).to include("cannot load such file -- foo_c")
    end

    it "behaves the same under bundle exec before install as when the built extension is stale" do
      gemfile gemfile_source

      bundle "exec ruby -e 'require \"foo\"; puts FOO_C'", raise_on_error: false
      expect(exitstatus).not_to eq(0)
      before_install_error = err_without_deprecations
      expect(before_install_error).to include("cannot load such file -- foo_c")

      install_gemfile gemfile_source

      File.write(lib_path("foo/ext/foo.h"), <<-C)
        #define FOO_VALUE 2
      C

      bundle "exec ruby -e 'require \"foo\"; puts FOO_C'", raise_on_error: false
      expect(exitstatus).not_to eq(0)
      expect(err_without_deprecations).to eq(before_install_error)
    end

    it "shows compilation errors when building native extensions" do
      build_lib "bar", "1.0", path: lib_path("bar") do |s|
        s.extensions = ["ext/extconf.rb"]
        s.write "ext/extconf.rb", <<-RUBY
          require "mkmf"
          create_makefile("bar_c")
        RUBY
        s.write "ext/bar.c", <<-C
          #include "ruby.h"

          void Init_bar_c(void) {
            this will not compile
          }
        C
        s.write "lib/bar.rb", "require 'bar_c'"
      end

      install_gemfile <<-G, raise_on_error: false, verbose: true
        source "https://gem.repo1"
        gem "bar", :path => "#{lib_path("bar")}"
      G

      expect(exitstatus).not_to eq(0)
      expect(out).to include("Using bar 1.0 from source at `#{lib_path("bar")}` with native extensions")
      expect(err_without_deprecations).to include("Gem::Ext::BuildError")
      expect(err_without_deprecations).to match(/error:/i)
    end

    it "passes the flags configured for the gem to the build" do
      build_lib "bar", "1.0", path: lib_path("bar") do |s|
        s.extensions = ["ext/extconf.rb"]
        s.write "ext/extconf.rb", <<-RUBY
          require "mkmf"
          raise ArgumentError unless with_config("bar") == "hello"
          create_makefile("bar_c")
        RUBY
        s.write "ext/bar.c", "#include \"ruby.h\"\nvoid Init_bar_c(void) {}\n"
        s.write "lib/bar.rb", "require 'bar_c'"
      end

      bundle_config "build.bar --with-bar=hello"

      install_gemfile <<-G
        source "https://gem.repo1"
        gem "bar", :path => "#{lib_path("bar")}"
      G

      run "require 'bar'; puts 'built'"
      expect(out).to eq("built")
    end

    it "can be turned off again for a single gem" do
      bundle_config "build_path_extensions.foo false"

      install_gemfile gemfile_source

      expect(extension_dirs).to be_empty
    end
  end

  context "when path extension building is enabled for a single gem" do
    before { bundle_config "build_path_extensions.foo true" }

    it "builds that gem's extension" do
      install_gemfile gemfile_source

      run "require 'foo'; puts FOO_C"
      expect(out).to eq("1")
    end

    it "leaves other path gems alone" do
      build_lib "bar", "1.0", path: lib_path("bar") do |s|
        s.extensions = ["ext/extconf.rb"]
        s.write "ext/extconf.rb", "require 'mkmf'\ncreate_makefile('bar_c')\n"
        s.write "ext/bar.c", "#include \"ruby.h\"\nvoid Init_bar_c(void) {}\n"
        s.write "lib/bar.rb", "require 'bar_c'"
      end

      install_gemfile <<-G
        source "https://gem.repo1"
        gem "foo", :path => "#{lib_path("foo")}"
        gem "bar", :path => "#{lib_path("bar")}"
      G

      expect(Pathname.glob(default_bundle_path("bundler/gems/extensions/*/*/bar-1.0-*"))).to be_empty
    end
  end
end
