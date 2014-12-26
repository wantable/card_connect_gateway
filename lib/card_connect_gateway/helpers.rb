require 'json'

module CardConnectGateway
  module Helpers
    def self.included(base)
      base.class_eval do
        def self.parse_response(response)
          hash = JSON.parse(response)

          hash.keys.each do |key|
            hash[(key.to_sym rescue key) || key] = hash.delete(key)
          end
          hash
        end

      end
    end
  end
end
