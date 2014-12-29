require 'rest_client'
require 'json'
module CardConnectGateway
  class BaseRequest < Base
    PPAL = 'PPAL'
    PAID = 'PAID', 
    GIFT= 'GIFT'
    PDEBIT = 'PDEBIT'

    def validate
      self.errors = {}
      self.class.attributes.each do |key, validations|
        value = get_value(key)
        if value.nil? or value.empty?
          req = validations[:required]
          if req == true or (req.class == Proc and req.call(self) == true)
            self.errors[key] = 'is required.'
          end
        else 
          if maxLength = validations[:maxLength]
            self.errors[key] = "cannot be longer than #{maxLength}." if value.length > maxLength
          end

          if options = validations[:options]
            self.errors[key] = "must be one of #{options.join(", ")}." if !options.include?(value)
          end

          if format = validations[:format]
            self.errors[key] = "doesn't match the format." if !(format =~ value)
          end
        end
      end

      @validated = true

      errors.empty?
    end

    def valid?
      @validated ? self.errors.empty? : validate
    end

    def initialize(options={})
      options[:merchid] ||= CardConnectGateway.configuration.merchant_id if respond_to?(:merchid)

      self.class.attributes.each do |key, validations|
        set_value(key, validations[:default])
      end

      mapped_options = {}
      options.each do |key, value|
        value = Y if value == true
        value = N if value == false
        mapped_options[key] = value
      end
      
      super(mapped_options)
    end

    def to_hash
      self.class.attributes.keys.inject({}) do |hash, key|
        value = get_value(key)
        hash[key] = value if value
        hash
      end
    end

    def send
      url = "https://#{CardConnectGateway.configuration.user_id}:#{CardConnectGateway.configuration.password}@"
      url += "#{CardConnectGateway.configuration.url.gsub("http://","").gsub("https://","")}/#{self.class.resource_name}"

      puts "sending PUT request to #{url}\r\nwith content\r\n#{to_hash.inspect}" if CardConnectGateway.configuration.debug
      
      begin
        response = RestClient.put(url, self.to_hash.to_json, content_type: :json, accept: :json)
        puts "response: #{response}" if CardConnectGateway.configuration.debug
        response
      rescue => e
        puts "error: #{e}"  if CardConnectGateway.configuration.debug
        e
      end
    end

  end
end