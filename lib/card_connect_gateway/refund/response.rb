module CardConnectGateway
  module Refund
    class Response < BaseResponse

      attr_accessor :merch_id, :amount, :currency, :retref, :authcode, :respcode, :respproc, :respstat, :resptext

      def validate
        self.errors = {}
 
        if respstat != APPROVED
          if resptext and !resptext.empty? and respproc and !respproc.empty?
            self.errors[respproc.to_sym] = resptext 
          else
            self.errors["Card Connect Gateway"] = "Unknown error."
          end
        end

        @validated = true
        errors.empty?
      end
      
    end
  end
end