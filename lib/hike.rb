#!/System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/ruby -W0

require 'pathname'

GAMEPLAN_VERSION = '0.0.0'

GAMEPLAN_LIB_PATH = Pathname.new(__FILE__).realpath.dirname.join('gameplan')
$LOAD_PATH.unshift(GAMEPLAN_LIB_PATH.to_s)

require 'gameplan'

if ARGV.first == '--version'
  puts GAMEPLAN_VERSION
  exit 0
elsif ARGV.first == '-v'
  puts "Gameplan #{GAMEPLAN_VERSION}"
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

  internal_cmd = GAMEPLAN_LIB_PATH.join('cmd', cmd)

  if internal_cmd
    require internal_cmd
    Gameplan.send cmd.to_s.gsub('-', '_').downcase
  else
    Gameplan.error "Unknown command: #{cmd}"
    exit 1
  end
rescue PlayUnspecifiedError
  abort 'This command requires a play argument'
rescue PackageUnspecifiedError
  abort 'This command requires a package argument'
rescue SystemExit
  puts 'Kernel.exit'
  raise
rescue Interrupt => e
  puts # seemingly a newline is typical
  exit 130
rescue RuntimeError, SystemCallError => e
  raise if e.message.empty?
  Gameplan.error e
  puts e.backtrace
  exit 1
rescue Exception => e
  Gameplan.error e
  puts "#{Tty.white}Please report this bug:"
  puts e.backtrace
  exit 1
else
  exit 1 if Gameplan.failed?
end

exit 0
