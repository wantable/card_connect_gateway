module CardConnectGateway
  module Authorization
    class Response < BaseResponse

      APPROVED = 'A'
      RETRY = 'B'
      DECLINED = 'C'
      CardConnectInternalResponse = 'PPS'
      FirstDataNorth = 'FNOR'

      attr_accessor :respstat, :retref, :account, :token, :amount, :merchid, :respcode, :resptext, :respproc, :avsresp, :cvvresp, :authcode, :commcard

      def valid?
        respstat == APPROVED
      end

      def errors
        errors = {} 
        # use the same format here as in the request so we can pretend they're the same
        errors[respproc.to_sym] = resptext if !valid?

        errors
      end

    end
  end
end