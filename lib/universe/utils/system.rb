class System
  class << self
    def command?(name)
      `command -v #{name}`
      $?.success?
    end
  end
end
