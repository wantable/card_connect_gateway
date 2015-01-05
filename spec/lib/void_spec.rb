require 'spec_helper'

describe "Void" do
  
  it { 
    response = CardConnectGateway.void()
    expect(response.class.name).to eq(CardConnectGateway::Void::Response.name) 
  }
end