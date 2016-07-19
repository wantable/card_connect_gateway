require 'card_connect_gateway/authorization/request'
require 'card_connect_gateway/authorization/response'
module CardConnectGateway
  module Authorization
    include Service
    
    def self.new(options={})
      check_cvv = options.delete(:check_cvv)
      check_avs = options.delete(:check_avs)
      check_cvv = true if check_cvv.nil?
      check_avs = true if check_avs.nil?

      request = Request.new(options)
      request.valid? ? Response.new({check_cvv: check_cvv, check_avs: check_avs, card_type: request.card_type}.merge(parse_response(request.send))) : request
    end
  end
end