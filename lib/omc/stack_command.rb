require 'aws-sdk'
require 'omc/account'

module Omc
  class StackCommand
    def initialize aws_account, user, stack_name, app: nil, layer: nil
      @aws_account = aws_account
      @user = user
      @stack_name = stack_name
      @app_name = app
      @layer_name = layer
    end

    def ssh
      exec "ssh", *([ssh_host] + default_ssh_args)
    end

    def console
      ssh_and_execute_as_deploy "cd /srv/www/#{app[:shortname]}/current && RAILS_ENV=#{app[:attributes]['RailsEnv']} bundle exec rails c"
    end

    def db
      ssh_and_execute_as_deploy "cd /srv/www/#{app[:shortname]}/current && RAILS_ENV=#{app[:attributes]['RailsEnv']} bundle exec rails db -p"
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
          i[:private_ip],
        ]
      end
      thor.print_table(details)
    end

    def ssh_and_execute(command)
      puts "Executing '#{command}'"
      args = default_ssh_args + ['-t', ssh_host, command]

      exec 'ssh', *args
    end

    private
    def ssh_and_execute_as_deploy(command)
      ssh_and_execute "sudo su deploy -c '#{command}'"
    end

    def app
      if @app_name
        get_by_name(stack.apps, @app_name)
      else
        stack.apps.first
      end
    end

    def layer
      if @layer_name
        get_by_name(stack.layers, @layer_name, key: :shortname)
      end
    end

    def instance
      instances = layer ? layer.instances : stack.instances
      instances.detect(&:online?) || abort("No running instances")
    end

    def ssh_host
      ip_address = bastion ? instance[:private_ip] : instance[:public_ip]
      host = "#{@user.name}@#{ip_address}"
      puts "Connecting to #{host}"
      host
    end

    def account
      @account ||= Omc::Account.new(@user.credentials)
    end

    def stack
      @stack ||= get_by_name(account.stacks, @stack_name)
    end

    def bastion
      @aws_account.bastions.detect { |y| y.name == @stack_name }
    end

    def default_ssh_args
      bastion ? [ '-o', "ProxyCommand ssh -W %h:%p #{bastion.host}" ] : []
    end

    def get_by_name collection, name, key: :name
      collection.detect do |x|
        x[key] == name
      end || abort("Can't find #{name.inspect} among #{collection.map{|x| x[key] }.inspect}")
    end
  end
end
