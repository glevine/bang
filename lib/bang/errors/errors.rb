module Bang
  module Errors
    class UsageError < RuntimeError; end
    class SystemUnspecifiedError < UsageError; end

    class GalaxyUnavailableError < RuntimeError
      def initialize name
        super "No available galaxy for #{name}"
      end
    end

    class GalaxyAlreadyExistsError < RuntimeError
      def initialize name
        super "Galaxy #{name} has already been discovered"
      end
    end

    class SystemUnavailableError < RuntimeError
      def initialize name
        super "No available system for #{name}"
      end
    end

    class AnsibleError < RuntimeError
      def initialize msg
        super "Ansible failed: #{msg}"
      end
    end
  end
end
