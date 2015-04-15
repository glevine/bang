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
        Kernel.system 'ansible-playbook', '-K', system.path.to_s, '--extra-vars', "universe=#{Bang.universe?} olson_tz=#{tz}", :chdir => BANG_LIB.to_s, out: $stdout, err: :out

        ENV.delete 'ANSIBLE_ROLES_PATH'
        raise Bang::Errors::AnsibleError, "exited with status #{$?.exitstatus}" unless $?.success?

        return
      end
    end
  end
end
