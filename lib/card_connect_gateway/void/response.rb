module CardConnectGateway
  module Void
    class Response < BaseResponse

      attr_accessor :merchid, :amount, :currency, :retref, :authcode, :respcode, :respproc, :respstat, :resptext

      def validate
        self.errors = {}

        if respstat != APPROVED
          if resptext and !resptext.empty? and respproc and !respproc.empty?
            errors[respproc.to_sym] = resptext 
          else
            errors["Card Connect Gateway"] = I18n.t(:unknown_error)
          end
        end

        @validated = true

        errors.empty?
      end

    end
  end
end