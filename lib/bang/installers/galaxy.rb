module Bang
  module Installers
    class Galaxy
      attr_reader :user
      attr_reader :repo
      attr_reader :name

      def initialize user, repo
        @user = user
        @repo = repo
        @name = "#{@user}/#{@repo}"
      end

      def install
        galaxy_dir = Bang.galaxies?.join("#{@user.downcase}/#{@repo.downcase}")
        raise Bang::Errors::GalaxyAlreadyExistsError, @name if galaxy_dir.directory?

        Bang.alert "Discovering the galaxy named #{Bang::Utils::Tty.green}#{@name}#{Bang::Utils::Tty.reset}"
        abort unless system 'git', 'clone', "https://github.com/#{@name}", galaxy_dir.to_s
      end
    end
  end
end
