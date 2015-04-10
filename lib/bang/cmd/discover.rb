require 'installers/galaxy'

module Bang
  # Discover new sources of software by installing galaxies.
  def discover
    begin
      Installers::Galaxy.new(*galaxy_args).install
    rescue Errors::GalaxyAlreadyExistsError => e
      Bang.warn e.message
    rescue Errors::GalaxyUnavailableError => e
      Bang.fail e.message
    end
  end

  private

  # Match expressions when galaxies are given as ARGS, e.g. someuser/somegalaxy.
  def galaxy_args(name=ARGV.first)
    galaxies_args_regex = %r{^([\w-]+)/([\w-]+)$}
    name =~ galaxies_args_regex
    raise Errors::GalaxyUnavailableError, name unless $1 and $2
    [$1, $2]
  end
end
