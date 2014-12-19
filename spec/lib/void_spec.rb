require 'spec_helper'

describe "Void" do
  response = CardConnectGateway.void()
  it { expect(response.class.name).to eq(CardConnectGateway::Void::Response.name) }
end