begin; require 'dotruby'; rescue LoadError; end

module Erbside

  # Metadata belongs to the project being scaffold.
  #
  class Metadata

    # Canonical metadata file.
    CANONICAL_FILENAME = '.ruby'

    # Root directory is indicated by the presence of a +meta/+ directory,
    # or +.meta/+ hidden directory.
    ROOT_INDICATORS = [ "{#{CANONICAL_FILENAME},meta/,.meta/}" ]

    # Project root pathname.
    attr :root

    # Data resources.
    attr :resources

    # Construct new Metadata object.
    def initialize(resources, options={})
      @root = self.class.root(options[:root]) || Dir.pwd
      @data = []
p resources
      @resources = [resources].compact.flatten
      @resources << '.ruby' if canonical?
p @resources
      @resources.each do |source|
        case File.basename(source)
        when CANONICAL_FILENAME
          if canonical?
            if defined?(::DotRuby)
              @data << DotRuby::Spec.find(root) #(CANONICAL_FILENAME)
            else
              @data << YAML.load_file(canonical_file)
            end
          end
        when /\.gemspec$/
          require 'erbside/gemspec'
          @data << ::Gem::Specification.load(source)
        when /\.ya?ml$/
          @data << YAML.load_file(source)
        else
          if File.directory?(source)
            @data << load_metadir(source)
          else
            # now what ?
          end
        end
      end

      @cache = {}
    end

    # If method is missing, check the POM and metadata cache.
    def method_missing(name, *args)
      return super unless args.empty?
      self[name]
    end

    # Lookup metadata entry.
    def [](name)
      name, value = name.to_s, nil
      return @cache[name] if @cache.key?(name)
      begin
        @data.find{ |d| value = d[name] }
      rescue
      end
      @cache[name] = value
    end

    # Provide metadata to hash. Some (stencil) template systems
    # need the data in hash form.
    def to_h
      @data.reverse.inject({}){ |h,d| h.merge(d.to_h) }
    end

  private

    def canonical_file
      File.join(root, CANONICAL_FILENAME)
    end

    #
    def canonical?
      File.exist?(canonical_file)
    end

    # Load metadata cache. This serves as the fallback for the POM.
    def load_metadir(dir=nil)
      data = {}
      Dir[File.join(dir || metadir, '*')].each do |file|
        next unless File.file?(file)

        case File.extname(file)
        when '.yaml'
          val = YAML.load(File.new(file))
          data.merge!(val)
        when ''
          val = File.read(file).strip
          val = YAML.load(val) if val =~ /\A---/
          data[File.basename(file)] = val
        else
          # ignore
        end
      end
      data
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
