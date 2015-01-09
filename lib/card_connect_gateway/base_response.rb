require 'rest_client'
module CardConnectGateway
  class BaseResponse < Base

    APPROVED = 'A'
    RETRY = 'B'
    DECLINED = 'C'
    CardConnectInternalResponse = 'PPS'
    FirstDataNorth = 'FNOR'

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


    def valid?
      @validated ? self.errors.empty? : validate
    end

  end
end