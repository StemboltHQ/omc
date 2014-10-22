require 'thor'

module Omc
  class Cli < Thor
    desc 'ssh', 'Connect to an instance on a stack on an account'
    def ssh(account)
      puts account
      raise "please implement me"
    end
  end
end
