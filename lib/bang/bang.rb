require 'errors/errors'
require 'extensions/ARGV'
require 'utils/system'
require 'utils/tty'

ARGV.extend(Bang::Extensions::Argv)

module Bang
  extend self

  attr_accessor :failed
  alias_method :failed?, :failed

  def die msg
    err msg
    exit 1
  end

  def error msg
    $stderr.puts "#{Utils::Tty.red}Error#{Utils::Tty.reset}: #{msg}"
  end

  def fail msg
    err msg
    Bang.failed = true
  end

  def warn msg
    $stderr.puts "#{Utils::Tty.red}Warning#{Utils::Tty.reset}: #{warning}"
  end
end
