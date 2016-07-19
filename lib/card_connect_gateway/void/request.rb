module CardConnectGateway
  module Void
    class Request < AuthorizedRequest
      def self.resource_name
        'void'
      end
    end
  end
end