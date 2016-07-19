module CardConnectGateway
  module Capture
    class Request < BaseAuthorizedRequest
      def self.resource_name
        'capture'
      end
    end
  end
end