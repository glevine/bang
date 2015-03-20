module Bang
  class System
    class << self
      def factory name
        p = path name
        raise Errors::SystemUnavailableError, name unless p.file?
        System.new name, p
      end

      def path name
        Pathname.new "#{BANG_LIB_SYSTEMS}/#{name.downcase}.yml"
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
