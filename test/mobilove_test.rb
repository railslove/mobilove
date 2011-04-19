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
      @a.send(49123, 'sometext')
    end
    
    it "should return true" do
      @a.send(49123, 'yer').should be_true
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
          @a.send(49123, 'test')
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
          @a.send(49123, 'test')
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
          @a.send(49123, 'test')
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
          @a.send(49123, 'test')
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
          @a.send(49123, 'test')
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
          @a.send(49123, 'test')
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
          @a.send(49123, 'test')
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
          @a.send(49123, 'test')
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
          @a.send(49123, 'test')
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
          @a.send(49123, 'test')
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
          @a.send(49123, 'test')
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
