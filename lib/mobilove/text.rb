# coding: utf-8
require 'uri'
require 'iconv'

module Mobilove

  class Text
    def initialize(key, route, from)
      @key, @route, @from = key, route, from
    end

    def send_message(to, message, options={})
      url = send_url(to, message, options)
      response = RestClient.get(url)
      respond(response)
    end

    private

    # :debug_mode => true  //  Message will not be sent
    # :concat     => true  //  Message will be sent as concatenated texts if it has more than 160 chars (70 unicode)
    def send_url(to, message, options={})
      options[:debug_mode] ||= false
      options[:concat] ||= false
      if is_gsm0338_encoded? message
        "http://gw.mobilant.net/?key=#{@key}&to=#{to}&message=#{URI.escape(message)}&route=#{@route}&from=#{URI.escape(@from)}&debug=#{options[:debug_mode] ? '1' : '0'}&charset=utf-8&concat=#{options[:concat] ? '1' : '0'}"
      else
        "http://gw.mobilant.net/?key=#{@key}&to=#{to}&message=#{string_to_hexadecimal_code_points(message)}&route=#{@route}&from=#{URI.escape(@from)}&debug=#{options[:debug_mode] ? '1' : '0'}&messagetype=unicode&concat=#{options[:concat] ? '1' : '0'}"
      end
    end

    def is_gsm0338_encoded?(message)
      gsm0338 = "@£$¥èéùìòÇ\fØø\nÅåΔ_ΦΓΛΩΠΨΣΘΞÆæßÉ !\"#¤%&'()*+,-./0123456789:;<=>\?¡ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÑÜ§¿abcdefghijklmnopqrstuvwxyzäöñüà\^\{\}\[~\]\|€"
      message.each_char {|c| return false unless gsm0338.include?(c)}
      return true
    end

    def string_to_hexadecimal_code_points(message)
      if message.class.to_s == 'String' && message.encoding.to_s == 'UTF-8'
        hex_code = ''
        Iconv.iconv("UCS-2", "utf-8", message).first.each_char {|unicode_char| hex_code += unicode_char.unpack('H*').first}
        hex_code
      else
        raise MessageIsNoUtf8String.new("The message is either not a string or not UTF-8 encoded. MESSAGE: #{message}")
      end
    end

    def respond(response)
      case response.code.to_i
      when 100
        true
      when 200
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
