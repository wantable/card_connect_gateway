require 'rest_client'
module CardConnectGateway
  class BaseResponse < Base

    APPROVED = 'A'
    RETRY = 'B'
    DECLINED = 'C'
    CardConnectInternalResponse = 'PPS'
    FirstDataNorth = 'FNOR'

    def validate
      raise NotImplementedException
    end

    def valid?
      @validated ? @errors.empty? : validate
    end

    def errors
      @errors || {}
    end


  end
end