module Universe
  module Installers
    class System
      attr_reader :system

      def initialize system
        @system = system
      end

      def install
        output = `(cd #{UNIVERSE_LIB_PATH}/.. && ansible-playbook -K #{@system.path}) 2>&1`

        if $?.success?
          puts output
        else
          raise Universe::Errors::AnsibleError, output
        end
      end
    end
  end
end
