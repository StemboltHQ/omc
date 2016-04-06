require 'thor'
require 'aws_cred_vault'
require 'aws-sdk'
require "omc/stack_command"
require "omc/config"

module Omc
  class Cli < Thor
    class_option :account, aliases: '-a', optional: true
    class_option :layer, aliases: '-l', optional: true

    desc 'ssh STACK', 'Connect to an instance on a stack on an account'
    def ssh(stack)
      command = StackCommand.new(aws_account, user, stack, layer: options[:layer])
      command.ssh
    end

    desc 'ssh_exec STACK COMMAND', 'Connect to an instance on a stack on an account and execute a command'
    def ssh_exec(stack, user_command)
      command = StackCommand.new(aws_account, user, stack, layer: options[:layer])
      command.ssh_and_execute user_command
    end

    desc 'console STACK', 'Run a rails console on the given stack'
    method_option :app
    def console(stack)
      command = StackCommand.new(aws_account, user, stack, app: options[:app], layer: options[:layer])
      command.console
    end

    desc 'db STACK', 'Connect and run the database client on the given stack'
    method_option :app
    def db(stack)
      command = StackCommand.new(aws_account, user, stack, app: options[:app], layer: options[:layer])
      command.db
    end

    desc 'unicorn ACTION STACK', 'Connect and run the given action on the unicorns'
    method_option :app
    def unicorn(action, stack)
      command = StackCommand.new(aws_account, user, stack, app: options[:app])
      command.unicorn(action)
    end

    desc 'status STACK', 'Show the instance status for the given stack'
    def status(stack)
      command = StackCommand.new(aws_account, user, stack, app: options[:app], layer: options[:layer])
      command.status(self)
    end

    private
    def user
      aws_account.users.first || abort("No users configured under #{account.inspect}")
    end

    def aws_account
      vault.account(account) || abort("Account #{account.inspect} not configured")
    end

    def account
      options[:account] || config.account || abort("Must specify account")
    end

    def config
      @config ||= Omc::Config.load
    end

    def vault
      AwsCredVault::Toml.new File.join(ENV['HOME'], '.aws_cred_vault')
    end
  end
end
