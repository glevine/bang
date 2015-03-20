module Bang
  module Errors
    class UsageError < RuntimeError; end
    class SystemUnspecifiedError < UsageError; end

    class SystemUnavailableError < RuntimeError
      attr_reader :name

      def initialize name
        @name = name
      end

      def to_s
        "No available system for #{name}"
      end
    end

    class AnsibleError < RuntimeError
      def initialize msg
        super "Ansible failed: #{msg}"
      end
    end
  end
end
