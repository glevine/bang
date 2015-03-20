#!/System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/ruby -W0

require 'pathname'

BANG_VERSION = '0.0.0'

BANG_LIB = Pathname.new(__FILE__).realpath.dirname
BANG_LIB_BANG = BANG_LIB.join('bang')
BANG_LIB_SYSTEMS = BANG_LIB.join('systems')
$LOAD_PATH.unshift(BANG_LIB_BANG.to_s) unless $LOAD_PATH.include?(BANG_LIB_BANG.to_s)

require 'bang'

if ARGV.first == '--version'
  puts BANG_VERSION
  exit 0
elsif ARGV.first == '-v'
  puts "Bang #{BANG_VERSION}"
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
  system(homebrew, out: $stdout, err: :out) unless Bang::Utils::Shell.command? 'brew'

  ansible = 'brew install ansible'
  system(ansible, out: $stdout, err: :out) unless Bang::Utils::Shell.command? 'ansible-playbook'

  cmd = nil

  ARGV.dup.each_with_index do |arg, i|
    if !cmd
      cmd = ARGV.delete_at(i)
    end
  end

  internal_cmd = BANG_LIB_BANG.join('cmd', cmd)

  if internal_cmd
    require internal_cmd
    Bang.send cmd.to_s.gsub('-', '_').downcase
  else
    Bang.error "Unknown command: #{cmd}"
    exit 1
  end
rescue Bang::Errors::SystemUnspecifiedError
  abort 'This command requires a system argument'
rescue Bang::Errors::AnsibleError => e
  Bang.error e
  exit 1
rescue SystemExit
  puts 'Kernel.exit'
  raise
rescue Interrupt => e
  puts # seemingly a newline is typical
  exit 130
rescue RuntimeError, SystemCallError => e
  raise if e.message.empty?
  Bang.error e
  puts e.backtrace
  exit 1
rescue Exception => e
  Bang.error e
  puts "#{Bang::Utils::Tty.white}Please report this bug:"
  puts e.backtrace
  exit 1
else
  exit 1 if Bang.failed?
end

exit 0
