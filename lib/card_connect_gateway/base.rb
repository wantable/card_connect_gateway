module CardConnectGateway
  class Base

    Y = 'Y'
    N = 'N'
    USD = 'USD'
    US = 'US'
    
    VISA = "Visa"
    MASTERCARD = "MasterCard"
    MAESTRO = "Maestro"
    DINERS_CLUB = "Diners Club"
    AMEX = "AMEX"
    DISCOVER = "Discover"
    JCB = "JCB"

    attr_accessor :errors

    def initialize(options={})
      self.errors = {}

      if options[:expiry] and respond_to?(:expiry_month=) and respond_to?(:expiry_year=)
        options[:expiry_month] = options[:expiry][0..1]
        options[:expiry_year] = options[:expiry][2..4]
      end

      options.each do |key, value|
        set_value(key, value)
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