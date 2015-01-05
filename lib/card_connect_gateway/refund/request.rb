module CardConnectGateway
  module Refund
    class Request < BaseRequest
      

      attr_accessor :merchid, :retref, :amount

      def self.resource_name
        'refund'
      end

      def self.attributes 
        {
          merchid: { 
            required: true, 
            maxLength: 12
          }, 
          retref: {
            required: true,
            maxLength: 12
          },
          amount: {
            maxLength: 12
          }
        }
      end

    end
  end
end