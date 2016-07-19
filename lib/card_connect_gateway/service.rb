require 'json'

module CardConnectGateway
  module Service

    def self.included(base)
      base.class_eval do
        
        def self.new(options={})
          # const_get to get the actual Request/Response objects from the correct classes
          # Just calling Request would try to give us CardConnectGateway::Service::Request which isn't a thing
          request = self.const_get(:Request).new(options)
          request.valid? ? self.const_get(:Response).new(parse_response(request.send)) : request
        end

        def self.parse_response(hash)

          hash.keys.each do |key|
            hash[(key.to_sym rescue key) || key] = hash.delete(key)
          end
          hash
        end

      end
    end
  end
end