require 'spec_helper'

describe "Configuration" do

  it 'saves configuration' do
    CardConnectGateway.configure do |config|
      config.test_mode = true
      config.merchant_id = 'merchant_id'
      config.user_id = 'user_id'
      config.password = 'password'
    end
    expect(CardConnectGateway.configuration.merchant_id).to eq('merchant_id')
    expect(CardConnectGateway.configuration.user_id).to eq('user_id') 
    expect(CardConnectGateway.configuration.password).to eq('password') 
    expect(CardConnectGateway.configuration.test_mode).to eq(true) 
  end
end