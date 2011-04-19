require 'uri'

module Mobilove
  
  class Text
    def initialize(key, route, from)
      @key, @route, @from = key, route, from
    end
  
    def send(to, message, debug_mode = false)
      url = send_url(to, message, debug_mode)
      response = RestClient.get(url)
      respond(response)
    end
  
    private
  
    def send_url(to, message, debug_mode)
      "http://gw.mobilant.net/?key=#{@key}&to=#{to}&message=#{URI.escape(message)}&route=#{@route}&from=#{URI.escape(@from)}&debug=#{debug_mode ? '1' : '0'}"
    end
    
    def respond(response)
      case response.code.to_i
      when 100
        true
      when 10
        raise InvalidNumber.new(response.body)
      when 20
        raise InvalidSender.new(response.body)
      when 30
        raise MessageTooLong.new(response.body)
      when 31
        raise InvalidMessageType.new(response.body)
      when 40
        raise InvalidRoute.new(response.body)
      when 50
        raise AuthenticationFailed.new(response.body)
      when 60
        raise NoCreditLeft.new(response.body)
      when 70
        raise RouteCannotHandleProvider.new(response.body)
      when 71
        raise FeatureNotSupportedByRoute.new(response.body)
      when 80
        raise SMSCTransferFailed.new(response.body)
      else
        raise UnknownError.new("Response Code: #{response.code} // Response Body: #{response.body}")
      end
    end
  end
  
end