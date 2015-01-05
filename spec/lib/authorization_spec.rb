require 'spec_helper'

describe "Authorization" do
  it 'request validates' do 
    request = CardConnectGateway::Authorization::Request.new({
      account: VISA_APPROVAL_ACCOUNT,
      expiry: '0921'
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
      expiry_year: 10
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
      expiry: '0921'
    })
    expect(response.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
    expect(response.valid?).to eq(true)
    expect(response.errors).to eq({}) 
  end

  it 'auth fail with refer call' do
    fail = CardConnectGateway.authorization({
      account: VISA_REFER_CALL_ACCOUNT,
      expiry: '0921'
    })
    expect(fail.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
    expect(fail.valid?).to eq(false)
    expect(fail.errors).to eq({FNOR: "Refer to issuer"}) 
  end

  it 'auth fail with do not honor' do
    fail = CardConnectGateway.authorization({
      account: VISA_DO_NOT_HONOR_ACCOUNT,
      expiry: '0921'
    })
    expect(fail.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
    expect(fail.valid?).to eq(false)
    expect(fail.errors).to eq({FNOR: "Do not honor"}) 
  end

  it 'auth fail with expired account' do
    fail = CardConnectGateway.authorization({
      account: VISA_CARD_EXPIRED_ACCOUNT,
      expiry: '0921'
    })
    expect(fail.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
    expect(fail.valid?).to eq(false)
    expect(fail.errors).to eq({FNOR: "Wrong expiration"}) 
  end

  it 'auth fail with insufficient funds' do
    fail = CardConnectGateway.authorization({
      account: VISA_INSUFFICIENT_FUNDS_ACCOUNT,
      expiry: '0921'
    })
    expect(fail.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
    expect(fail.valid?).to eq(false)
    expect(fail.errors).to eq({FNOR: "Declined"}) 
  end

  it 'auth and make profile' do
    fail = CardConnectGateway.authorization({
      account: VISA_APPROVAL_ACCOUNT,
      expiry: '0921',
      profile: true
    })
    expect(fail.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
    expect(fail.valid?).to eq(true)
    expect(fail.errors).to eq({}) 
    expect(fail.profileid.length).to eq(20) 
  end
end