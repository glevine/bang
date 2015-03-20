require 'installers/system'

module Bang
  # Expand the universe by installing systems.
  def expand
    raise Bang::Errors::SystemUnspecifiedError if ARGV.named.empty?

    systems = []

    ARGV.systems.each do |s|
      Installers::System.new(s).install
    end
  end
end
