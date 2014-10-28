module Omc
  class Instance
    attr_reader :stack, :attributes

    extend Forwardable
    def_delegators :@attributes, :[]
    def_delegators :stack, :account
    def_delegators :account, :client

    def initialize stack, attributes
      @stack = stack
      @attributes = attributes
    end

    def online?
      attributes[:status] == "online"
    end

    def offline?
      !online?
    end
  end
end
