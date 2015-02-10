require 'spec_helper'

describe "Configuration" do

  it 'configuration is saved from helper' do
    expect(CardConnectGateway.configuration.merchant_id).to eq(ENV["CARD_CONNECT_MERCHANT_ID"])
    expect(CardConnectGateway.configuration.user_id).to eq(ENV['CARD_CONNECT_USER_ID']) 
    expect(CardConnectGateway.configuration.password).to eq(ENV['CARD_CONNECT_PASSWORD']) 
    expect(CardConnectGateway.configuration.test_mode).to eq(true) 
    expect(CardConnectGateway.configuration.url).to eq(CardConnectGateway::Configuration::TEST_URL)
    expect(CardConnectGateway.configuration.ajax_url).to eq(CardConnectGateway::Configuration::TEST_AJAX_URL) 
  end

  it 'environment is set' do
    expect(ENV["CARD_CONNECT_MERCHANT_ID"]).not_to be_nil
    expect(ENV["CARD_CONNECT_USER_ID"]).not_to be_nil
    expect(ENV["CARD_CONNECT_PASSWORD"]).not_to be_nil
  end
end