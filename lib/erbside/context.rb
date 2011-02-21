module Erbside

  # = Tilling Context
  #
  class Context

    require 'erbside/metadata'

    #
    attr :metadata

    #
    def initialize(directory=nil)
      @directory = directory
      @metadata  = Metadata.new(directory)
    end

    #
    def method_missing(s)
      @metadata.send(s)
    end

    #
    def root
      metadata.root
    end

    #
    def to_h
      @metadata.to_h
    end

    # Processes through erb.
    def render(text)
      Dir.chdir(@directory) do
        erb = ERB.new(text)
        erb.result(binding)
      end
    end

  end

end

