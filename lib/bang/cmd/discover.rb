require 'galaxy'
require 'installers/galaxy'

module Bang
  # Discover new sources of software by installing galaxies.
  def discover
    begin
      galaxy = Galaxy.factory(ARGV.first)
      Installers::Galaxy.new(galaxy).install
    rescue Errors::GalaxyAlreadyExistsError => e
      Bang.warn e.message
    rescue Errors::GalaxyUnavailableError => e
      Bang.fail e.message
    end
  end
end
