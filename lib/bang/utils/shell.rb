module Bang
  module Utils
    class Shell
      class << self
        def command?(name)
          `command -v #{name}`
          $?.success?
        end

        # Taken from https://stackoverflow.com/a/12523283.
        def timezone?
          p = Pathname.new '/etc/timezone'
          return `cat /etc/timezone`.strip if p.file?

          p = Pathname.new '/etc/localtime'
          return `readlink /etc/localtime | sed "s#/usr/share/zoneinfo/##"`.strip if p.symlink?

          checksum = `md5sum /etc/localtime | cut -d' ' -f1`
          return `find /usr/share/zoneinfo/ -type f -exec md5sum {} \; | grep "^#{checksum}" | sed "s#.*/usr/share/zoneinfo/##" | head -n 1`.strip
        end
      end
    end
  end
end
