module Bang
  module Installers
    class System
      attr_reader :system

      def initialize system
        @system = system
      end

      def install
        roles_path = Array.new

        Galaxy.list? do |user, repo|
          p = repo.join('matter')
          roles_path << p if p.directory?
        end

        ENV['ANSIBLE_ROLES_PATH'] = roles_path.join(':')
        tz = Bang::Utils::Shell.timezone?

        Bang.alert "Expanding your universe with #{Bang::Utils::Tty.green}#{system.name}#{Bang::Utils::Tty.reset}"
        output = `(cd #{BANG_LIB} && ansible-playbook -K #{system.path} --extra-vars "universe=#{Bang.universe?} olson_tz=#{tz}") 2>&1`

        raise Bang::Errors::AnsibleError, output unless $?.success?
        puts output

        ENV.delete 'ANSIBLE_ROLES_PATH'
        return
      end
    end
  end
end
