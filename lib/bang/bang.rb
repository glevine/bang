require 'errors/errors'
require 'extensions/ARGV'
require 'extensions/pathname'
require 'utils/shell'
require 'utils/tty'

ARGV.extend(Bang::Extensions::Argv)

module Bang
  extend self

  attr_accessor :failed
  alias_method :failed?, :failed

  def alert msg
    puts "#{Utils::Tty.green}==>#{Utils::Tty.white} #{msg}#{Utils::Tty.reset}"
  end

  def die msg
    error msg
    exit 1
  end

  def error msg
    $stderr.puts "#{Utils::Tty.red}Error#{Utils::Tty.reset}: #{msg}"
  end

  def fail msg
    error msg
    Bang.failed = true
  end

  def warn msg
    $stderr.puts "#{Utils::Tty.red}Warning#{Utils::Tty.reset}: #{warning}"
  end
end
