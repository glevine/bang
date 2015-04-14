require 'galaxy'
require 'installers/galaxy'

module Bang
  # Update bang and the galaxies.
  def update
    unless ARGV.named.empty?
      abort <<-EOS.undent
        This command updates bang itself and does not take system names.
      EOS
    end

    updater = Updater.new BANG_REPO
    begin
      updater.pull!
    rescue
      Bang.fail 'Failed to update bang'
    else
      Bang.alert 'Updated bang'
    end

    Galaxy.list? do |user, repo|
      repo.cd do
        updater = Updater.new repo
        begin
          updater.pull!
        rescue
          Bang.fail "Failed to update galaxy: #{user.basename}/#{repo.basename}"
        else
          Bang.alert "Updated galaxy: #{user.basename}/#{repo.basename}"
        end
      end
    end
  end

  class Updater
    attr_reader :initial_revision, :current_revision, :repository

    def initialize repository
      @repository = repository
    end

    def pull!
      `git checkout -q master`

      @initial_revision = read_current_revision

      # ensure we don't munge line endings on checkout
      `git config core.autocrlf false`

      # the refspec ensures that 'origin/master' gets updated
      reset_on_interrupt { `git pull origin refs/heads/master:refs/remotes/origin/master` }

      @current_revision = read_current_revision
    end

    def reset_on_interrupt
      Bang::Utils::Shell.ignore_interrupts { yield }
    ensure
      if $?.signaled? and $?.termsig == 2 # SIGINT
        `git reset --hard #{@initial_revision}`
      end
    end

    private

    def read_current_revision
      `git rev-parse -q --verify HEAD`.chomp
    end
  end
end
