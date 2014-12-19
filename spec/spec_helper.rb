require 'bundler/setup'
Bundler.setup

require 'card_connect_gateway'

CardConnectGateway.configure do |config|
  config.test_mode = true
  config.merchant_id = ENV["CARD_CONNECT_MERCHANT_ID"]
  config.user_id = 'CARD_CONNECT_USER_ID'
  config.password = 'CARD_CONNECT_PASSWORD'
end

RSpec.configure do |config|
  # some (optional) config here
end
