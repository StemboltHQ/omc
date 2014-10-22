require 'thor'
require 'aws_cred_vault'

module Omc
  class Cli < Thor
    desc 'ssh', 'Connect to an instance on a stack on an account'
    def ssh(account)
      iam_account = vault.account account
      puts iam_account.name
    end

    private
    def vault
      AwsCredVault::Toml.new File.join(ENV['HOME'], '.shoelaces')
    end
  end
end
