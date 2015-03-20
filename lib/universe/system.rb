module Universe
  class System
    attr_reader :name
    attr_reader :path

    def initialize name
      @name = name
      @path = "#{UNIVERSE_LIB_PATH}/../systems/#{@name}.yml"
    end
  end
end
