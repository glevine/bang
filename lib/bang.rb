#!/System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/ruby -W0

require 'pathname'

UNIVERSE_VERSION = '0.0.0'

UNIVERSE_LIB_PATH = Pathname.new(__FILE__).realpath.dirname.join('universe')
$LOAD_PATH.unshift(UNIVERSE_LIB_PATH.to_s)

require 'universe'

if ARGV.first == '--version'
  puts UNIVERSE_VERSION
  exit 0
elsif ARGV.first == '-v'
  puts "Universe #{UNIVERSE_VERSION}"
  # Shift the -v to the end of the parameter list.
  ARGV << ARGV.shift
  # If no other arguments, just quit here.
  exit 0 if ARGV.length == 1
end

# Many Pathname operations use getwd when they shouldn't, and then throw
# odd exceptions. Reduce our support burden by showing a user-friendly error.
Dir.getwd rescue abort "The current working directory doesn't exist, cannot proceed."

begin
  # Instant paralysis without Homebrew and Ansible.
  homebrew = 'ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
  system(homebrew, out: $stdout, err: :out) unless System.command? 'brew'

  ansible = 'brew install ansible'
  system(ansible, out: $stdout, err: :out) unless System.command? 'ansible-playbook'

  cmd = nil

  ARGV.dup.each_with_index do |arg, i|
    if !cmd
      cmd = ARGV.delete_at(i)
    end
  end

  internal_cmd = UNIVERSE_LIB_PATH.join('cmd', cmd)

  if internal_cmd
    require internal_cmd
    Universe.send cmd.to_s.gsub('-', '_').downcase
  else
    Universe.error "Unknown command: #{cmd}"
    exit 1
  end
rescue MatterUnspecifiedError
  abort 'This command requires a matter argument'
rescue SystemExit
  puts 'Kernel.exit'
  raise
rescue Interrupt => e
  puts # seemingly a newline is typical
  exit 130
rescue RuntimeError, SystemCallError => e
  raise if e.message.empty?
  Universe.error e
  puts e.backtrace
  exit 1
rescue Exception => e
  Universe.error e
  puts "#{Tty.white}Please report this bug:"
  puts e.backtrace
  exit 1
else
  exit 1 if Universe.failed?
end

exit 0
