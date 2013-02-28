# coding: utf-8
require 'rubygems'
require 'mobilove'
require 'rspec'

describe "Mobilove" do

  describe "Sending Texts" do
    before do
      stub_rest_client("100")
      @a = start_mobilant
    end

    it "should send text" do
      RestClient.should_receive(:get)
      @a.send_message(49123, 'sometext')
    end

    it "should return true" do
      @a.send_message(49123, 'yer').should be_true
    end

    it "should return true for unicode text" do
      @a.send_message(49123, 'some turkish text with an ı').should be_true
    end
  end

  describe "Handling Non-GSM 03.38 texts" do
    before do
      @a = start_mobilant
    end

    it "should detect non gsm chars" do
      gsm_text = "@£$¥èéùìòÇ\fØø\nÅåΔ_ΦΓΛΩΠΨΣΘΞÆæßÉ !\"#¤%&'()*+,-./0123456789:;<=>\?¡ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÑÜ§¿abcdefghijklmnopqrstuvwxyzäöñüà\^\{\}\[~\]\|€"
      @a.send(:is_gsm0338_encoded?, gsm_text).should be_true
      @a.send(:is_gsm0338_encoded?, "Tım").should be_false
    end

    it "should transform utf8 to hexadecimal code points" do
      @a.send(:string_to_hexadecimal_code_points, "arasında").should eql("00610072006100730131006e00640061")
    end

    it "should raise Error for trying convert non utf-8 string" do
      lambda do
        @a.send(:string_to_hexadecimal_code_points, 42)
      end.should raise_error(Mobilove::MessageIsNoUtf8String)

      lambda do
        @a.send(:string_to_hexadecimal_code_points, "utf-8 text".encode(Encoding::UTF_16BE).unpack('n*'))
      end.should raise_error(Mobilove::MessageIsNoUtf8String)
    end
  end

  describe "Error Handling" do

   describe "Invalid Number" do
      before do
        stub_rest_client("10")
        @a = start_mobilant
      end

      it "should raise an InvalidNumber exception" do
        lambda do
          @a.send_message(49123, 'test')
        end.should raise_error(Mobilove::InvalidNumber)
      end
    end

    describe "InvalidSender" do
      before do
        stub_rest_client("20")
        @a = start_mobilant
      end

      it "should raise an InvalidSender exception" do
        lambda do
          @a.send_message(49123, 'test')
        end.should raise_error(Mobilove::InvalidSender)
      end
    end

    describe "MessageTooLong" do
      before do
        stub_rest_client("30")
        @a = start_mobilant
      end

      it "should raise an MessageTooLong exception" do
        lambda do
          @a.send_message(49123, 'test')
        end.should raise_error(Mobilove::MessageTooLong)
      end
    end

    describe "InvalidMessageType" do
      before do
        stub_rest_client("31")
        @a = start_mobilant
      end

      it "should raise an InvalidMessageType exception" do
        lambda do
          @a.send_message(49123, 'test')
        end.should raise_error(Mobilove::InvalidMessageType)
      end
    end

    describe "InvalidRoute" do
      before do
        stub_rest_client("40")
        @a = start_mobilant
      end

      it "should raise an InvalidRoute exception" do
        lambda do
          @a.send_message(49123, 'test')
        end.should raise_error(Mobilove::InvalidRoute)
      end
    end

    describe "AuthenticationFailed" do
      before do
        stub_rest_client("50")
        @a = start_mobilant
      end

      it "should raise an AuthenticationFailed exception" do
        lambda do
          @a.send_message(49123, 'test')
        end.should raise_error(Mobilove::AuthenticationFailed)
      end
    end

    describe "NoCreditLeft" do
      before do
        stub_rest_client("60")
        @a = start_mobilant
      end

      it "should raise an NoCreditLeft exception" do
        lambda do
          @a.send_message(49123, 'test')
        end.should raise_error(Mobilove::NoCreditLeft)
      end
    end

    describe "RouteCannotHandleProvider" do
      before do
        stub_rest_client("70")
        @a = start_mobilant
      end

      it "should raise an RouteCannotHandleProvider exception" do
        lambda do
          @a.send_message(49123, 'test')
        end.should raise_error(Mobilove::RouteCannotHandleProvider)
      end
    end

    describe "FeatureNotSupportedByRoute" do
      before do
        stub_rest_client("71")
        @a = start_mobilant
      end

      it "should raise an FeatureNotSupportedByRoute exception" do
        lambda do
          @a.send_message(49123, 'test')
        end.should raise_error(Mobilove::FeatureNotSupportedByRoute)
      end
    end

    describe "SMSCTransferFailed" do
      before do
        stub_rest_client("80")
        @a = start_mobilant
      end

      it "should raise an SMSCTransferFailed exception" do
        lambda do
          @a.send_message(49123, 'test')
        end.should raise_error(Mobilove::SMSCTransferFailed)
      end
    end

    describe "Unknown Error" do
      before do
        stub_rest_client("999")
        @a = start_mobilant
      end

      it "should raise an UnknownError exception" do
        lambda do
          @a.send_message(49123, 'test')
        end.should raise_error(Mobilove::UnknownError)
      end
    end

  end

  private

  def start_mobilant
    Mobilove::Text.new('key', 'route_id', 'sender_name')
  end

  def stub_rest_client(code)
    response = build_response(code)
    RestClient.stub!(:get).and_return(response)
  end

  def build_response(code)
    response = Struct.new(:code, :body)
    response.new(code, 'body')
  end

end
