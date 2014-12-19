module CardConnectGateway
  class Configuration
    TEST_URL = 'fts.prinpay.com:6443'
    PRODUCTION_URL = '' # TODO

    attr_accessor :merchant_id, :user_id, :password, :test_mode

    def initialize
      self.test_mode = true
    end
  end
end