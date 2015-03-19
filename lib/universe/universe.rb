require 'errors/errors'
require 'extensions/ARGV'
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
    $stderr.puts "#{Utils::Tty.red}Error#{Utils::Tty.reset}: #{msg}"
  end

  def fail(msg)
    err msg
    Universe.failed = true
  end

  def warn(msg)
    $stderr.puts "#{Utils::Tty.red}Warning#{Utils::Tty.reset}: #{warning}"
  end
end
