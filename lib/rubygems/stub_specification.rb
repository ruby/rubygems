# frozen_string_literal: true

##
# Gem::StubSpecification reads the stub: line from the gemspec.  This prevents
# us having to eval the entire gemspec in order to find out certain
# information.

class Gem::StubSpecification < Gem::BasicSpecification
  # :nodoc:
  PREFIX = "# stub: "

  # :nodoc:
  TARGET_PREFIX = "# stub-target: "

  # :nodoc:
  FILES_PREFIX = "# files: "

  # :nodoc:
  OPEN_MODE = "r:UTF-8:-"

  class StubLine # :nodoc: all
    attr_reader :name, :version, :platform, :require_paths, :extensions,
                :full_name, :content_address, :files

    NO_EXTENSIONS = [].freeze
    NO_TARGET = {}.freeze
    NO_FILES = [].freeze

    # These are common require paths.
    REQUIRE_PATHS = { # :nodoc:
      "lib" => "lib",
      "test" => "test",
      "ext" => "ext",
    }.freeze

    # These are common require path lists.  This hash is used to optimize
    # and consolidate require_path objects.  Most specs just specify "lib"
    # in their require paths, so lets take advantage of that by pre-allocating
    # a require path list for that case.
    REQUIRE_PATH_LIST = { # :nodoc:
      "lib" => ["lib"].freeze,
    }.freeze

    # +source+ is the gemspec as an IO or a String. Returns nil when it has no
    # complete stub header, or no files stub line when +files_required+.
    def self.parse(source, files_required: false)
      stubline = nil
      extensions = NO_EXTENSIONS
      target = NO_TARGET
      files = NO_FILES
      lineno = 0

      # Match header lines by prefix, not position, so that one line never
      # hides another that follows it.
      source.each_line do |line|
        lineno += 1
        next if lineno == 1 # discard encoding line

        if lineno == 2
          break unless line.start_with?(PREFIX)
          stubline = line
        elsif !line.start_with?("# ")
          break if files_required && files.equal?(NO_FILES)
          stubline.chomp! # readline(chomp: true) allocates 3x as much as .readline.chomp!
          return new(stubline, extensions, target, files)
        elsif line.delete_prefix!(PREFIX)
          line.chomp!
          extensions = line.split "\0"
        elsif line.delete_prefix!(TARGET_PREFIX)
          line.chomp!
          target = line.split(",").to_h do |pair|
            key, value = pair.split("=", 2)
            [key, value]
          end
        elsif line.delete_prefix!(FILES_PREFIX)
          line.chomp!
          files = line.split "\0"
        end
      end

      nil
    end

    def initialize(data, extensions, target = NO_TARGET, files = NO_FILES)
      parts          = data[PREFIX.length..-1].split(" ", 4)
      @name          = -parts[0]
      @version       = if Gem::Version.correct?(parts[1])
        Gem::Version.new(parts[1])
      else
        Gem::Version.new(0)
      end

      suffix = parts[2]
      target_platform = target["platform"]
      @platform = Gem::Platform.new(target_platform || suffix)
      @content_address = suffix if Gem::ContentAddress.content_addressed_row?(suffix, target_platform, validate_ruby_abi: false)
      @extensions    = extensions
      @files         = files
      @full_name     = if @content_address
        "#{name}-#{version}-#{content_address}"
      elsif platform == Gem::Platform::RUBY
        "#{name}-#{version}"
      else
        "#{name}-#{version}-#{suffix}"
      end

      path_list = parts.last
      @require_paths = REQUIRE_PATH_LIST[path_list] || path_list.split("\0").map! do |x|
        REQUIRE_PATHS[x] || x
      end
    end
  end

  def self.default_gemspec_stub(filename, base_dir, gems_dir, stub_line = nil)
    new filename, base_dir, gems_dir, true, stub_line
  end

  def self.gemspec_stub(filename, base_dir, gems_dir)
    new filename, base_dir, gems_dir, false
  end

  attr_reader :base_dir, :gems_dir

  def initialize(filename, base_dir, gems_dir, default_gem, stub_line = nil)
    super()

    self.loaded_from = filename
    @data            = stub_line
    @name            = nil
    @spec            = nil
    @base_dir        = base_dir
    @gems_dir        = gems_dir
    @default_gem     = default_gem
  end

  ##
  # True when this gem has been activated

  def activated?
    @activated ||= !loaded_spec.nil?
  end

  def default_gem?
    @default_gem
  end

  def build_extensions # :nodoc:
    return if default_gem?
    return if extensions.empty?

    to_spec.build_extensions
  end

  ##
  # If the gemspec contains a stubline, returns a StubLine instance. Otherwise
  # returns the full Gem::Specification.

  def data
    unless @data
      begin
        saved_lineno = $.

        @data = Gem.open_file loaded_from, OPEN_MODE do |file|
          StubLine.parse file
        end
      ensure
        $. = saved_lineno
      end
    end

    @data ||= to_spec
  end

  private :data

  def raw_require_paths # :nodoc:
    data.require_paths
  end

  ##
  # Files recorded in the files stub line, without loading the full
  # specification. Returns StubLine::NO_FILES when the gemspec has no files
  # stub line.

  def stubbed_files
    data.files
  end

  ##
  # Files in the gem, from the files stub line if available,
  # otherwise from the full specification.

  def files
    stubbed = stubbed_files
    stubbed.equal?(StubLine::NO_FILES) ? to_spec.files : stubbed
  end

  ##
  # Activate this spec, loading the full specification if needed.

  def activate
    to_spec.activate
  end

  def missing_extensions?
    return false if RUBY_ENGINE == "jruby"
    return false if default_gem?
    return false if extensions.empty?
    return false if File.exist? gem_build_complete_path

    to_spec.missing_extensions?
  end

  ##
  # Name of the gem

  def name
    data.name
  end

  ##
  # Platform of the gem

  def platform
    data.platform
  end

  def content_address # :nodoc:
    data.content_address
  end

  ##
  # Extensions for this gem

  def extensions
    data.extensions
  end

  ##
  # Version of the gem

  def version
    data.version
  end

  def full_name
    data.full_name
  end

  ##
  # The full Gem::Specification for this gem, loaded from evalling its gemspec

  def spec
    @spec ||= loaded_spec if @data
    @spec ||= Gem::Specification.load(loaded_from)
  end
  alias_method :to_spec, :spec

  ##
  # Is this StubSpecification valid? i.e. have we found a stub line, OR does
  # the filename contain a valid gemspec?

  def valid?
    data
  end

  ##
  # Is there a stub line present for this StubSpecification?

  def stubbed?
    data.is_a? StubLine
  end

  def ==(other) # :nodoc:
    self.class === other &&
      name == other.name &&
      version == other.version &&
      platform == other.platform &&
      content_address == other.content_address
  end

  alias_method :eql?, :== # :nodoc:

  def hash # :nodoc:
    [name, version, platform, content_address].hash
  end

  def <=>(other) # :nodoc:
    sort_obj <=> other.sort_obj
  end

  def sort_obj # :nodoc:
    [name, version, Gem::Platform.sort_priority(platform)]
  end

  private

  def loaded_spec
    spec = Gem.loaded_specs[name]
    return unless spec && spec.version == version && spec.default_gem? == default_gem?

    spec
  end
end
