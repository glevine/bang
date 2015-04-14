require 'galaxy'
require 'installers/galaxy'

module Bang
  # Prints caveats.
  def caveats
    shell = universe?.join 'shell'
    alert "Source the following files in your shell configuration..." if shell.children.length > 0
    shell.children.sort.each do |file|
      puts "#{file}" unless file.basename.to_s == '.DS_Store'
    end if shell.directory?
  end
end
