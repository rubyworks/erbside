module Erbside

  # = Runner
  #
  class Runner

    require 'erbside/inline'
    require 'erbside/metadata'

    require 'facets/kernel/ask'
    require 'facets/string/tabto'


    # A T T R I B U T E S

    attr_accessor :files

    attr_accessor :force

    attr_accessor :skip

    # The +output+ can be any object that responds to #<<.
    attr_accessor :output

    #attr_accessor :delete


    # I N I T I A L I Z E

    #
    def initialize(files, options)
      files = files || Dir["**/*#{ext_glob}"]
      files = files.map do |file|
        if File.directory?(file)
          collect_usable_files(file)
        else
          file
        end
      end.flatten
      @files  = files

      @force  = options[:force]
      @skip   = options[:skip]
      @output = options[:output]
      #@delete = options[:delete]
    end

    #
    def collect_usable_files(dir)
      Dir[File.join(dir,"**/*#{ext_glob}")]
    end

    #def delete? ; @delete ; end
    def force?  ; @force  ; end
    def skip?   ; @skip   ; end

    def debug?  ; $DEBUG  ; end
    def trial?  ; $TRIAL  ; end

    #
    def render
      files.each do |file|
        render_file(file)
      end
    end

    # Search through a file for inline templates, render and output.
    def render_file(file)
      parser = Inline.factory(file)
      if !parser
        puts "  unrecognized #{file}" if $DEBUG || $TRIAL
        return
      end
      template = parser.new(file)
      if template.exist? && skip?
        puts "  #{template.relative_output} skipped"
      else
        result = template.render
        if output
          output << (result + "\n")
        else
          save(template, result)
        end
      end
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
          elsif !force?
            case ask("  overwrite #{name}? ")
            when 'y', 'yes'
              save = true
            end
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


    private

    #
    def ext_glob
      '{' + Inline.extension_list.join(',') + '}'
    end

  end

end
