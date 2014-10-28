require 'aws-sdk'
require 'omc/account'

module Omc
  class StackCommand
    def initialize user, stack_name
      @user = user
      @stack_name = stack_name
    end

    def ssh
      exec "ssh", ssh_host
    end

    def console
      app = applications.first
      ssh_and_execute "cd /srv/www/#{app[:name]}/current && RAILS_ENV=#{app[:attributes]['RailsEnv']} bundle exec rails c"
    end

    def db
      app = applications.first
      ssh_and_execute "cd /srv/www/#{app[:name]}/current && RAILS_ENV=#{app[:attributes]['RailsEnv']} bundle exec rails db -p"
    end

    private
    def ssh_and_execute(command)
      exec 'ssh', '-t', ssh_host, "sudo su deploy -c '#{command}'"
    end

    def applications
      stack.apps
    end

    def instance
      stack.instances.detect(&:online?) || abort("No running instances")
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
