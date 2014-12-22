module CardConnectGateway
  module Authorization
    class Request
      PPAL = 'PPAL'
      PAID = 'PAID', 
      GIFT= 'GIFT'
      PDEBIT = 'PDEBIT'
      USD = 'USD'
      ACCTYPE_OPTIONS = [PPAL, PAID, GIFT, PDEBIT]

      def self.attributes 
        {
          merchid: { 
            required: true, 
            maxLength: 12,
            default: CardConnectGateway.config.merchant_id
          }, 
          accttype: {
            required: false,
            options: ACCTYPE_OPTIONS
          }, 
          account: {
            required: true
            maxLength: 19,
          },
          expiry: {
            required: true,
            format: /^0[1-9]|1[012](19|20)\d\d$/ ## MMYY (YYYYMMDD is also valid but I'm only going to support the MMYY here)
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
          :name, :address, :city, :region, :country, :phone, :postal, 
        :email, :ecomind, :cvv2, :orderid, :track, :bankaba, :tokenize, :termid, :capture}
      end

      def initialize(options={})
        # todo - set attributes from options, validate things

        options.each do |key, value|
          send("@#{key}=", value.to_s)
        end
      end

      def validate

        if format

      end

      def valid?

      end

      def errors
        @errors || {}
      end

      def to_hash
        self.class.attributes.keys.inject({}) do |hash, value|
          hash[:value] = send("@#{value}")
          hash
        end
      end
    end
  end
end