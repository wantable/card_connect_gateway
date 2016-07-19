require 'card_connect_gateway/capture/request'
require 'card_connect_gateway/capture/response'
module CardConnectGateway
  module Capture
    include Helpers

    def self.new(options={})
      request = Request.new(options)
      request.valid? ? Response.new(parse_response(request.send)) : request
    end
  end
end