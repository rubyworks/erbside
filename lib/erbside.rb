module Erbside
  require 'erbside/runner'

  #
  module MetadataMixin
    def metadata
      @_metadata ||= (
        require 'yaml'
        YAML.load_file(File.dirname(__FILE__) + '/erbside.yml')
      )
    end
    def const_missing(name)
      key = name.to_s.downcase
      metadata.key?(key) ? metadata[key] : super(name)
    end
  end
  extend MetadataMixin

  # Yea, this is old school.
  #VERSION="0.2.0" #:erb: VERSION="<%= version %>"

  #
  def self.cli(argv=ARGV)
    require 'optparse'
    require 'erbside/runner'

    options = {:resources=>[]}

    usage = OptionParser.new do |use|
      use.banner = 'Usage: erbside [OPTIONS] [FILE1 FILE2 ...]'

      #use.on('--delete', 'delete templates when finished') do
      #  options[:delete] = true
      #end

      use.on('-r', '--resource FILE', 'get metadata from file') do |file|
        options[:resources] << file
      end

      use.on('-p', '--prompt', 'prompt for each write') do
        options[:prompt] = true
      end

      #use.on('-s', '--skip', 'automatically skip overwrites') do
      #  options[:skip] = true
      #end

      use.on('-o', '--stdout', 'dump output to stdout instead of saving') do
        options[:output] = $stdout
      end

      use.on('-t', '--trial', '--dryrun', '--dry-run', 'run in trial mode (no disk writes)') do
        $TRIAL = true
      end

      use.on('--debug', 'run in debug mode') do
        $DEBUG = true
      end

      use.on_tail('-h', '--help', 'display this help information') do
        puts use
        exit
      end
    end

    usage.parse!(argv)

    files = argv

    runner = Erbside::Runner.new(files, options)

    runner.render
  end

end
