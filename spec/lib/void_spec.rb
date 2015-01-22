require 'spec_helper'

describe "Void" do
  
  it 'request validates' do 
    request = CardConnectGateway::Void::Request.new()
    expect(request.valid?).to eq(false)
    expect(request.errors).to eq(retref: "is required.")
  end

  it 'void successfully' do
    auth = CardConnectGateway.authorization({
      account: VISA_APPROVAL_ACCOUNT,
      expiry: '0921',
      cvv2: CVV_MATCH,
      postal: VISA_AVS_MATCH_ZIP,
      capture: true,
      amount: 20
    })

    void = CardConnectGateway.void({
      retref: auth.retref
    })

    void.valid?
    expect(void.errors).to eq({}) 
  end

  it 'partial void successfully' do
    auth = CardConnectGateway.authorization({
      account: VISA_APPROVAL_ACCOUNT,
      expiry: '0921',
      cvv2: CVV_MATCH,
      postal: VISA_AVS_MATCH_ZIP,
      amount: 20
    })

    void = CardConnectGateway.void({
      retref: auth.retref,
      amount: 5
    })

    void.valid?
    expect(void.errors).to eq({}) 
    expect(void.amount).to eq('15.00')
  end
end