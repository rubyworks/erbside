module Erbside

  require 'erbside/inline'

  # Bash Adapter
  class Bash < Inline

    EXTENSIONS = %w{.sh}

    #
    def self.extensions
      EXTENSIONS
    end

    #
    def remarker
      '#'
    end

    #
    def remarker_block_begin
      '#=begin'
    end

    #
    def remarker_block_end
      '#=end'
    end

  end

end

