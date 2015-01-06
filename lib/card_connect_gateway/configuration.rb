module CardConnectGateway
  class Configuration
    TEST_URL = 'fts.prinpay.com:6443/cardconnect/rest'
    TEST_AJAX_URL = 'fts.prinpay.com/cardsecure/cs'

    PRODUCTION_URL = '' # TODO
    PRODUCTION_AJAX_URL = '' # TODO

    attr_accessor :merchant_id, :user_id, :password, :test_mode, :url, :debug, :supported_card_types, :require_avs_zip_code_match, :require_avs_address_match, :require_avs_customer_name_match, :ajax_url

    def initialize
      self.test_mode = true
      self.debug = false
      self.supported_card_types = [Base::VISA, Base::MASTERCARD, Base::AMEX, Base::DISCOVER]
      self.require_avs_zip_code_match = true
      self.require_avs_address_match = false
      self.require_avs_customer_name_match = false

      self.ajax_url = test_mode ? TEST_AJAX_URL : PRODUCTION_AJAX_URL
      self.url = test_mode ? TEST_URL : PRODUCTION_URL
    end
  end
end