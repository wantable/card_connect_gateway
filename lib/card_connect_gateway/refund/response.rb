module CardConnectGateway
  module Refund
    class Response < BaseResponse

      attr_accessor :amount, :currency, :retref, :authcode
    end
  end
end