module Bang
  module Installers
    class System
      attr_reader :system

      def initialize system
        @system = system
      end

      def install
        output = `(cd #{BANG_LIB} && ansible-playbook -K #{@system.path}) 2>&1`

        if $?.success?
          puts output
        else
          raise Bang::Errors::AnsibleError, output
        end
      end
    end
  end
end
