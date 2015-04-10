module Bang
  module Installers
    class Galaxy
      attr_reader :galaxy

      def initialize galaxy
        @galaxy = galaxy
      end

      def install
        raise Bang::Errors::GalaxyAlreadyExistsError, galaxy.to_s if galaxy.path.directory?
        Bang.alert "Discovering the galaxy named #{Bang::Utils::Tty.green}#{galaxy.name}#{Bang::Utils::Tty.reset}"
        abort unless system 'git', 'clone', "https://github.com/#{galaxy.name}", galaxy.path.to_s
      end
    end
  end
end
