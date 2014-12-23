require 'spec_helper'

describe "Authorization" do
  it 'request validates' do 
    request = CardConnectGateway::Authorization::Request.new({
      account: TEST_SUCCESS_CARD,
      expiry: '0921'
    })
    expect(request.account).to eq(TEST_SUCCESS_CARD)
    expect(request.expiry).to eq('0921')
    expect(request.merchid).to eq(CardConnectGateway.configuration.merchant_id) 
    expect(request.validate).to eq(true)
    expect(request.errors).to eq({})
  end

  it 'request validates with month/year' do
    request = CardConnectGateway::Authorization::Request.new({
      account: TEST_SUCCESS_CARD,
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
      account: TEST_SUCCESS_CARD,
      expiry: '0921'
    })
    expect(response.class.name).to eq(CardConnectGateway::Authorization::Response.name) 
    expect(response.errors).to eq({}) 
    expect(response.valid?).to eq(true)
  end

end