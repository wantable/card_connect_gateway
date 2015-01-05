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
      @validated ? self.errors.empty? : validate
    end

  end
end