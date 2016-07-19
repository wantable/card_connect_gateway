module CardConnectGateway
  module Refund
    class Request < AuthorizedRequest
      def self.resource_name
        'refund'
      end
    end
  end
end