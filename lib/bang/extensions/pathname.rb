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

  def cd
    Dir.chdir(self){ yield }
  end

  def subdirs
    children.select{ |child| child.directory? }
  end
end
