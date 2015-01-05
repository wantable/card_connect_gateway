require 'bundler/setup'
Bundler.setup

require 'card_connect_gateway'

VISA_APPROVAL_ACCOUNT = '4788250000121443'
VISA_REFER_CALL_ACCOUNT = '4387751111111020'
VISA_DO_NOT_HONOR_ACCOUNT = '4387751111111038'
VISA_CARD_EXPIRED_ACCOUNT = '4387751111111046'
VISA_INSUFFICIENT_FUNDS_ACCOUNT = '4387751111111053'

MASTERCARD_APPROVAL_ACCOUNT = '5454545454545454'
AMEX_APPROVAL_ACCOUNT = '371449635398431'
DISCOVER_APPROVAL_ACCOUNT = '6011000995500000'
DINERS_APPROVAL_ACCOUNT = '36438999960016'
JCB_APPROVAL_ACCOUNT = '3528000000000007'

VISA_AVS_MATCH_ZIP = '19406'
VISA_AVS_PARTIAL_MATCH_ZIP = '19113'
MASTERCARD_ZIP_MISMATCH = '19111'
MASTERCARD_AVS_MISMATCH = '19112'

CVV_MATCH = '112'
CVV_MISMATCH = '111'
CVV_NOT_PROCESSED = '222'
CVV_UNKOWN = '333'

RSpec.configure do |config|
  config.before(:each) {
    CardConnectGateway.configure do |config|
      config.test_mode = true
      config.merchant_id = ENV["CARD_CONNECT_MERCHANT_ID"]
      config.user_id = ENV['CARD_CONNECT_USER_ID']
      config.password = ENV['CARD_CONNECT_PASSWORD']
      config.debug = true
      config.supported_card_types = [
        CardConnectGateway::Base::VISA, 
        CardConnectGateway::Base::MASTERCARD, 
        CardConnectGateway::Base::AMEX, 
        CardConnectGateway::Base::DISCOVER, 
        CardConnectGateway::Base::MAESTRO, 
        CardConnectGateway::Base::DINERS_CLUB, 
        CardConnectGateway::Base::JCB
      ]
    end
  }

end
