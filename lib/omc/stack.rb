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

    def instances
      @instances ||= describe(:instances).map{ |instance| Instance.new(self, instance) }
    end

    def apps
      @apps ||= describe(:apps).map{ |app| App.new(self, app) }
    end

    def layers
      @layers ||= describe(:layers).map{ |layer| Layer.new(self, layer) }
    end

    def execute_recipes(app, recipes: [], name: "execute_recipes")
      client.create_deployment(
        stack_id: self[:stack_id],
        app_id: app[:app_id],
        command: {
          name: name,
          args: {
            "recipes" => recipes
          }
        }
      )
    end

    private

    def describe(object)
      client.public_send("describe_#{object}", stack_id: self[:stack_id])[object]
    end
  end
end
