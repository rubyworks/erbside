module Erbside

  require 'erbside/inline'

  # XML and HTML
  class SGML < Inline

    EXTENSIONS = %w{ .html .xml }

    #
    def self.extensions
      EXTENSIONS
    end

    #
    def remarker
      '<!--'
    end

    #
    def remarker_block_begin
      '<!--'
    end

    #
    def remarker_block_end
      '-->'
    end

    #
    def line_match
      rem = Regexp.escape(remarker)
      /^(\ *)(.*?)(\ *)(#{rem})(\ *)(:#{TAG})()?(:)(.*?\S.*?)(-->)$/
    end

    #
    def block_match
      b = Regexp.escape(remarker_block_begin)
      e = Regexp.escape(remarker_block_end)
      %r{^(\s*)(#{b})(\s*)(:#{TAG})(\+\d*)?(\:)(\s*)((?m:.*?))(\s#{e})}
    end

    #
    def block_parts(match_data)
      { :indent   => match_data[1],
        :pad      => match_data[3],
        :count    => match_data[5],
        :space    => match_data[7],
        :template => match_data[8],
        :tail     => match_data[9]
      }
    end

=begin
    #
    def render_result
      text = content
      text = render_backs(text)
      text = render_blocks(text)
    end

    #
    BACKS  = /^(\ *)(.*?\S.*?)(\ *)(<!--)(\ *)(:till:)(.*?)(-->)$/

    #
    def render_backs(text)
      index  = 0
      result = ''

      text.scan(BACKS) do |m|
        md = $~

        indent = md[1]
        front  = md[2]
        remark = [ md[3], md[4], md[5], md[6], md[7], md[8] ].join('')
        tmplt  = md[7].strip
        count  = nil

        render = render_template(tmplt)

        result << text[index...md.begin(0)]
        result << format_back(indent, front, remark, tmplt, render)

        #index = md.end(0)
        i = md.end(0) + 1
        count.to_i.times{ i = text[i..-1].index("\n") + i + 1 }
        index = i
      end

      result << text[index..-1]
      result
    end

    #
    BLOCKS = /^(\ *)(<!--)(\ *)(:till)(\+\d*)?(\:)(.*?)(-->)/m

    #
    def render_blocks(text)
      index  = 0
      result = ''

      text.scan(BLOCKS) do |m|
        md = $~

        indent = md[1]
        #front  = nil
        remark = [ md[1], md[2], md[3], md[4], md[5], md[6], md[7], md[8] ].join('')
        tmplt  = md[7].strip
        count  = md[5]

        render = render_template(tmplt)

        result << text[index...md.begin(0)]
        result << format_block(indent, remark, tmplt, render)

        #index = md.end(0)
        i = md.end(0) + 1
        count.to_i.times{ i = text[i..-1].index("\n") + i + 1 }
        index = i
      end

      result << text[index..-1]
      result
    end

    #
    def format_back(indent, front, remark, tmplt, render)
      size = render.count("\n")
      if size > 0
        format_block(indent, remark, tmplt, front + render)
      else
        if tmplt =~ /^\s*\^/
          b = tmplt.index('^') + 1
          e = tmplt.index(/[<{]/) || - 1
          m = tmplt[b...e]
          i = front.index(m)
          render = front[0...i] + render.sub('^','')
        end
        indent + render + remark.sub(/:till(\+\d+)?:/, ":till:") + "\n"
      end
    end

    #
    def format_block(indent, remark, tmplt, render)
      size = render.count("\n")
      indent + remark.sub(/:till(\+\d+)?:/, ":till+#{size+1}:") + "\n" + render +"\n"
    end
=end

  end

end

