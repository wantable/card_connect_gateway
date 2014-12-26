require 'card_connect_gateway/authorization/request'
require 'card_connect_gateway/authorization/response'
module CardConnectGateway
  module Authorization
    include Helpers

    def self.new(options={})
      request = Request.new(options)
      !request.valid? ? request : Response.new(parse_response(request.send))
    end
  end
end