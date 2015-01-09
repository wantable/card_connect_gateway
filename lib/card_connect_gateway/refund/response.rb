module CardConnectGateway
  module Refund
    class Response < BaseResponse

      attr_accessor :merch_id, :amount, :currency, :retref, :authcode, :respcode, :respproc, :respstat, :resptext
    end
  end
end