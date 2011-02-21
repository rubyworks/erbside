module Syckle::Plugins

  # = Erbside Generation
  #
  class Erbside < Service

    cycle :main, :generate
    cycle :site, :generate

    # Make automatic?
    #autorun do
    #  ...
    #end

    available do |project|
      begin
        require 'erbside'
        true
      rescue LoadError
        false
      end
    end

    #
    #def safe?; @safe; end

    #
    def generate(options={})
      options ||= {}

      dir = nil # defaults to curent directory

      options[:trial]  = trial?
      options[:debug] = debug?
      options[:quiet] = quiet?
      options[:force] = force?

      tiller = Erbside::Runner.new(dir, options)
      tiller.till
    end

  end

end

