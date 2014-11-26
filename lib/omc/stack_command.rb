require 'aws-sdk'
require 'omc/account'

module Omc
  class StackCommand
    def initialize user, stack_name, app: nil, layer: nil
      @user = user
      @stack_name = stack_name
      @app_name = app
      @layer_name = layer
    end

    def ssh
      exec "ssh", ssh_host
    end

    def console
      ssh_and_execute "cd /srv/www/#{app[:name]}/current && RAILS_ENV=#{app[:attributes]['RailsEnv']} bundle exec rails c"
    end

    def db
      ssh_and_execute "cd /srv/www/#{app[:name]}/current && RAILS_ENV=#{app[:attributes]['RailsEnv']} bundle exec rails db -p"
    end

    def unicorn(action)
      case action
      when "restart"
        stack.execute_recipes(app, recipes: ["deploy::rails-restart"], name: "restart")
      else
        abort("Unicorn action should be one of [restart]")
      end
    end

    def status(thor)
      details = stack.instances.map do |i|
        [
          i[:hostname],
          i[:instance_type],
          i[:status],
          i[:availability_zone],
          i[:ec2_instance_id],
          i[:public_ip],
        ]
      end
      thor.print_table(details)
    end

    private
    def ssh_and_execute(command)
      exec 'ssh', '-t', ssh_host, "sudo su deploy -c '#{command}'"
    end

    def app
      if @app_name
        get_by_name(stack.apps, @app_name)
      else
        stack.apps.first
      end
    end

    def instance
      layer_id = @layer_name ? stack.layers.detect{ |l| l[:shortname] == @layer_name }[:layer_id] : nil
      instances = stack.instances(layer_id: layer_id)
      instances.detect(&:online?) || abort("No running instances")
    end

    def ssh_host
      "#{@user.name}@#{instance[:public_ip]}"
    end

    def account
      @account ||= Omc::Account.new(@user.credentials)
    end

    def stack
      @stack ||= get_by_name(account.stacks, @stack_name)
    end

    def get_by_name collection, name
      collection.detect do |x|
        x[:name] == name
      end || abort("Can't find #{name.inspect} among #{collection.map{|x| x[:name] }.inspect}")
    end
  end
end
