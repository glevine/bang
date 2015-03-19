require 'extensions/ARGV'
require 'utils/exceptions'
require 'utils/system'
require 'utils/tty'

ARGV.extend(Universe::Extensions::Argv)

module Universe
  extend self

  attr_accessor :failed
  alias_method :failed?, :failed

  def die(msg)
    err msg
    exit 1
  end

  def error(msg)
    $stderr.puts "#{Tty.red}Error#{Tty.reset}: #{msg}"
  end

  def fail(msg)
    err msg
    Universe.failed = true
  end

  def warn(msg)
    $stderr.puts "#{Tty.red}Warning#{Tty.reset}: #{warning}"
  end
end
