require 'spec_helper'

describe "Capture" do
  
  it 'request validates' do 
    request = CardConnectGateway::Capture::Request.new()
    expect(request.valid?).to eq(false)
    expect(request.errors).to eq(retref: "is required.")
  end

  it 'capture successfully' do
    auth = CardConnectGateway.authorization({
      account: VISA_APPROVAL_ACCOUNT,
      expiry: '0921',
      cvv2: CVV_MATCH,
      postal: VISA_AVS_MATCH_ZIP,
      capture: true,
      amount: 20
    })

    capture = CardConnectGateway.capture({
      retref: auth.retref
    })

    capture.valid?
    expect(capture.errors).to eq({}) 
  end

  it 'capture without an auth doesn\'t work' do

    capture = CardConnectGateway.capture({
      retref: 'random'
    })

    capture.valid?
    expect(capture.errors).to eq({PPS: "Txn not found"})
  end


  it 'partial capture successfully' do
    auth = CardConnectGateway.authorization({
      account: VISA_APPROVAL_ACCOUNT,
      expiry: '0921',
      cvv2: CVV_MATCH,
      postal: VISA_AVS_MATCH_ZIP,
      amount: 20
    })

    capture = CardConnectGateway.capture({
      retref: auth.retref,
      amount: 5
    })

    capture.valid?
    expect(capture.errors).to eq({}) 
    expect(capture.amount).to eq('5.00')
  end
end