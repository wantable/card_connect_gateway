module CardConnectGateway
  module Void
    class Request < BaseAuthorizedRequest
      def self.resource_name
        'void'
      end
    end
  end
end