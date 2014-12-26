require 'rest_client'
require 'json'
module CardConnectGateway
  class BaseRequest < Base
    PPAL = 'PPAL'
    PAID = 'PAID', 
    GIFT= 'GIFT'
    PDEBIT = 'PDEBIT'

    def validate
      @errors = {}
      self.class.attributes.each do |key, validations|
        value = get_value(key)
        if validations[:required] == true and (value.nil? or value.empty?)
          @errors[key] = 'is required.'
        end

        if value 
          if maxLength = validations[:maxLength]
            @errors[key] = "cannot be longer than #{maxLength}." if value.length > maxLength
          end

          if options = validations[:options]
            @errors[key] = "must be one of #{options.join(", ")}." if !options.include?(value)
          end

          if format = validations[:format]
            @errors[key] = "doesn't match the format." if !(format =~ value)
          end
        end
      end

      @validated = true

      @errors.empty?
    end

    def valid?
      @validated ? @errors.empty? : validate
    end

    def errors
      @errors || {}
    end

    def initialize(options={})
      options[:merchid] ||= CardConnectGateway.configuration.merchant_id if respond_to?(:merchid)
      super(options)
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
        response = RestClient.put(url, self.to_hash.to_json, :content_type => :json, :accept => :json)
        puts "response: #{response}" if CardConnectGateway.configuration.debug
        response
      rescue => e
        puts "error: #{e}"  if CardConnectGateway.configuration.debug
        e
      end
    end

  end
end