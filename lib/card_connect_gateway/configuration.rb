module CardConnectGateway
  class Configuration
    TEST_URL = 'fts.prinpay.com:6443'
    PRODUCTION_URL = '' # TODO

    attr_accessor :merchant_id, :user_id, :password, :test_mode, :url

    def initialize
      self.test_mode = true

      self.url = test_mode ? TEST_URL : PRODUCTION_URL
    end
  end
end