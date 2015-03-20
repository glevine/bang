module Bang
  module Installers
    class System
      attr_reader :system

      def initialize system
        @system = system
      end

      def install
        Bang.alert "Expanding your universe with #{Bang::Utils::Tty.green}#{system.name}#{Bang::Utils::Tty.reset}"
        output = `(cd #{BANG_LIB} && ansible-playbook -K #{system.path}) 2>&1`
        raise Bang::Errors::AnsibleError, output unless $?.success?
        puts output
      end
    end
  end
end
