require 'card_connect_gateway/void/request'
require 'card_connect_gateway/void/response'
module CardConnectGateway
  module Void
    include Helpers
    
    def self.new(options={})
      request = Request.new(options)
      request.valid? ? Response.new(parse_response(request.send)) : request
    end
  end
end