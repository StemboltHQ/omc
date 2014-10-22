module Omc
  class StackCommand
    def initialize user, stack_name
      @user = user
      @stack_name = stack_name
    end

    def ssh
      instances = ops.describe_instances(stack_id: stack[:stack_id])[:instances]
      instances.reject!{|i| i[:status] != "online" }
      instance = instances.first || abort("No running instances")
      exec "ssh", "#{@user.name}@#{instance[:public_ip]}"
    end

    private
    def ops
      @ops ||= ::AWS::OpsWorks::Client.new @user.credentials
    end

    def stack
      @stack ||= get_by_name ops.describe_stacks[:stacks], @stack_name
    end

    def get_by_name collection, name
      collection.detect do |x|
        x[:name] == name
      end || abort("Can't find #{name.inspect} among #{collection.map{|x| x[:name] }.inspect}")
    end

  end
end
