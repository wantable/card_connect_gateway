module CardConnectGateway
  module Refund
    class Request < BaseAuthorizedRequest
      def self.resource_name
        'refund'
      end
    end
  end
end