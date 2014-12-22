require 'bundler/setup'
Bundler.setup

require 'card_connect_gateway'

CardConnectGateway.configure do |config|
  config.test_mode = true
  config.merchant_id = ENV["CARD_CONNECT_MERCHANT_ID"] || 'merchant_id'
  config.user_id = ENV['CARD_CONNECT_USER_ID'] || 'user_id'
  config.password = ENV['CARD_CONNECT_PASSWORD'] || 'password'
  config.debug = true
end

RSpec.configure do |config|
  # some (optional) config here
end
