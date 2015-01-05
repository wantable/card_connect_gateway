module CardConnectGateway
  module Profile
    class Response < BaseResponse

      attr_accessor :profileid, :acctid, :respstat, :account, :respcode, :resptext, :accttype, :expiry, :name, 
                  :address, :city, :region, :country, :phone, :postal, :ssnl4, :email, :defaultacct, :license, :expiry_month, :expiry_year

      def validate
        self.errors = {}

        if respstat != APPROVED
          if resptext and !resptext.empty? and respproc and !respproc.empty?
            errors[respproc.to_sym] = resptext 
          else
            errors["Card Connect Gateway"] = "Unkown error."
          end
        end

        @validated = true

        errors.empty?
      end

      def initialize(options={})
        if options[:expiry]
          options[:expiry_month] = options[:expiry][0..1]
          options[:expiry_year] = options[:expiry][2..4]
        end
        super(options)
      end
    end
  end
end