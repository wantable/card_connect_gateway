require 'spec_helper'

describe "Profile" do
  it 'request validates' do 
    request = CardConnectGateway::Profile::Request.new({
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
    request = CardConnectGateway::Profile::Request.new({
      account: VISA_APPROVAL_ACCOUNT,
      expiry_month: 9,
      expiry_year: 10
    })
    expect(request.expiry).to eq('0910') 
    expect(request.validate).to eq(true)
    expect(request.errors).to eq({})
  end

  it 'fail validation' do
    request = CardConnectGateway::Profile::Request.new({tokenize: 'A', expiry: 'asdf'})
    expect(request.validate).to eq(false)
    expect(request.errors[:account]).to eq('is required.')
    expect(request.errors[:expiry]).to eq("doesn't match the format.")
  end


  it 'fail validation from create' do
    request = CardConnectGateway.create_profile({tokenize: 'A', expiry: 'asdf'})
    expect(request.validate).to eq(false)
    expect(request.errors[:account]).to eq('is required.')
    expect(request.errors[:expiry]).to eq("doesn't match the format.")
    
    expect(request.class.name).to eq(CardConnectGateway::Profile::Request.name) 
  end

  it 'create successfully' do
    response = CardConnectGateway.create_profile({
      account: VISA_APPROVAL_ACCOUNT,
      expiry: '0921'
    })
    expect(response.class.name).to eq(CardConnectGateway::Profile::Response.name) 
    expect(response.valid?).to eq(true)
    expect(response.errors).to eq({}) 
    expect(response.expiry_month).to eq('09')
    expect(response.expiry_year).to eq('21')
    expect(response.profileid).to_not be_nil
  end

  it 'update successfully' do
    response = CardConnectGateway.create_profile({
      account: VISA_APPROVAL_ACCOUNT,
      expiry: '0921'
    })
    expect(response.valid?).to eq(true)
    expect(response.profileid).to_not be_nil

    response2 = CardConnectGateway.update_profile({
      account: MASTERCARD_APPROVAL_ACCOUNT,
      expiry_month: 9,
      expiry_year: 10,
      profile: response.profileid
    })

    expect(response2.valid?).to eq(true)
    expect(response2.profileid).to eq(response.profileid)

  end

  it 'cant update without profile' do
    response = CardConnectGateway.update_profile({
      account: VISA_APPROVAL_ACCOUNT,
      expiry: '0921'
    })
    expect(response.valid?).to eq(false)
    expect(response.errors[:profile]).to eq('is required.')

  end

end