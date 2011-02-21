module Erbside

  require 'erbside/inline'

  # Javascript Adapter
  class Javascript < Inline

    #
    EXTENSIONS = %w{.js}

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

