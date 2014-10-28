require 'omc/stack'

module Omc
  class Account
    attr_accessor :client

    def initialize(credentials)
      @client = ::AWS::OpsWorks::Client.new(credentials)
    end

    def stacks
      @stacks ||= client.describe_stacks[:stacks].map do |stack|
        ::Omc::Stack.new(self, stack)
      end
    end
  end
end
