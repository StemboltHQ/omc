require 'thor'
require 'aws_cred_vault'
require 'aws-sdk'
require "omc/stack_command"
require "omc/config"

module Omc
  class Cli < Thor
    class_option :account, aliases: '-a', optional: true

    desc 'ssh STACK', 'Connect to an instance on a stack on an account'
    def ssh(stack)
      command = StackCommand.new(user, stack)
      command.ssh
    end

    desc 'console STACK', 'Run a rails console on the given stack'
    def console(stack)
      command = StackCommand.new(user, stack)
      command.console
    end

    desc 'db STACK', 'Connect and run the database client on the given stack'
    def db(stack)
      command = StackCommand.new(user, stack)
      command.db
    end

    private
    def user
      iam_account = vault.account(account) || abort("Account #{account.inspect} not configured")
      iam_account.users.first || abort("No users configured under #{account.inspect}")
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
