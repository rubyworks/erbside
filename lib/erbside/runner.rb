module Erbside

  # The runner class doe the work of rendering and saving 
  # targeted files.
  #
  class Runner

    require 'erbside/inline'
    require 'erbside/metadata'

    require 'facets/kernel/ask'
    require 'facets/string/tabto'


    # A T T R I B U T E S

    # Files to render.
    attr_accessor :files

    # Exclude from files.
    attr_accessor :exclude

    # Exclude files by matching against basename.
    attr_accessor :ignore

    # Ask before write.
    attr_accessor :prompt

    # The +output+ can be any object that responds to #<<.
    attr_accessor :output

    # Files from which to gather metadata.
    attr_accessor :resources


    # I N I T I A L I Z E

    #
    def initialize(files, options)
      @files     = files || "**/*#{ext_glob}"

      @exclude   = options[:exclude]
      @ignore    = options[:ignore]
      @prompt    = options[:prompt]
      @output    = options[:output]
      @resources = options[:resource] || options[:resources]

      @trial     = options[:trial] || $TRIAL
      @debug     = options[:debug] || $DEBUG
    end

    #
    #def metadata
    #  @metadata ||= Metadata.new(*resources)
    #end

    #
    def prompt? ; @prompt ; end

    #
    def debug?  ; @debug  ; end

    #
    def trial?  ; @trial  ; end

    #
    def dryrun? ; @trial  ; end

    #
    def render
      $stderr.puts('[DRYRUN]') if trial?
      target_files.each do |file|
        render_file(file)
      end
    end

  private

    # Search through a file for inline templates, render and output.
    def render_file(file)
      parser = Inline.factory(file)

      if !parser
        puts "  unrecognized #{file}" if $DEBUG || $TRIAL
        return
      end

      template = parser.new(file, *resources)

      #if template.exist? #&& skip?
      #  puts "  #{template.relative_output} skipped"
      #else
        result = template.render
        if output
          output << (result + "\n")
        else
          save(template, result)
        end
      #end
    end

    #
    def save(template, result)
      name = template.relative_output
      save = false

      if trial?
        puts "  #{name}"
      else
        if template.exist?
          if !template.changed?
            puts "  unchanged #{name}"
          elsif prompt?
            save = prompt_user(template)
          else
            save = true
          end
        else
          save = true
        end
      end

      if save
        template.save
        puts "    written #{name}"
      end
    end

    #
    def target_files
      targets = collect_files(files)
      targets -= collect_files(exclude) if exclude
      targets.reject!{ |t| [ignore].flatten.compact.any?{ |m| File.fnmatch?(m, t) } }
      targets
    end

    #
    def collect_files(files)
      filelist = []
      [files].flatten.each do |glob|
        Dir.glob(glob).each do |file|
          if File.directory?(file)
            filelist.concat(collect_directory_files(file))
          else
            filelist << file
          end
        end
      end
    end

    #
    def collect_directory_files(dir)
      Dir[File.join(dir,"**/*#{ext_glob}")]
    end

    #
    def ext_glob
      '{' + Inline.extension_list.join(',') + '}'
    end

    #
    def prompt_user(template)
      save = false
      name = template.relative_output

      case ask("  overwrite `#{name}'? [y/N/v/q] ").downcase
      when 'y', 'yes', 'ye'
        save = true
      when 'v', 'view', 'vi', 'vie'
        puts File.read(template.file)
        save = prompt_user(template)
      when 'q', 'quit'
        abort
      end
      return save
    end

  end

end
