require 'spec_helper'


CardConnectGateway.configure do |config|
  config.test_mode = true
  config.merchant_id = 'test_merchant_id'
  config.user_id = 'test_user_id'
  config.password = 'test_password'
end

describe "Configuration" do
  it { expect(CardConnectGateway.configuration.merchant_id).to eq('test_merchant_id') }
  it { expect(CardConnectGateway.configuration.user_id).to eq('test_user_id') }
  it { expect(CardConnectGateway.configuration.password).to eq('test_password') }
  it { expect(CardConnectGateway.configuration.test_mode).to eq(true) }
end