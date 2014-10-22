require 'thor'
require 'aws_cred_vault'
require 'aws-sdk'
require "omc/stack_command"

module Omc
  class Cli < Thor
    desc 'ssh', 'Connect to an instance on a stack on an account'
    def ssh(account, stack)
      iam_account = vault.account(account) || abort("Account #{account.inspect} not configured")
      user = iam_account.users.first || abort("No users configured under #{account.inspect}")

      command = StackCommand.new(user, stack)
      command.ssh
    end

    private
    def vault
      AwsCredVault::Toml.new File.join(ENV['HOME'], '.aws_cred_vault')
    end

  end
end
