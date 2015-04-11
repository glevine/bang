require 'galaxy'

module Bang
  class System
    class << self
      def factory name
        p = path name
        raise Errors::SystemUnavailableError, name unless p.file?
        System.new name, p
      end

      def path name
        Galaxy.list? do |user, repo|
          p = repo.join("systems/#{name.downcase}.yml")
          return p if p.file?
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
