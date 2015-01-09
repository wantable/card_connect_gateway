require 'rest_client'
require 'json'
module CardConnectGateway
  class BaseRequest < Base
    PPAL = 'PPAL'
    PAID = 'PAID', 
    GIFT= 'GIFT'
    PDEBIT = 'PDEBIT'

    def validate
      self.errors ||= {}
      self.class.attributes.each do |key, validations|
        validate_attribute(key, validations)
      end

      @validated = true

      errors.empty?
    end

    def valid?
      @validated ? self.errors.empty? : validate
    end

    def initialize(options={})
      options[:merchid] ||= CardConnectGateway.configuration.merchant_id if respond_to?(:merchid)

      # allow setting expiration in parts
      if respond_to?(:expiry) and !options[:expiry] and month = options.delete(:expiry_month) and year = options.delete(:expiry_year)
        options[:expiry] = "#{sprintf('%02d', month.to_i)}#{sprintf('%02d', year.to_i)}"
      end

      # normalize amount into format "20.01"
      if respond_to?(:amount) and options[:amount] and options[:amount].class != String
        options[:amount] = (options[:amount] * 100).to_i
      end

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

    def send
      url = build_url
      puts "sending PUT request to #{url}\r\nwith content\r\n#{to_hash.to_json}" if CardConnectGateway.configuration.debug
      
      begin
        response = RestClient.put(url, self.to_hash.to_json, content_type: :json, accept: :json)
        puts "response: #{response}" if CardConnectGateway.configuration.debug

        JSON.parse(response)
      rescue => e
        puts "error: #{e}"  if CardConnectGateway.configuration.debug
        e
      end
    end

    private 

    def validate_attribute(key, validations=[])
      value = get_value(key)
      if value.nil? or value.empty?
        req = validations[:required]
        if req == true or (req.class == Proc and req.call(self) == true)
          self.errors[key] = I18n.t(:is_required)
        end
      else 
        if maxLength = validations[:maxLength]
          self.errors[key] = I18n.t(:cannot_be_longer_than, maxLength: maxLength) if value.length > maxLength
        end

        if options = validations[:options]
          self.errors[key] = I18n.t(:must_be_one_of, options: options) if !options.include?(value)
        end

        if format = validations[:format]
          self.errors[key] = I18n.t(:doesnt_match_the_format) if !(format =~ value)
        end
      end
    end

    def build_url
      url = "https://#{CardConnectGateway.configuration.user_id}:#{CardConnectGateway.configuration.password}@"
      url += "#{CardConnectGateway.configuration.url.gsub("http://","").gsub("https://","")}/#{self.class.resource_name}"
      url
    end

    def to_hash
      self.class.attributes.keys.inject({}) do |hash, key|
        value = get_value(key)
        hash[key] = value if value
        hash
      end
    end

  end
end