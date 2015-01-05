module CardConnectGateway
  module Authorization
    class Request < BaseRequest
      TELEPHONE = 'T' 
      RECURRING = 'R'
      ECOMMERCE = 'E'

      attr_accessor :merchid, :accttype, :account, :expiry, :amount, :currency, :name, :address, :city, :region, :country, :phone, 
                    :postal, :email, :ecomind, :cvv2, :orderid, :track, :bankaba, :tokenize, :termid, :capture, :profile

      CARD_TYPES = {
        VISA => /^4[0-9]{12}(?:[0-9]{3})?$/,
        MASTERCARD => /^5[1-5][0-9]{14}$/,
        MAESTRO => /(^6759[0-9]{2}([0-9]{10})$)|(^6759[0-9]{2}([0-9]{12})$)|(^6759[0-9]{2}([0-9]{13})$)/,
        DINERS_CLUB => /^3(?:0[0-5]|[68][0-9])[0-9]{11}$/,
        AMEX => /^3[47][0-9]{13}$/,
        DISCOVER => /^6(?:011|5[0-9]{2})[0-9]{12}$/,
        JCB => /^(?:2131|1800|35\d{3})\d{11}$/
      }
      # borrowed from https://github.com/tobias/credit_card_validator/blob/master/lib/credit_card_validator/validator.rb

      def self.resource_name
        'auth'
      end

      def self.attributes 
        # http://www.cardconnect.com/developer/docs/#authorization-request
        {
          merchid: { 
            required: true, 
            maxLength: 12
          }, 
          accttype: {
            options: [PPAL, PAID, GIFT, PDEBIT]
          }, 
          account: {
            maxLength: 19,
            required: Proc.new {|request| !request.has_profile_id? }
          },
          expiry: {
            required: Proc.new {|request| !request.has_profile_id? },
            format: /^(0[1-9]|1[012])(\d{2})$/ ## MMYY (YYYYMMDD is also valid but I'm only going to support the MMYY here)
          }, 
          amount: {
            default: 0,
            maxLength: 12
          },
          currency: {
            default: USD
          },
          name: {
            maxLength: 30
          },
          address: {
            maxLength: 30
          }, 
          city: {
            maxLength: 30
          }, 
          region: {
            maxLength: 20
          }, 
          country: {
            maxLength: 2,
            default: US
          }, 
          phone: {
            maxLength: 15
          }, 
          postal: { 
            maxLength: 9
          }, 
          email: {
            maxLength: 30
          }, 
          ecomind: {
            maxLength: 1,
            default: ECOMMERCE
          }, 
          cvv2: {
            # card connect doesn't require this but since this is an online transaction it should be needed
            maxLength: 4,
            required: Proc.new {|request| !request.has_profile_id? } 
          }, 
          orderid: {
            maxLength: 19
          }, 
          track: {
            maxLength: 76
          }, 
          bankaba: {
            maxLength: 9
          }, 
          tokenize: {
            maxLength: 1,
            default: Y,
            options: [Y, N]
          }, 
          termid: {
            maxLength: 30
          }, 
          capture: {
            maxLength: 1,
            options: [Y, N],
            default: N
          },
          ssnl4:{
            maxLength: 4
          },
          license:{
            maxLength: 15
          },
          # http://www.cardconnect.com/developer/docs/#profiles
          profile: { 
            # could be 1 or 20 long
          }
          # USER FIELDS NOT IMPLEMENTED
          # http://www.cardconnect.com/developer/docs/#user-fields

          # 3D SECURE NOT IMPLEMENTED 
          # http://www.cardconnect.com/developer/docs/#3d-secure
        }
      end

      def card_type
        return nil if account.nil? or account.empty?
        CARD_TYPES.keys.each do |t|
          return t if card_is(t)
        end
        nil
      end

      def initialize(options={})
        if !options[:expiry] and month = options.delete(:expiry_month) and year = options.delete(:expiry_year)
          options[:expiry] = "#{sprintf('%02d', month.to_i)}#{sprintf('%02d', year.to_i)}"
        end

        super(options)
      end

      def validate
        if !has_profile_id? # card type required if no profile id supplied
          if !CardConnectGateway.configuration.supported_card_types.include?(card_type)
            self.errors[:card_type] = 'is not supported.'
          end
        end
        super
      end

      def has_profile_id?
        !profile.nil? and profile.length > 1
      end

      protected


      def card_is(type)
        (CARD_TYPES[type] and !!(account.gsub(/\s/,'') =~ CARD_TYPES[type]))
      end

    end
  end
end