require 'pathname'

class Pathname
  def resolved_path
    self.symlink? ? dirname+readlink : self
  end
end
