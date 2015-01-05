require 'spec_helper'

describe "Refund" do
  
  it 'request validates' do 
    request = CardConnectGateway::Refund::Request.new()
    expect(request.valid?).to eq(false)
    expect(request.errors).to eq({:retref=>"is required."})
  end

  it 'void successfully' do
    auth = CardConnectGateway.authorization({
      account: VISA_APPROVAL_ACCOUNT,
      expiry: '0921',
      cvv2: CVV_MATCH,
      postal: VISA_AVS_MATCH_ZIP,
      capture: true,
      amount: 2000 # $20
    })

    refund = CardConnectGateway.refund({
      retref: auth.retref
    })

    refund.valid?
    expect(refund.errors).to eq({}) 
    expect(refund.amount).to eq(auth.amount)
  end
end