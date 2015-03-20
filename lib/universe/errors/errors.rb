module Universe
  module Errors
    class UsageError < RuntimeError; end
    class SystemUnspecifiedError < UsageError; end

    class AnsibleError < RuntimeError
      def initialize msg
        super "Ansible failed: #{msg}"
      end
    end
  end
end
