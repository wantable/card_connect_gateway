# Card Connect Gateway #
A Ruby API client that interfaces with card connect's REST api for credit card payment processing. [![Code Climate](https://codeclimate.com/repos/54ab06bee30ba014650091e0/badges/fcd7731ecb1fe3dd7856/gpa.svg)](https://codeclimate.com/repos/54ab06bee30ba014650091e0/feed) [![Build Status](https://magnum.travis-ci.com/wantable/card_connect_gateway.svg?token=5QxyH7sFBDYR4iimsFye&branch=AjaxTokenizer)](https://magnum.travis-ci.com/wantable/card_connect_gateway)

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

setup ajax tokenizer (if using)

```html
<script type="text/javascript">
    CARDCONNECT_AJAX_URL = CardConnectGateway.configuration.ajax_url
</script>
```

### Example Usage ###

#### Authorizations ####
```ruby

response = CardConnectGateway.authorization({
  account: '4788250000121443',
  expiry: '0921',
  cvv2: '112',
  postal: '19406'
})
response.valid?
#  => true 


response = CardConnectGateway.authorization({
  account: '5454545454545454',
  expiry: '0921',
  cvv2: '112',
  amount: 20,
  postal: '19111'
})
response.valid?
response.errors
#  => {:postal=>"doesn't match."} 

response.card_type
#  => "MasterCard" 

```

*NOTE: if authorizing from a token you must fill in card_type as well*

#### Profile ####

```ruby
# create
response = CardConnectGateway.create_profile({
  account: '4788250000121443',
  expiry: '0921'
})
response.valid? 
#  => true

# update
response2 = CardConnectGateway.update_profile({
  account: '5454545454545454',
  expiry_month: 9,
  expiry_year: 10,
  profile: response.profileid
})
response.valid? 
#  => true

```

#### Void ####

```ruby

response = CardConnectGateway.authorization({
  account: '4788250000121443',
  expiry: '0921',
  cvv2: '112',
  postal: '19406'
  capture: true,
  amount: 20
})

void = CardConnectGateway.void({
  retref: auth.retref
})

void.valid?
#  => true

```

#### Refund ####

``` ruby
response = CardConnectGateway.authorization({
  account: '4788250000121443',
  expiry: '0921',
  cvv2: '112',
  postal: '19406'
  capture: true,
  amount: 20
})

refund = CardConnectGateway.refund({
  retref: auth.retref
})

refund.valid?
# can't actually process one of these because you have to wait 24 hours
refund.errors 
#  => {PPS: "Txn not settled"}
```

#### Ajax tokenizer in angular ####

app/assets/javascripts/application.js.coffee.erb
```coffee
#= require ajax_tokenizer

Wantable = angular.module('Wantable', [ 'cardConnect'])
Wantable.controller 'CreditCardController',  (ajaxTokenizer) ->  
  ajaxTokenizer.tokenize('4788250000121443').then((tokenizedCard) ->
    # tokenizedCard => 
  )

### Compile CoffeeScript with Grunt ###
first install grunt

```
$ npm install -g grunt-cli
$ npm install grunt-contrib-coffee --save-dev
$ npm install grunt-contrib-watch --save-dev
```

run ```$ grunt watch```


### Run Tests ###

**rspec**

``` 
  $ CARD_CONNECT_MERCHANT_ID=[MERCHANT_ID] CARD_CONNECT_USER_ID=[USER_ID] CARD_CONNECT_PASSWORD=[PASSWORD] rake test
  ....

  Finished in 0.00142 seconds (files took 0.09582 seconds to load)
  4 examples, 0 failures
```

**jasmine**
``` $ rake jasmine ``` and visit localhost:8888