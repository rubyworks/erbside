require 'pom'
#require 'facets/ostruct'

module Erbside

  # Metadata belongs to the project being scaffold.
  #
  # TODO: Support POM::Metadata
  #
  class Metadata

    # Canonical metadata file.
    CANONICAL_FILENAME = ::POM::Profile::CANONICAL_FILENAME

    # Root directory is indicated by the presence of a +meta/+ directory,
    # or +.meta/+ hidden directory.
    ROOT_INDICATORS = [ "{#{CANONICAL_FILENAME},meta/,.meta/}" ]

    # Project root pathname.
    attr :root

    # Construct new Metadata object.
    def initialize(root=nil)
      @root = self.class.root(root) || Dir.pwd

      if canonical?
        @pom = POM::Metadata.new(@root, :canonical)
      else
        @pom = POM::Metadata.new(@root, :defaults, :gemspec)
      end

      @cache = {} #OpenStruct.new

      load_cache  # TODO: when pom supports arbitrary metadata, merge @pom and @cache into same variable.
    end

    # If method is missing, check the POM and metadata cache.
    def method_missing(name, *args)
      return super unless args.empty?
      self[name]
    end

    # Lookup metadata entry from POM or cache.
    def [](name)
      name  = name.to_s
      value = nil
      begin
        value = @pom[name]
      rescue
      end
      value || @cache[name]
    end

    # Provide metadata to hash. Some (stencil) template systems
    # need the data in hash form.
    def to_h
      if @pom
        @pom.to_h
      else
        @cache
      end
    end

  private

    #
    def canonical?
      File.exist?(File.join(root, CANONICAL_FILENAME))
    end

    # Load metadata cache. This serves as the fallback for the POM.
    def load_cache
      Dir[File.join(metadir, '*')].each do |file|
        next unless File.file?(file)

        case File.extname(file)
        when '.yaml'
          val = YAML.load(File.new(file))
          @cache.merge!(val)
        when ''
          val = File.read(file).strip
          val = YAML.load(val) if val =~ /\A---/
          @cache[File.basename(file)] = val
        else
          # ignore
        end
      end
    end

    # What is project root's meta directory?
    def metadir
      @metadir ||= Dir[File.join(root, '{meta,.meta}/')].first || 'meta/'
    end

    #
    #def load_value(name)
    #  file = File.join(metadir, name)
    #  file = Dir[file].first
    #  if file && File.file?(file)
    #    #return erb(file).strip
    #    return File.read(file).strip
    #  end
    #end

    # Locate the project's root directory. This is determined
    # by ascending up the directory tree from the current position
    # until the ROOT_INDICATORS is matched. Returns +nil+ if not found.
    def self.root(local=Dir.pwd)
      local ||= Dir.pwd
      Dir.chdir(local) do
        dir = nil
        ROOT_INDICATORS.find do |i|
          dir = locate_root_at(i)
        end
        dir ? Pathname.new(File.dirname(dir)) : nil
      end
    end

    #
    def self.locate_root_at(indicator)
      root = nil
      dir  = Dir.pwd
      while !root && dir != '/'
        find = File.join(dir, indicator)
        root = Dir.glob(find, File::FNM_CASEFOLD).first
        #break if root
        dir = File.dirname(dir)
      end
      root ? Pathname.new(root) : nil
    end

  end

end

