module Erbside

  # Base class for all the inline parsers.
  #
  class Inline

    # C L A S S - M E T H O D S

    #
    def self.factory(file)
      map[File.extname(file)]
    end

    #
    def self.map
      @map ||= (
        register.inject({}) do |hash, base|
          base.extensions.each do |ext|
            hash[ext] = base
          end
          hash
        end
      )
    end

    def self.register
      @register ||= []
    end

    def self.inherited(base)
      register << base
    end

    def self.extensions ; raise ; end
 
    #
    def self.extension_list
      register.map{ |x| x.extensions }.flatten
    end

    # R E Q U I R E M E N T S

    require 'pathname'
    require 'erb'

    require 'erbside/context'
    require 'erbside/inline/bash'
    require 'erbside/inline/cpp'
    require 'erbside/inline/css'
    require 'erbside/inline/sgml'
    require 'erbside/inline/js'
    require 'erbside/inline/ruby'


    # C O N S T A N T S

    #
    TAG = 'erb'


    # A T T R I B U T E S

    #
    attr :file

    #
    attr :type

    #
    attr :context

    # The rendered result.
    attr :result


    # I N I T I A L I Z E

    #
    def initialize(file)
      @file   = Pathname.new(file)
      @type   = @file.extname

      @context = Context.new(@file.parent)
    end

    #
    def content
      @content ||= File.read(file)
    end 

    #
    def render
      @result = render_result
    end

    #
    def render_template(text)
      #Dir.chdir(file.parent) do
        context.render(text)
      #end
    end

    #
    def relative_output(dir=nil)
      dir = dir || Dir.pwd
      output.sub(dir+'/', '')
    end

    #
    def exist?
      File.exist?(output)
    end

    # Has the file changed?
    def changed?
      if exist?
        File.read(output) != result
      else
        true
      end
    end

    # Save result to file.
    def save
      File.open(output, 'w'){ |f| f << result }
    end

    # Output file (same as the input file).
    def output
      file
    end

    #
    def render_result
      text = content
      text = render_sides(text)
      text = render_blocks(text)
    end

    #
    def remarker
      raise
    end

    #
    def remarker_multiline
      raise
    end

    #
    def line_match
      rem = Regexp.escape(remarker)
      /^(\ *)(.*?)(\ *)(#{rem})(\ *)(:#{TAG})(\+\d*)?(:)(.*?\S.*?)$/
    end

    #
    def render_sides(text)
      index  = 0
      result = ''

      text.scan(line_match) do |m|
        md = $~

        indent = md[1]
        front  = md[2]
        remark = [ md[3], md[4], md[5], md[6], md[7], md[8], md[9] ].join('')
        tmplt  = md[9].strip
        count  = md[7]

        render = render_template(tmplt)

        result << text[index...md.begin(0)]
        result << format_side(indent, front, remark, tmplt, render, count)

        #index = md.end(0)
        i = md.end(0) + 1
        count.to_i.times{ i = text[i..-1].index("\n") + i + 1 }
        index = i
      end

      result << text[index..-1]
      result
    end

    #
    def format_side(indent, front, remark, tmplt, render, multi=nil)
      size = render.count("\n")
      if multi || size > 0
        indent + remark.sub(/:#{TAG}(\+\d+)?:/, ":#{TAG}+#{size+1}:") + "\n" + render + "\n"
      else
        if tmplt =~ /^\s*\^/
          b = tmplt.index('^') + 1
          e = tmplt.index(/[<{]/) || - 1
          m = tmplt[b...e]
          i = front.index(m)
          render = front[0...i] + render.sub('^','')
        end
        indent + render + remark.sub(/:#{TAG}(\+\d+)?:/, ":#{TAG}:") + "\n"
      end
    end

    #
    def block_match
      b = Regexp.escape(remarker_block_begin)
      e = Regexp.escape(remarker_block_end)
      %r{^(#{b})(\s*)(:#{TAG})(\+\d*)?(\:)(\s*\n)((?m:.*?))(\n#{e})}
    end

    #
    def render_blocks(text)
      index  = 0
      result = ''

      text.scan(block_match) do |m|
        md = $~

        #indent = ""
        #front  = nil
        remark = md[0]
        pad    = md[2]
        count  = md[4]
        tmplt  = md[7]

        render = render_template(tmplt)

        result << text[index...md.begin(0)]
        result << format_block(pad, tmplt, render)

        i = md.end(0) + 1
        count.to_i.times{ i = text[i..-1].index("\n") + i + 1 }
        index = i
      end

      result << text[index..-1]
      result
    end

    #
    def format_block(pad, template, render)
      size = render.count("\n") + 1
      b = remarker_block_begin
      e = remarker_block_end
      "#{b}#{pad}:#{TAG}+#{size}:\n#{template}\n#{e}\n#{render}\n"
    end

  end

end

