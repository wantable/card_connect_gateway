require 'card_connect_gateway/capture/request'
require 'card_connect_gateway/capture/response'
module CardConnectGateway
  module Capture
    def self.new(options={})
      request = Request.new(options)
      rest_response = {} # todo - send request through restclient
      response = Response.new(rest_response)
    end
  end
end