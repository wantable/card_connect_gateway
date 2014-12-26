module CardConnectGateway
  module Authorization
    class Response < BaseResponse

      attr_accessor :respstat, :retref, :account, :token, :amount, :merchid, :respcode, :resptext, :respproc, :avsresp, 
                    :cvvresp, :authcode, :commcard, :profileid

      def validate
        self.errors = {}

        if respstat != APPROVED
          if resptext and !resptext.empty? and respproc and !respproc.empty?

            errors[respproc.to_sym] = resptext 
          else
            errors["Card Connect Gateway"] = "Unkown error."
          end
        end

        @validated = true
        errors.empty?
      end
    end
  end
end