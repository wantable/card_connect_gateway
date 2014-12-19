require 'card_connect_gateway/authorization/request'
require 'card_connect_gateway/authorization/response'
module CardConnectGateway
  module Authorization
    def self.new(options={})
      request = Request.new(options)
      rest_response = {} # todo - send request through restclient
      response = Response.new(rest_response)
    end
  end
end