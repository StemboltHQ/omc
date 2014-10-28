require 'omc/instances'
require 'omc/app'
require 'forwardable'

module Omc
  class Stack
    attr_reader :account, :attributes

    extend Forwardable
    def_delegators :@attributes, :[]
    def_delegators :account, :client

    def initialize account, attributes
      @account = account
      @attributes = attributes
    end

    def instances
      @instances ||= client.describe_instances(stack_id: self[:stack_id])[:instances].map do |instance|
        ::Omc::Instance.new(self, instance)
      end
    end

    def apps
      @apps ||= client.describe_apps(stack_id: self[:stack_id])[:apps].map do |app|
        ::Omc::App.new(self, app)
      end
    end
  end
end
