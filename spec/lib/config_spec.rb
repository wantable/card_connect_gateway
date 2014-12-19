require 'spec_helper'


CardConnectGateway.configure do |config|
  config.test_mode = true
  config.merchant_id = 'test_merchant_id'
  config.user_id = 'test_user_id'
  config.password = 'test_password'
end

describe Config do
  
  it "is configured" do
    CardConnectGateway.configuration.merchant_id.should eq('test_merchant_id')
    CardConnectGateway.configuration.user_id.should eq('test_user_id')
    CardConnectGateway.configuration.password.should eq('test_password')
    CardConnectGateway.configuration.test_mode.should eq(true)
  end
end