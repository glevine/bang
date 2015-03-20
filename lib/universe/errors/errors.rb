module Universe
  module Errors
    class UsageError < RuntimeError; end
    class SystemUnspecifiedError < UsageError; end
  end
end
