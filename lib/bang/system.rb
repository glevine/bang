module Bang
  class System
    attr_reader :name

    def initialize name
      @name = name
    end

    def path
      "#{BANG_LIB_SYSTEMS}/#{@name}.yml"
    end
  end
end
