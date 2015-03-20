require 'installers/system'

module Bang
  # Expand the universe by installing systems.
  def expand
    raise Errors::SystemUnspecifiedError if ARGV.named.empty?

    begin
      ARGV.systems.each { |s| Installers::System.new(s).install }
    rescue Errors::SystemUnavailableError => e
      Bang.fail e.message
    end
  end
end
