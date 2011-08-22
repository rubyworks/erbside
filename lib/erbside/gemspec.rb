begin
  require 'rubygems'

  module Gem
    class Specification

      def [](k); send(k); end

      def to_h
        instance_variables.inject({}) do |h,k|
          h[k.sub('@','')] = instance_variable_get(k); h
        end
      end
    end

  end

rescue LoadError
end
