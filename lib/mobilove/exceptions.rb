module Mobilove

  class InvalidNumber < Exception
  end

  class InvalidSender < Exception
  end

  class MessageTooLong < Exception
  end

  class InvalidMessageType < Exception
  end

  class InvalidRoute < Exception
  end

  class AuthenticationFailed < Exception
  end

  class NoCreditLeft < Exception
  end

  class RouteCannotHandleProvider < Exception
  end

  class FeatureNotSupportedByRoute < Exception
  end

  class SMSCTransferFailed < Exception
  end

  class UnknownError < Exception
  end

  class MessageIsNoUtf8String < Exeption
  end

end
