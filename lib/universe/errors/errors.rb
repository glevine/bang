module Universe
  module Errors
    class UsageError < RuntimeError; end
    class MatterUnspecifiedError < UsageError; end
  end
end
