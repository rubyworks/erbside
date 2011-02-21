module Erbside

  require 'erbside/inline'

  # Ruby
  class Ruby < Inline

    #
    EXTENSIONS = %w{.rb}

    # Ruby file extensions.
    def self.extensions
      EXTENSIONS
    end

    #
    def remarker
      '#'
    end

    #
    def remarker_block_begin
      '=begin'
    end

    #
    def remarker_block_end
      '=end'
    end

  end

end

