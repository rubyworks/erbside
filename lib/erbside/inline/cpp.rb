module Erbside

  require 'erbside/inline'

  # C/C++ Adapter
  class Cpp < Inline

    EXTENSIONS = %w{ .c .cpp }

    def self.extensions
      EXTENSIONS
    end

    #
    def remarker
      '//'
    end

    #
    def remarker_block_begin
      '/*'
    end

    #
    def remarker_block_end
      '*/'
    end

    #
    def block_match
      b = Regexp.escape(remarker_block_begin)
      e = Regexp.escape(remarker_block_end)
      %r{^(\s*)(#{b})(\s*)(:#{TAG})(\+\d*)?(\:)(\s*)((?m:.*?))(\s#{e})}
    end

  end

end

