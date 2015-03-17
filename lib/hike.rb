#!/System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/ruby -W0

require 'pathname'

GAMEPLAN_VERSION = '0.0.0'

GAMEPLAN_LIB_PATH = Pathname.new(__FILE__).realpath.dirname.join('gameplan')
$LOAD_PATH.unshift(GAMEPLAN_LIB_PATH.to_s)

require 'global'

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

# Instant paralysis without Homebrew and Ansible.
homebrew = 'ruby -e "$(curl -fsSL'\
  'https://raw.githubusercontent.com/Homebrew/install/master/install)"'
system(homebrew, out: $stdout, err: :out) unless command? 'brew'

ansible = 'brew install ansible'
system(ansible, out: $stdout, err: :out) unless command? 'ansible-playbook'

exit 0
