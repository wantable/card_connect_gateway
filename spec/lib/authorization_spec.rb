require 'spec_helper'

describe "Authorization" do
  response = CardConnectGateway.authorization()
  it { expect(response.class.name).to eq(CardConnectGateway::Authorization::Response.name) }

  it 'request validates' do 
    request = CardConnectGateway::Authorization::Request.new({
      account: '411111111111111',
      expiry: '0921'
    })
    expect(request.account).to eq('411111111111111')
    expect(request.expiry).to eq('0921')
    expect(request.merchid).to eq(CardConnectGateway.configuration.merchant_id) 
    expect(request.validate).to eq(true)
    expect(request.errors).to eq({})
  end

  it 'request validates with month/year' do
    request = CardConnectGateway::Authorization::Request.new({
      account: '411111111111111',
      expiry_month: 9,
      expiry_year: 10
    })
    expect(request.expiry).to eq('0910') 
    expect(request.validate).to eq(true)
    expect(request.errors).to eq({})
  end

  it 'fail validation' do
    request = CardConnectGateway::Authorization::Request.new({tokenize: 'A', expiry: 'asdf'})
    expect(request.validate).to eq(false)
    expect(request.errors[:account]).to eq('is required.')
    expect(request.errors[:tokenize]).to eq('must be one of Y, N.')
    expect(request.errors[:expiry]).to eq("doesn't match the format.")
    
  end
end