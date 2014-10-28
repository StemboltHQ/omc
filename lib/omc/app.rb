module Omc
  class App
    attr_reader :stack, :attributes

    extend Forwardable
    def_delegators :@attributes, :[]
    def_delegators :stack, :account, :client

    def initialize stack, attributes
      @stack = stack
      @attributes = attributes
    end
  end
end
