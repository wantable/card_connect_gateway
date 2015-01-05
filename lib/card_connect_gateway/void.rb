require 'card_connect_gateway/void/request'
require 'card_connect_gateway/void/response'
module CardConnectGateway
  module Void
    def self.new(options={})
      request = Request.new(options)
      rest_response = {} # todo - send request through restclient
      response = Response.new(rest_response)
    end
  end
end