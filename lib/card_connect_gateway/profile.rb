require 'card_connect_gateway/profile/request'
require 'card_connect_gateway/profile/response'
module CardConnectGateway
  module Profile
    include Helpers

    def self.new(options={})
      request = Request.new(options)
      request.valid? ? Response.new(parse_response(request.send)) : request
    end
  end
end