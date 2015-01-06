module CardConnectGateway
  module Void
    class Request < BaseRequest
      
      attr_accessor :merchid, :amount, :retref

      def self.resource_name
        'void'
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