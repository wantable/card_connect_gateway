require 'card_connect_gateway/authorization/request'
require 'card_connect_gateway/authorization/response'
module CardConnectGateway
  module Authorization
    include Helpers

    def self.new(options={})
      request = Request.new(options)
      request.valid? ? Response.new(parse_response(request.send)) : request
    end
  end
end