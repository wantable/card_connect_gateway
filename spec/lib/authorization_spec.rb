require 'spec_helper'

describe "Authorization" do
  it 'request validates' do 
    request = CardConnectGateway::Authorization::Request.new({
      account: VISA_APPROVAL_ACCOUNT,
      expiry: '0921',
      cvv2: CVV_MATCH
    })
    expect(request.account).to eq(VISA_APPROVAL_ACCOUNT)
    expect(request.expiry).to eq('0921')
    expect(request.merchid).to eq(CardConnectGateway.configuration.merchant_id) 
    expect(request.validate).to eq(true)
    expect(request.errors).to eq({})
  end

  it 'request validates with month/year' do
    request = CardConnectGateway::Authorization::Request.new({
      account: VISA_APPROVAL_ACCOUNT,
      expiry_month: 9,
      expiry_year: 10,
      cvv2: CVV_MATCH,
    })
    expect(request.expiry).to eq('0910') 
    expect(request.errors).to eq({})
    expect(request.validate).to eq(true)
  end

  it 'fail validation' do
    request = CardConnectGateway::Authorization::Request.new({tokenize: 'A', expiry: 'asdf'})
    expect(request.validate).to eq(false)
    expect(request.errors[:account]).to eq('is required.')
    expect(request.errors[:tokenize]).to eq('must be one of Y, N.')
    expect(request.errors[:expiry]).to eq("doesn't match the format.")
  end


  it 'fail validation from auth' do
    request = CardConnectGateway.authorization({tokenize: 'A', expiry: 'asdf'})

    expect(request.errors[:account]).to eq('is required.')
    expect(request.errors[:tokenize]).to eq('must be one of Y, N.')
    expect(request.errors[:expiry]).to eq("doesn't match the format.")
    
    expect(request.class.name).to eq(CardConnectGateway::Authorization::Request.name) 
  end

  it 'auth successfully' do
    response = CardConnectGateway.authorization({
      account: VISA_APPROVAL_ACCOUNT,
      expiry: '0921',
      cvv2: CVV_MATCH
    })
    expect(response.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
    expect(response.valid?).to eq(true)
    expect(response.errors).to eq({}) 
  end

  it 'auth fail with refer call' do
    fail = CardConnectGateway.authorization({
      account: VISA_REFER_CALL_ACCOUNT,
      expiry: '0921',
      cvv2: CVV_MATCH
    })
    expect(fail.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
    expect(fail.valid?).to eq(false)
    expect(fail.errors).to eq({FNOR: "Refer to issuer"}) 
  end

  it 'auth fail with do not honor' do
    fail = CardConnectGateway.authorization({
      account: VISA_DO_NOT_HONOR_ACCOUNT,
      expiry: '0921',
      cvv2: CVV_MATCH
    })
    expect(fail.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
    expect(fail.valid?).to eq(false)
    expect(fail.errors).to eq({FNOR: "Do not honor"}) 
  end

  it 'auth fail with expired account' do
    fail = CardConnectGateway.authorization({
      account: VISA_CARD_EXPIRED_ACCOUNT,
      expiry: '0921',
      cvv2: CVV_MATCH
    })
    expect(fail.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
    expect(fail.valid?).to eq(false)
    expect(fail.errors).to eq({FNOR: "Wrong expiration"}) 
  end

  it 'auth fail with insufficient funds' do
    fail = CardConnectGateway.authorization({
      account: VISA_INSUFFICIENT_FUNDS_ACCOUNT,
      expiry: '0921',
      cvv2: CVV_MATCH
    })
    expect(fail.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
    expect(fail.valid?).to eq(false)
    expect(fail.errors).to eq({FNOR: "Declined"}) 
  end

  it 'auth fail with cvv mismatch' do
    fail = CardConnectGateway.authorization({
      account: VISA_APPROVAL_ACCOUNT,
      cvv2: CVV_MISMATCH,
      expiry: '0921'
    })
    expect(fail.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
    expect(fail.valid?).to eq(false)
    expect(fail.errors).to eq({cvv2: "Doesn't match."}) 
  end

  it 'auth fail with cvv not processed' do
    fail = CardConnectGateway.authorization({
      account: VISA_APPROVAL_ACCOUNT,
      cvv2: CVV_NOT_PROCESSED,
      expiry: '0921'
    })
    expect(fail.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
    expect(fail.valid?).to eq(false)
    expect(fail.errors).to eq({cvv2: "Unknown error."}) 
  end

  it 'auth fail with bad zip' do
    fail = CardConnectGateway.authorization({
      account: VISA_APPROVAL_ACCOUNT,
      expiry: '0921',
      postal: 'junk',
      cvv2: CVV_MATCH
    })
    puts "auth with bad zip"
    fail.valid?
    puts fail.errors
    expect(fail.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
    expect(fail.valid?).to eq(false)
    expect(fail.errors).to eq({PPS: "Invalid zip"}) 
  end
  
  it 'auth and make profile' do
    auth = CardConnectGateway.authorization({
      account: VISA_APPROVAL_ACCOUNT,
      expiry: '0921',
      profile: true,
      cvv2: CVV_MATCH
    })
    expect(auth.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
    expect(auth.valid?).to eq(true)
    expect(auth.errors).to eq({}) 
    expect(auth.profileid.length).to eq(20) 
  end

  it 'auth and capture from profile' do
    auth = CardConnectGateway.authorization({
      account: VISA_APPROVAL_ACCOUNT,
      expiry: '0921',
      profile: true,
      cvv2: CVV_MATCH
    })

    profileid = auth.profileid
    auth2 = CardConnectGateway.authorization({
      profile: profileid,
      amount: 36,
      check_cvv: false
    })
    expect(auth2.valid?).to eq(true)
    expect(auth2.errors).to eq({}) 
  end

end