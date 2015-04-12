require 'galaxy'

module Bang
  class System
    # Match expressions when fully-qualified system names are given as ARGS, e.g. someuser/somegalaxy/somesystem.
    @@FQ_REGEX = %r{^([\w-]+)/([\w-]+)/([\w-]+)$}

    class << self
      def factory name
        p = path name
        raise Errors::SystemUnavailableError, name unless p.is_a? Pathname
        System.new name, p
      end

      def path name
        name =~ @@FQ_REGEX

        if $1 and $2 and $3
          # it's a fully-qualified system name
          p = Bang.galaxies?.join("#{$1.downcase}/#{$2.downcase}/systems/#{$3.downcase}.yml")
          return p if p.file?
        else
          Galaxy.list? do |user, repo|
            p = repo.join("systems/#{name.downcase}.yml")
            return p if p.file?
          end
        end
      end
    end

    attr_reader :name
    attr_reader :path

    def initialize name, path
      @name = name
      @path = path.resolved_path
    end

    def to_s
      name
    end
  end
end
