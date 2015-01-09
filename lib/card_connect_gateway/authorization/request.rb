module CardConnectGateway
  module Authorization
    class Request < BaseRequest
      TELEPHONE = 'T' 
      RECURRING = 'R'
      ECOMMERCE = 'E'

      attr_accessor :merchid, :accttype, :account, :expiry, :amount, :currency, :name, :address, :city, :region, :country, :phone, 
                    :postal, :email, :ecomind, :cvv2, :orderid, :track, :bankaba, :tokenize, :termid, :capture, :profile

      CARD_TYPES = {
        VISA              => /^4\d{12}(\d{3})?$/,
        MASTERCARD        => /^(5[1-5]\d{4}|677189)\d{10}$/,
        DISCOVER          => /^(6011|65\d{2}|64[4-9]\d)\d{12}|(62\d{14})$/,
        AMEX              => /^3[47]\d{13}$/,
        DINERS_CLUB       => /^3(0[0-5]|[68]\d)\d{11}$/,
        JCB               => /^35(28|29|[3-8]\d)\d{12}$/,
        MAESTRO           => /^(5[06-8]|6\d)\d{10,17}$/
      }
      # from https://github.com/Shopify/active_merchant/blob/master/lib/active_merchant/billing/credit_card_methods.rb
      

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
        return @card_type if @card_type
        return nil if account.nil? or account.empty?
        CARD_TYPES.keys.each do |t|
          return t if card_is(t)
        end
        nil
      end

      def card_type=(card_type)
        @card_type = card_type
      end

      def initialize(options={})
        if !options[:expiry] and month = options.delete(:expiry_month) and year = options.delete(:expiry_year)
          options[:expiry] = "#{sprintf('%02d', month.to_i)}#{sprintf('%02d', year.to_i)}"
        end

        if options[:amount] and options[:amount].class != String
          options[:amount] = (options[:amount] * 100).to_i
        end

        super(options)
      end

      def validate
        if !has_profile_id? # card type required if no profile id supplied
          if card_type.nil?
            self.errors[:account] = 'is not valid.'
          elsif !CardConnectGateway.configuration.supported_card_types.include?(card_type)
            self.errors[:card_type] = 'is not supported.'
          end
        end
        super
      end

      def has_profile_id?
        !profile.nil? and profile.length > 1
      end

      def send
        # CardConnectGateway.configuration
        if !has_profile_id? and card_type == VISA and amount == 0 and cvv2 and !cvv2.empty? and postal and !postal.empty?
          # card connect doesn't let you do cvv and avs on a $0 visa auth so we have to do an extra request just for that
          extra_request = self.clone
          extra_request.cvv2 = nil
          extra_request.profile = nil
          extra_response = extra_request.send

          super.merge("avsresp" => extra_response["avsresp"])
        else
          super
        end
      end

      protected


      def card_is(type)
        (CARD_TYPES[type] and !!(account.gsub(/\s/,'') =~ CARD_TYPES[type]))
      end

    end
  end
end