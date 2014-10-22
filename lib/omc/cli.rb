require 'thor'
require 'aws_cred_vault'
require 'aws-sdk'
require "omc/stack_command"

module Omc
  class Cli < Thor
    desc 'ssh', 'Connect to an instance on a stack on an account'
    def ssh(account_name, stack)
      command = StackCommand.new(user(account), stack)
      command.ssh
    end

    desc 'console', 'Run a rails console on the given stack'
    def console(account, stack)
      command = StackCommand.new(user(account), stack)
      command.console
    end

    private
    def user(account)
      iam_account = vault.account(account) || abort("Account #{account.inspect} not configured")
      iam_account.users.first || abort("No users configured under #{account.inspect}")
    end

    def vault
      AwsCredVault::Toml.new File.join(ENV['HOME'], '.aws_cred_vault')
    end
  end
end
