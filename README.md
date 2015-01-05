# Card Connect Gateway #
A Ruby API client that interfaces with card connect's REST api for credit card payment processing.

[Card Connect Documentation](http://www.cardconnect.com/developer/docs/)

### Setup ###

config/initializers/card_connect_gateway.rb

```ruby

  CardConnectGateway.configure do |config|
    config.test_mode = true
    config.merchant_id = ENV["CARD_CONNECT_MERCHANT_ID"]
    config.user_id = ENV['CARD_CONNECT_USER_ID']
    config.password = ENV['CARD_CONNECT_PASSWORD']
    config.debug = true
    config.require_avs_zip_code_match = true
    config.require_avs_address_match = false
    config.require_avs_customer_name_match = false
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

```

### Run Tests ###

``` 
  $ rake
  ....

  Finished in 0.00142 seconds (files took 0.09582 seconds to load)
  4 examples, 0 failures
```