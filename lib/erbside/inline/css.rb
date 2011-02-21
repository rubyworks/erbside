module Erbside

  require 'erbside/inline'

  # CSS Adapter
  class CSS < Inline

    #
    EXTENSIONS = %w{.css}

    #
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

  end

end

