require 'installers/system'

module Universe
  # Expand the universe by installing matter.
  def expand
    raise Universe::Errors::SystemUnspecifiedError if ARGV.named.empty?

    systems = []

    ARGV.systems.each do |s|
      Installers::System.new(s).install
    end
  end
end
