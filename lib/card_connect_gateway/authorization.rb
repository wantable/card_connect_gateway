require 'card_connect_gateway/authorization/request'
require 'card_connect_gateway/authorization/response'
module CardConnectGateway
  module Authorization
    include Helpers

    def self.new(options={})
      check_cvv = options.delete(:check_cvv)
      check_cvv = true if check_cvv.nil?
      request = Request.new(options)
      request.valid? ? Response.new({check_cvv: check_cvv, card_type: request.card_type}.merge(parse_response(request.send))) : request
    end
  end
end