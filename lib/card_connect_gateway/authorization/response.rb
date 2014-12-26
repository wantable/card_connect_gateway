module CardConnectGateway
  module Authorization
    class Response < BaseResponse

      attr_accessor :respstat, :retref, :account, :token, :amount, :merchid, :respcode, :resptext, :respproc, :avsresp, :cvvresp, :authcode, :commcard

      def validate
        @errors = {}

        if respstat != APPROVED
          if resptext and !resptext.empty? and respproc and !respproc.empty?

            errors[respproc.to_sym] = resptext 
          else
            errors["Card Connect Gateway"] = "Unkown error."
          end
        end

        puts "Validating auth #{errors.inspect} - #{respstat} #{resptext}"

        @validated = true
        @errors.empty?

      end
    end
  end
end