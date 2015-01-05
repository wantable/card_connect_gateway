require 'card_connect_gateway/refund/request'
require 'card_connect_gateway/refund/response'
module CardConnectGateway
  module Refund
    include Helpers

    def self.new(options={})
      request = Request.new(options)
      request.valid? ? Response.new(parse_response(request.send)) : request
    end
  end
end