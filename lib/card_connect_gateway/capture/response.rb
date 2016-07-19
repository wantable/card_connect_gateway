module CardConnectGateway
  module Capture
    class Response < BaseResponse
      attr_accessor :merchid, :amount, :setlstat, :retref, :account, :respproc, :resptext, :respstat, :respcode, :batchid
    end
  end
end