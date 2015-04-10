require 'pathname'

class Pathname
  class << self
    def create_path path
      FileUtils.mkpath path
      Pathname.new(path).realpath
    end
  end

  def resolved_path
    self.symlink? ? dirname+readlink : self
  end
end
