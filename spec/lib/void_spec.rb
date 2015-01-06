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
end