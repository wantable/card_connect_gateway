require 'json'

require 'card_connect_gateway/authorization/request'
require 'card_connect_gateway/authorization/response'
module CardConnectGateway
  module Authorization

    def self.new(options={})
      request = Request.new(options)
      !request.valid? ? request : Response.new(JSON.parse(request.send))
    end
  end
end