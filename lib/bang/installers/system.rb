module Bang
  module Installers
    class System
      attr_reader :system

      def initialize system
        @system = system
      end

      def install
        Bang.alert "Expanding your universe with #{Bang::Utils::Tty.green}#{system.name}#{Bang::Utils::Tty.reset}"
        tz = Bang::Utils::Shell.timezone?
        output = `(cd #{BANG_LIB} && ansible-playbook -K #{system.path} --extra-vars "olson_tz=#{tz}") 2>&1`
        raise Bang::Errors::AnsibleError, output unless $?.success?
        puts output
      end
    end
  end
end
