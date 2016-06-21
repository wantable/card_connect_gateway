require 'spec_helper'

describe "Authorization" do
  it 'request validates' do 
    APPROVAL_ACCOUNTS.each do |account|
      request = CardConnectGateway::Authorization::Request.new({
        account: account,
        expiry: EXPIRY,
        cvv2: CVV_MATCH,
        postal: VISA_AVS_MATCH_ZIP
      })
      request.validate
      expect(request.errors).to eq({})
      expect(request.account).to eq(account)
      expect(request.expiry).to eq(EXPIRY)
      expect(request.merchid).to eq(CardConnectGateway.configuration.merchant_id) 
    end
  end

  it 'request validates with month/year' do
    APPROVAL_ACCOUNTS.each do |account|
      request = CardConnectGateway::Authorization::Request.new({
        account: account,
        expiry_month: 9,
        expiry_year: 10,
        cvv2: CVV_MATCH,
        postal: VISA_AVS_MATCH_ZIP
      })
      expect(request.expiry).to eq('0910') 
      expect(request.errors).to eq({})
      expect(request.validate).to eq(true)
    end
  end

  it 'fail validation' do
    request = CardConnectGateway::Authorization::Request.new({tokenize: 'A', expiry: 'asdf'})
    expect(request.validate).to eq(false)
    expect(request.errors[:account]).to eq(I18n.t(:is_required))
    expect(request.errors[:tokenize]).to eq(I18n.t(:must_be_one_of, options: CardConnectGateway::Authorization::Request.attributes[:tokenize][:options]))
    expect(request.errors[:expiry]).to eq(I18n.t(:doesnt_match_the_format))
  end

  it 'fail validation from auth' do
    request = CardConnectGateway.authorization({tokenize: 'A', expiry: 'asdf'})

    expect(request.errors[:account]).to eq(I18n.t(:is_required))
    expect(request.errors[:tokenize]).to eq(I18n.t(:must_be_one_of, options: CardConnectGateway::Authorization::Request.attributes[:tokenize][:options]))
    expect(request.errors[:expiry]).to eq(I18n.t(:doesnt_match_the_format))
    
    expect(request.class.name).to eq(CardConnectGateway::Authorization::Request.name) 
  end

  it 'api fail with bad password' do
    CardConnectGateway.configuration.password = "wrongpassword"
    expect{ 
      CardConnectGateway.authorization({
        account: VISA_APPROVAL_ACCOUNT,
        expiry: EXPIRY,
        cvv2: CVV_MATCH,
        postal: VISA_AVS_MATCH_ZIP
      })}
      .to raise_error(RestClient::Unauthorized)
  end

  it 'auth successfully' do
    APPROVAL_ACCOUNTS.each do |account|
      response = CardConnectGateway.authorization({
        account: account,
        expiry: EXPIRY,
        cvv2: CVV_MATCH,
        postal: VISA_AVS_MATCH_ZIP
      })
      response.validate
      expect(response.errors).to eq({}) 
      expect(response.valid?).to eq(true)
      expect(response.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
    end
  end


  it 'test user fields' do
    APPROVAL_ACCOUNTS.each do |account|
      response = CardConnectGateway.authorization({
        account: account,
        expiry: EXPIRY,
        cvv2: CVV_MATCH,
        postal: VISA_AVS_MATCH_ZIP,
        userfields: {
          order_id: 'test-order-id',
          customer_email: 'customer@email.com',
          int_value: 90
        }
      })
      response.validate
      expect(response.errors).to eq({}) 
      expect(response.valid?).to eq(true)
      expect(response.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
    end
  end

  it 'international cards' do
    APPROVAL_ACCOUNTS.each do |account|
      response = CardConnectGateway.authorization({
        account: account,
        expiry: EXPIRY,
        cvv2: CVV_MATCH,
        postal: '2060',
        country: 'CA'
      })
      response.validate
      expect(response.errors).to eq({}) 
      expect(response.valid?).to eq(true)
      expect(response.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
    end
  end

  it 'auth fail with refer call' do
    fail = CardConnectGateway.authorization({
      account: VISA_REFER_CALL_ACCOUNT,
      expiry: EXPIRY,
      cvv2: CVV_MATCH,
      postal: VISA_AVS_MATCH_ZIP
    })
    expect(fail.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
    expect(fail.valid?).to eq(false)
    expect(fail.errors).to eq({FNOR: "Refer to issuer"}) 
  end

  it 'auth fail with do not honor' do
    DO_NOT_HONOR_ACCOUNTS.each do |account|
      fail = CardConnectGateway.authorization({
        account: account,
        expiry: EXPIRY,
        cvv2: CVV_MATCH,
        postal: VISA_AVS_MATCH_ZIP
      })
      expect(fail.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
      expect(fail.valid?).to eq(false)
      expect(fail.errors).to eq({FNOR: "Do not honor"}) 
    end
  end

  it 'auth fail with expired account' do
    CARD_EXPIRED_ACCOUNTS.each do |account|
      fail = CardConnectGateway.authorization({
        account: account,
        expiry: EXPIRY,
        cvv2: CVV_MATCH,
        postal: VISA_AVS_MATCH_ZIP
      })
      expect(fail.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
      expect(fail.valid?).to eq(false)
      expect(fail.errors).to eq({FNOR: "Wrong expiration"}) 
    end
  end

  it 'auth fail with insufficient funds' do
    INSUFFICIENT_FUNDS_ACCOUNT.each do |account|
      fail = CardConnectGateway.authorization({
        account: account,
        expiry: EXPIRY,
        cvv2: CVV_MATCH,
        postal: VISA_AVS_MATCH_ZIP
      })
      expect(fail.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
      expect(fail.valid?).to eq(false)
      expect(fail.errors).to eq({FNOR: "Insufficient funds"}) 
    end
  end

  it 'auth fail with cvv mismatch' do
    fail = CardConnectGateway.authorization({
      account: VISA_APPROVAL_ACCOUNT,
      cvv2: CVV_MISMATCH,
      expiry: EXPIRY,
      postal: VISA_AVS_MATCH_ZIP
    })
    expect(fail.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
    expect(fail.valid?).to eq(false)
    expect(fail.errors).to eq({cvv2: I18n.t(:doesnt_match)}) 
  end

  it 'auth fail with cvv not processed' do
    APPROVAL_ACCOUNTS.each do |account|
      fail = CardConnectGateway.authorization({
        account: account,
        cvv2: CVV_NOT_PROCESSED,
        expiry: EXPIRY,
        postal: VISA_AVS_MATCH_ZIP
      })
      expect(fail.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
      expect(fail.valid?).to eq(false)
      expect(fail.errors).to eq({cvv2: I18n.t(:unknown_error)}) 
    end
  end


  it 'auth fail with cvv unknown' do
    APPROVAL_ACCOUNTS.each do |account|
      fail = CardConnectGateway.authorization({
        account: account,
        cvv2: CVV_UNKNOWN,
        expiry: EXPIRY,
        postal: VISA_AVS_MATCH_ZIP
      })
      expect(fail.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
      expect(fail.valid?).to eq(false)
      expect(fail.errors).to eq({cvv2: I18n.t(:unknown_error)}) 
    end
  end

  it 'auth fail with bad zip' do
    APPROVAL_ACCOUNTS.each do |account|
      fail = CardConnectGateway.authorization({
        account: account,
        expiry: EXPIRY,
        postal: 'junk',
        cvv2: CVV_MATCH
      })
      fail.valid?
      expect(fail.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
      expect(fail.valid?).to eq(false)
      expect(fail.errors).to eq({PPS: "Invalid zip"}) 
    end
  end
  
  it 'auth and make profile' do
    APPROVAL_ACCOUNTS.each do |account|
      auth = CardConnectGateway.authorization({
        account: account,
        expiry: EXPIRY,
        profile: true,
        cvv2: CVV_MATCH,
        postal: VISA_AVS_MATCH_ZIP
      })
      expect(auth.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
      expect(auth.valid?).to eq(true)
      expect(auth.errors).to eq({}) 
      expect(auth.profileid.length).to eq(20) 
    end
  end

  it 'auth and capture from profile' do
    APPROVAL_ACCOUNTS.each do |account|
      auth = CardConnectGateway.authorization({
        account: account,
        expiry: EXPIRY,
        profile: true,
        cvv2: CVV_MATCH,
        postal: VISA_AVS_MATCH_ZIP
      })

      profileid = auth.profileid
      auth2 = CardConnectGateway.authorization({
        profile: profileid,
        amount: 36,
        check_cvv: false, # cvv and avs were already validated in the first auth. ignore them now
        check_avs: false,
        capture: true
      })
      auth2.validate
      expect(auth2.errors).to eq({}) 
      expect(auth2.valid?).to eq(true)
    end
  end


  it 'auth and capture from token' do
    APPROVAL_ACCOUNTS.each do |account|
      auth = CardConnectGateway.authorization({
        account: account,
        expiry: EXPIRY,
        profile: true,
        cvv2: CVV_MATCH,
        postal: VISA_AVS_MATCH_ZIP
      })

      token = auth.token
      auth2 = CardConnectGateway.authorization({
        account: token,
        expiry: EXPIRY,
        profile: true,
        cvv2: CVV_MATCH,
        card_type: CardConnectGateway::Base::VISA,
        postal: VISA_AVS_MATCH_ZIP,
        amount: 36,
        capture: true
      })
      auth2.validate
      expect(auth2.errors).to eq({}) 
      expect(auth2.valid?).to eq(true)
    end
  end

  it 'check card types' do 
    request = CardConnectGateway::Authorization::Request.new({
      account: VISA_APPROVAL_ACCOUNT
    })
    expect(request.card_type).to eq(CardConnectGateway::Base::VISA)

    request = CardConnectGateway::Authorization::Request.new({
      account: MASTERCARD_APPROVAL_ACCOUNT
    })
    expect(request.card_type).to eq(CardConnectGateway::Base::MASTERCARD)

    request = CardConnectGateway::Authorization::Request.new({
      account: AMEX_APPROVAL_ACCOUNT
    })
    expect(request.card_type).to eq(CardConnectGateway::Base::AMEX)

    request = CardConnectGateway::Authorization::Request.new({
      account: DISCOVER_APPROVAL_ACCOUNT
    })
    expect(request.card_type).to eq(CardConnectGateway::Base::DISCOVER)

    request = CardConnectGateway::Authorization::Request.new({
      account: DINERS_APPROVAL_ACCOUNT
    })
    expect(request.card_type).to eq(CardConnectGateway::Base::DINERS_CLUB)

    request = CardConnectGateway::Authorization::Request.new({
      account: JCB_APPROVAL_ACCOUNT
    })
    expect(request.card_type).to eq(CardConnectGateway::Base::JCB)


    request = CardConnectGateway::Authorization::Request.new({
      account: '1234567890123456', # not a real number
      expiry: EXPIRY
    })
    expect(request.valid?).to eq(false)
    expect(request.errors[:account]).to eq(I18n.t(:is_not_valid))
  end

  it 'check card type on response' do 
    response = CardConnectGateway.authorization({
      account: VISA_APPROVAL_ACCOUNT
    })
    expect(response.card_type).to eq(CardConnectGateway::Base::VISA)

    response = CardConnectGateway.authorization({
      account: MASTERCARD_APPROVAL_ACCOUNT
    })
    expect(response.card_type).to eq(CardConnectGateway::Base::MASTERCARD)

    response = CardConnectGateway.authorization({
      account: AMEX_APPROVAL_ACCOUNT
    })
    expect(response.card_type).to eq(CardConnectGateway::Base::AMEX)

    response = CardConnectGateway.authorization({
      account: DISCOVER_APPROVAL_ACCOUNT
    })
    expect(response.card_type).to eq(CardConnectGateway::Base::DISCOVER)

    response = CardConnectGateway.authorization({
      account: DINERS_APPROVAL_ACCOUNT
    })
    expect(response.card_type).to eq(CardConnectGateway::Base::DINERS_CLUB)

    response = CardConnectGateway.authorization({
      account: JCB_APPROVAL_ACCOUNT
    })
    expect(response.card_type).to eq(CardConnectGateway::Base::JCB)
  end

  it 'check card type on response with custom config' do 
    CardConnectGateway.configure do |config|
      config.test_mode = true
      config.merchant_id = ENV["CARD_CONNECT_MERCHANT_ID"]
      config.user_id = ENV['CARD_CONNECT_USER_ID']
      config.password = ENV['CARD_CONNECT_PASSWORD']
      config.debug = true
      config.supported_card_types = [
        CardConnectGateway::Base::VISA
      ]
    end

    request = CardConnectGateway::Authorization::Request.new({
      account: VISA_APPROVAL_ACCOUNT
    })
    expect(request.card_type).to eq(CardConnectGateway::Base::VISA)

    request = CardConnectGateway::Authorization::Request.new({
      account: MASTERCARD_APPROVAL_ACCOUNT
    })
    expect(request.card_type).to eq(CardConnectGateway::Base::MASTERCARD)
    expect(request.valid?).to eq(false)
    expect(request.errors[:card_type]).to eq(I18n.t(:is_not_supported))

    request = CardConnectGateway::Authorization::Request.new({
      account: AMEX_APPROVAL_ACCOUNT
    })
    expect(request.card_type).to eq(CardConnectGateway::Base::AMEX)
    expect(request.valid?).to eq(false)
    expect(request.errors[:card_type]).to eq(I18n.t(:is_not_supported))

    request = CardConnectGateway::Authorization::Request.new({
      account: DISCOVER_APPROVAL_ACCOUNT
    })
    expect(request.card_type).to eq(CardConnectGateway::Base::DISCOVER)
    expect(request.valid?).to eq(false)
    expect(request.errors[:card_type]).to eq(I18n.t(:is_not_supported))

    request = CardConnectGateway::Authorization::Request.new({
      account: DINERS_APPROVAL_ACCOUNT
    })
    expect(request.card_type).to eq(CardConnectGateway::Base::DINERS_CLUB)
    expect(request.valid?).to eq(false)
    expect(request.errors[:card_type]).to eq(I18n.t(:is_not_supported))

    request = CardConnectGateway::Authorization::Request.new({
      account: JCB_APPROVAL_ACCOUNT
    })
    expect(request.card_type).to eq(CardConnectGateway::Base::JCB)
    expect(request.valid?).to eq(false)
    expect(request.errors[:card_type]).to eq(I18n.t(:is_not_supported))

    request = CardConnectGateway::Authorization::Request.new({
      account: '1234567890123456', # not a real number
      expiry: EXPIRY
    })
    expect(request.card_type).to be_nil
    expect(request.valid?).to eq(false)
    expect(request.errors[:account]).to eq(I18n.t(:is_not_valid))
  end

  it 'avs responses with only zip code match required' do
    CardConnectGateway.configure do |config|
      config.require_avs_zip_code_match = true
      config.require_avs_address_match = false
      config.require_avs_customer_name_match = false
    end

    response = CardConnectGateway.authorization({
      account: VISA_APPROVAL_ACCOUNT,
      expiry: EXPIRY,
      profile: true,
      cvv2: CVV_MATCH,
      postal: VISA_AVS_MATCH_ZIP
    })
    response.valid?
    expect(response.errors).to eq({})

    response = CardConnectGateway.authorization({
      account: VISA_APPROVAL_ACCOUNT,
      expiry: EXPIRY,
      profile: true,
      cvv2: CVV_MATCH,
      postal: VISA_AVS_PARTIAL_MATCH_ZIP
    })
    response.valid?
    expect(response.errors).to eq({})

    response = CardConnectGateway.authorization({
      account: MASTERCARD_APPROVAL_ACCOUNT,
      expiry: EXPIRY,
      profile: true,
      cvv2: CVV_MATCH,
      postal: MASTERCARD_ZIP_MISMATCH
    })
    expect(response.valid?).to eq(false)

    response = CardConnectGateway.authorization({
      account: MASTERCARD_APPROVAL_ACCOUNT,
      expiry: EXPIRY,
      profile: true,
      cvv2: CVV_MATCH,
      postal: MASTERCARD_AVS_MISMATCH
    })
    expect(response.valid?).to eq(false)
  end

  it 'avs responses with only address match required' do
    CardConnectGateway.configure do |config|
      config.require_avs_zip_code_match = false
      config.require_avs_address_match = true
      config.require_avs_customer_name_match = false
    end

    response = CardConnectGateway.authorization({
      account: VISA_APPROVAL_ACCOUNT,
      expiry: EXPIRY,
      profile: true,
      cvv2: CVV_MATCH,
      postal: VISA_AVS_MATCH_ZIP
    })
    response.valid?
    expect(response.errors).to eq({})

    response = CardConnectGateway.authorization({
      account: VISA_APPROVAL_ACCOUNT,
      expiry: EXPIRY,
      profile: true,
      cvv2: CVV_MATCH,
      postal: VISA_AVS_PARTIAL_MATCH_ZIP
    })
    expect(response.valid?).to eq(false)

    response = CardConnectGateway.authorization({
      account: MASTERCARD_APPROVAL_ACCOUNT,
      expiry: EXPIRY,
      profile: true,
      cvv2: CVV_MATCH,
      postal: MASTERCARD_ZIP_MISMATCH
    })
    response.valid?
    expect(response.errors).to eq({})

    response = CardConnectGateway.authorization({
      account: MASTERCARD_APPROVAL_ACCOUNT,
      expiry: EXPIRY,
      profile: true,
      cvv2: CVV_MATCH,
      postal: MASTERCARD_AVS_MISMATCH
    })
    expect(response.valid?).to eq(false)

  end

  it 'avs responses with address and zip code match required' do
    CardConnectGateway.configure do |config|
      config.require_avs_zip_code_match = true
      config.require_avs_address_match = true
      config.require_avs_customer_name_match = false
    end

    response = CardConnectGateway.authorization({
      account: VISA_APPROVAL_ACCOUNT,
      expiry: EXPIRY,
      profile: true,
      cvv2: CVV_MATCH,
      postal: VISA_AVS_MATCH_ZIP
    })
    response.valid?
    expect(response.errors).to eq({})

    response = CardConnectGateway.authorization({
      account: VISA_APPROVAL_ACCOUNT,
      expiry: EXPIRY,
      profile: true,
      cvv2: CVV_MATCH,
      postal: VISA_AVS_PARTIAL_MATCH_ZIP
    })
    expect(response.valid?).to eq(false)

    response = CardConnectGateway.authorization({
      account: MASTERCARD_APPROVAL_ACCOUNT,
      expiry: EXPIRY,
      profile: true,
      cvv2: CVV_MATCH,
      postal: MASTERCARD_ZIP_MISMATCH
    })
    expect(response.valid?).to eq(false)

    response = CardConnectGateway.authorization({
      account: MASTERCARD_APPROVAL_ACCOUNT,
      expiry: EXPIRY,
      profile: true,
      cvv2: CVV_MATCH,
      postal: MASTERCARD_AVS_MISMATCH
    })
    expect(response.valid?).to eq(false)
  end

  it 'avs responses with no match required' do
    CardConnectGateway.configure do |config|
      config.require_avs_zip_code_match = false
      config.require_avs_address_match = false
      config.require_avs_customer_name_match = false
    end

    response = CardConnectGateway.authorization({
      account: VISA_APPROVAL_ACCOUNT,
      expiry: EXPIRY,
      profile: true,
      cvv2: CVV_MATCH,
      postal: VISA_AVS_MATCH_ZIP
    })
    response.valid?
    expect(response.errors).to eq({})

    response = CardConnectGateway.authorization({
      account: VISA_APPROVAL_ACCOUNT,
      expiry: EXPIRY,
      profile: true,
      cvv2: CVV_MATCH,
      postal: VISA_AVS_PARTIAL_MATCH_ZIP
    })
    response.valid?
    expect(response.errors).to eq({})

    response = CardConnectGateway.authorization({
      account: MASTERCARD_APPROVAL_ACCOUNT,
      expiry: EXPIRY,
      profile: true,
      cvv2: CVV_MATCH,
      postal: MASTERCARD_ZIP_MISMATCH
    })
    response.valid?
    expect(response.errors).to eq({})

    response = CardConnectGateway.authorization({
      account: MASTERCARD_APPROVAL_ACCOUNT,
      expiry: EXPIRY,
      profile: true,
      cvv2: CVV_MATCH,
      postal: MASTERCARD_AVS_MISMATCH
    })
    response.valid?
    expect(response.errors).to eq({})

  end
end