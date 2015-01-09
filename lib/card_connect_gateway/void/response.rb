module CardConnectGateway
  module Void
    class Response < BaseResponse

      attr_accessor :merchid, :amount, :currency, :retref, :authcode, :respcode, :respproc, :respstat, :resptext

    end
  end
end