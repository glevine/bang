module Bang
  class Galaxy
    # Match expressions when galaxies are given as ARGS, e.g. someuser/somegalaxy.
    @@ARGS_REGEX = %r{^([\w-]+)/([\w-]+)$}

    class << self
      def factory name
        name =~ @@ARGS_REGEX
        raise Errors::GalaxyUnavailableError, name unless $1 and $2

        p = path $1, $2
        Galaxy.new $1, $2, p
      end

      def path user, repo
        Bang.galaxies?.join("#{user.downcase}/#{repo.downcase}")
      end
    end

    attr_reader :user
    attr_reader :repo
    attr_reader :path
    attr_reader :name

    def initialize user, repo, path
      @user = user
      @repo = repo
      @path = path.resolved_path
      @name = "#{user}/#{repo}"
    end

    def to_s
      name
    end
  end
end
