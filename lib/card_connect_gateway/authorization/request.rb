module CardConnectGateway
  module Authorization
    class Request < BaseRequest
      PPAL = 'PPAL'
      PAID = 'PAID', 
      GIFT= 'GIFT'
      PDEBIT = 'PDEBIT'
      USD = 'USD'
      US = 'US'
      TELEPHONE = 'T' 
      RECURRING = 'R'
      ECOMMERCE = 'E'


      attr_accessor :merchid, :accttype, :account, :expiry, :amount, :currency, :name, :address, :city, :region, :country, :phone, :postal, :email, :ecomind, :cvv2, :orderid, :track, :bankaba, :tokenize, :termid, :capture

      def self.attributes 
        {
          merchid: { 
            required: true, 
            maxLength: 12
          }, 
          accttype: {
            options: [PPAL, PAID, GIFT, PDEBIT]
          }, 
          account: {
            required: true,
            maxLength: 19
          },
          expiry: {
            required: true,
            format: /^(0[1-9]|1[012])(\d{2})$/ ## MMYY (YYYYMMDD is also valid but I'm only going to support the MMYY here)
          }, 
          amount: {
            required: true,
            default: 0,
            maxLength: 12
          },
          currency: {
            required: true,
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
            maxLength: 4
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
          }
        }
      end

      def initialize(options={})
        if !options[:expiry] and month = options.delete(:expiry_month) and year = options.delete(:expiry_year)
          options[:expiry] = "#{sprintf('%02d', month.to_i)}#{sprintf('%02d', year.to_i)}"
        end
        options[:merchid] ||= CardConnectGateway.configuration.merchant_id

        super(options)
      end

    end
  end
end