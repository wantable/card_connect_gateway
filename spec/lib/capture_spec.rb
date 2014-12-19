require 'spec_helper'

describe "Capture" do
  response = CardConnectGateway.capture()
  it { expect(response.class.name).to eq(CardConnectGateway::Capture::Response.name) }
end