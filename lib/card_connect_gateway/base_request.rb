require 'rest_client'
require 'json'
module CardConnectGateway
  class BaseRequest
    Y = 'Y'
    N = 'N'

    def initialize(options={})
      self.class.attributes.each do |key, validations|
        set_value(key, validations[:default])
      end

      options.each do |key, value|
        value = Y if value == true
        value = F if value == false
        set_value(key, value)
      end
    end

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

    def to_hash
      self.class.attributes.keys.inject({}) do |hash, key|
        value = get_value(key)
        hash[key] = value if value
        hash
      end
    end

    def send
      url = "https://#{CardConnectGateway.configuration.user_id}:#{CardConnectGateway.configuration.password}@"
      url += "#{CardConnectGateway.configuration.url.gsub("http://","").gsub("https://","")}/#{self.class.name.downcase.split("::")[1]}"

      puts "sending PUT request to #{url}\r\nwith content\r\n#{to_hash.inspect}" if CardConnectGateway.configuration.debug
      
      req = RestClient.put(url, self.to_hash.to_json, :headers => { :accept => :json, :content_type => :json })
      
      begin
        response = req.execute
        puts "success: #{response}" if CardConnectGateway.configuration.debug
        response
      rescue => e
        puts "error: #{e}"  if CardConnectGateway.configuration.debug
        e
      end
    end

    protected

    def set_value(key, value)
      # could also use self.send("#{key}=", value) but thats slightly less safe
      self.instance_variable_set("@#{key}", value)
    end

    def get_value(key)
      value = instance_variable_get("@#{key}")
      value = value ? value.to_s : value # everything is a string...
    end
  end
end