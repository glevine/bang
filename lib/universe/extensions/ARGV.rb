module Universe
  module Extensions
    module Argv
      def named
        @named ||= self - options_only
      end

      def options_only
        select { |arg| arg.start_with?('-') }
      end

      def flags_only
        select { |arg| arg.start_with?('--') }
      end

      def systems
        @systems ||= downcased_unique_named.map { |name| puts name }
      end

      def include? arg
        @n=index arg
      end

      def next
        at @n+1 or raise Universe::Errors::UsageError
      end

      def value arg
        arg = find {|o| o =~ /--#{arg}=(.+)/}
        $1 if arg
      end

      private

      def downcased_unique_named
        # Only lowercase names, not paths or URLs
        @downcased_unique_named ||= named.map do |arg|
          arg.include?('/') ? arg : arg.downcase
        end.uniq
      end
    end
  end
end
