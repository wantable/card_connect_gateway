# Refund, Capture, Void all have the exact same request so I've pulled those attributes out into this base class
module CardConnectGateway
  class AuthorizedRequest < BaseRequest
    attr_accessor :retref, :amount
    def self.attributes 
      {
        merchid: { 
          required: true, 
          maxLength: 12
        }, 
        amount: {
          maxLength: 12
        },
        retref: {
          required: true,
          maxLength: 15
        }
      }
    end
  end
end