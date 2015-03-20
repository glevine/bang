module Bang
  module Utils
    class Shell
      class << self
        def command?(name)
          `command -v #{name}`
          $?.success?
        end
      end
    end
  end
end
