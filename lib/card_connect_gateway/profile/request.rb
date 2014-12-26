module CardConnectGateway
  module Profile
    class Request < BaseRequest
      

      attr_accessor :profile, :defaultacct, :profileupdate, :accttype, :merchid, :account, :bankaba, :expiry, :name, 
                    :street, :city, :region, :country, :phone, :postal, :ssnl4, :email, :license

      def self.resource_name
        'profile'
      end

      def self.attributes 
        {
          profile: {
            maxLength: 20,
          },
          defaultacct: {
            options: [Y, N],
            default: Y
          },
          profileupdate: {
            options: [Y, N],
            default: N
          },
          accttype: {
            options: [PPAL, PAID, GIFT, PDEBIT]
          },
          merchid: { 
            required: true, 
            maxLength: 12
          }, 
          account: {
            required: true,
            maxLength: 19
          },
          bankaba: {
            maxLength: 9
          },
          expiry: {
            required: true,
            format: /^(0[1-9]|1[012])(\d{2})$/ ## MMYY (YYYYMMDD is also valid but I'm only going to support the MMYY here)
          }, 
          name: {
            maxLength: 30
          },
          street: {
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
          ssnl4: { 
            maxLength: 4
          }, 
          email: {
            maxLength: 30
          }, 
          license: {
            maxLength: 15
          }
        }
      end

      def initialize(options={})
        if !options[:expiry] and month = options.delete(:expiry_month) and year = options.delete(:expiry_year)
          options[:expiry] = "#{sprintf('%02d', month.to_i)}#{sprintf('%02d', year.to_i)}"
        end

        super(options)
      end

    end
  end
end