module CardConnectGateway
  class Configuration
    TEST_URL = 'fts.prinpay.com:6443/cardconnect/rest'
    PRODUCTION_URL = '' # TODO

    attr_accessor :merchant_id, :user_id, :password, :test_mode, :url, :debug, :supported_card_types

    def initialize
      self.test_mode = true
      self.debug = false
      self.supported_card_types = [Base::VISA, Base::MASTERCARD, Base::AMEX, Base::DISCOVER]

      self.url = test_mode ? TEST_URL : PRODUCTION_URL
    end
  end
end