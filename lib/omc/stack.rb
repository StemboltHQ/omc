require 'omc/instances'
require 'omc/app'
require 'omc/layer'
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

    def instances layer_id: nil
      options = layer_id.nil? ? Hash[stack_id: self[:stack_id]] : Hash[layer_id: layer_id]
      @instances ||= client.describe_instances(options)[:instances].map do |instance|
        ::Omc::Instance.new(self, instance)
      end
    end

    def apps
      @apps ||= client.describe_apps(stack_id: self[:stack_id])[:apps].map do |app|
        ::Omc::App.new(self, app)
      end
    end

    def layers
      @layers ||= client.describe_layers(stack_id: self[:stack_id])[:layers].map do |layer|
        ::Omc::Layer.new(self, layer)
      end
    end
  end
end
