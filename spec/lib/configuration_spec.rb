require 'spec_helper'


CardConnectGateway.configure do |config|
  config.test_mode = true
  config.merchant_id = 'merchant_id'
  config.user_id = 'user_id'
  config.password = 'password'
end

describe "Configuration" do
  it { expect(CardConnectGateway.configuration.merchant_id).to eq('merchant_id') }
  it { expect(CardConnectGateway.configuration.user_id).to eq('user_id') }
  it { expect(CardConnectGateway.configuration.password).to eq('password') }
  it { expect(CardConnectGateway.configuration.test_mode).to eq(true) }
end