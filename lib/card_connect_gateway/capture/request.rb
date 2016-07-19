module CardConnectGateway
  module Capture
    class Request < AuthorizedRequest
      def self.resource_name
        'capture'
      end
    end
  end
end