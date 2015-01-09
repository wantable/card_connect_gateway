module CardConnectGateway
  module Profile
    class Response < BaseResponse

      attr_accessor :profileid, :acctid, :respstat, :account, :respcode, :resptext, :accttype, :expiry, :name, 
                  :address, :city, :region, :country, :phone, :postal, :ssnl4, :email, :defaultacct, :license, :expiry_month, :expiry_year

    end
  end
end