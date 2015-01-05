require 'spec_helper'

describe "Capture" do
  
  it { 
    response = CardConnectGateway.capture()
    expect(response.class.name).to eq(CardConnectGateway::Capture::Response.name) 
  }
end