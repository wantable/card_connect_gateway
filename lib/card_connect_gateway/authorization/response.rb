module CardConnectGateway
  module Authorization
    class Response < BaseResponse

      CVV_MATCH = 'M'
      CVV_NO_MATCH = 'N'
      CVV_NOT_PROCESSED = 'P'
      CVV_MISSING = 'S'
      CVV_UNKNOWN_OR_NO_PARTICIPATE = 'U'
      CVV_NO_RESPONSE = 'X'

      attr_accessor :respstat, :retref, :account, :token, :amount, :merchid, :respcode, :resptext, :respproc, :avsresp, 
                    :cvvresp, :authcode, :commcard, :profileid, :check_cvv

      def validate
        self.errors = {}

        if respstat != APPROVED
          if resptext and !resptext.empty? and respproc and !respproc.empty?
            errors[respproc.to_sym] = resptext 
          else
            errors["Card Connect Gateway"] = "Unknown error."
          end
        end

        if check_cvv
          if cvvresp == CVV_NO_MATCH or cvvresp == CVV_MISSING
            errors[:cvv2] = "Doesn't match."
          elsif cvvresp == CVV_NOT_PROCESSED or cvvresp == CVV_NO_RESPONSE
            errors[:cvv2] = "Unknown error."
          end
        end

        @validated = true
        errors.empty?
      end
    end
  end
end