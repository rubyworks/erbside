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

  end

end

