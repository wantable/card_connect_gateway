module CardConnectGateway
  module Capture
    class Response < BaseResponse
      # https://developer.cardconnect.com/cardconnect-api#capture-response
      attr_accessor :account, :amount, :retref, :setlstat, :batchid, :token, :commcard
    end
  end
end