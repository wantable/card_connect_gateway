require 'bundler/setup'
Bundler.setup

require 'card_connect_gateway'

VISA_APPROVAL_ACCOUNT = '4788250000121443'
VISA_REFER_CALL_ACCOUNT = '4387751111111020'
VISA_DO_NOT_HONOR_ACCOUNT = '4387751111111038'
VISA_CARD_EXPIRED_ACCOUNT = '4387751111111046'
VISA_INSUFFICIENT_FUNDS_ACCOUNT = '4387751111111053'

VISA_AVS_MATCH_ZIP = '19406'
VISA_AVS_PARTIAL_MATCH_ZIP = '19113'

CVV_MATCH = '112'
CVV_MISMATCH = '111'
CVV_NOT_PROCESSED = '222'
CVV_UNKOWN = '333'

CardConnectGateway.configure do |config|
  config.test_mode = true
  config.merchant_id = ENV["CARD_CONNECT_MERCHANT_ID"]
  config.user_id = ENV['CARD_CONNECT_USER_ID']
  config.password = ENV['CARD_CONNECT_PASSWORD']
  config.debug = true
end

RSpec.configure do |config|
  # some (optional) config here
end
