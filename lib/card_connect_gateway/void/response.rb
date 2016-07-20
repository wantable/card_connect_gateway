module CardConnectGateway
  module Void
    class Response < BaseResponse
      attr_accessor :amount, :currency, :retref, :authcode
    end
  end
end