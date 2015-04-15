require 'galaxy'
require 'installers/galaxy'

module Bang
  # Prints caveats.
  def caveats
    shell = universe?.join 'shell'
    if shell.directory?
      alert "Source the following files in your shell configuration..." if shell.children.length > 0
      shell.children.sort.each do |file|
        puts "#{file}" unless file.basename.to_s == '.DS_Store'
      end
    end

    ssh_key = Pathname.new("#{ENV['HOME']}/.ssh/id_rsa.pub")
    if ssh_key.file?
      alert "Add your SSH key to your GitHub account if you haven't already..."
      puts 'Use the following command to copy your id_rsa.pub file to your clipboard:'
      puts "$ pbcopy < #{ssh_key}"
    end
  end
end
