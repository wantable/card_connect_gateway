module CardConnectGateway
  class Base
    Y = 'Y'
    N = 'N'
    USD = 'USD'
    US = 'US'

    def initialize(options={})
      self.class.attributes.each do |key, validations|
        set_value(key, validations[:default])
      end if self.class.respond_to?(:attributes)

      options.each do |key, value|
        value = Y if value == true
        value = F if value == false
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