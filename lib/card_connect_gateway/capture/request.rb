module CardConnectGateway
  module Capture
    class Request < BaseRequest
      
      attr_accessor :merchid, :amount, :retref

      def self.resource_name
        'capture'
      end

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
end