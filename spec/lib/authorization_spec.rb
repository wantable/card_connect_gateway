require 'spec_helper'

describe "Authorization" do
  response = CardConnectGateway.authorization()
  it { expect(response.class.name).to eq(CardConnectGateway::Authorization::Response.name) }
end