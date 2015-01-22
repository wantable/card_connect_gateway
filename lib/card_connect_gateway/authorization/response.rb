module CardConnectGateway
  module Authorization
    class Response < BaseResponse

      CVV_MATCH = 'M'
      CVV_NO_MATCH = 'N'
      CVV_NOT_PROCESSED = 'P'
      CVV_MISSING = 'S'
      CVV_UNKNOWN_OR_NO_PARTICIPATE = 'U'
      CVV_NO_RESPONSE = 'X'

      # Card Connect avs response codes http://www.cardconnect.com/developer/docs/#address-verification-system
      A = 'A'
      B = 'B'
      C = 'C'
      D = 'D'
      E = 'E'
      F = 'F'
      G = 'G'
      I = 'I'
      K = 'K'
      L = 'L'
      M = 'M'
      N = 'N'
      O = 'O'
      P = 'P'
      R = 'R'
      S = 'S'
      T = 'T'
      U = 'U'
      W = 'W'
      X = 'X'
      Y = 'Y'
      Z = 'Z'

      attr_accessor :respstat, :retref, :account, :token, :amount, :merchid, :respcode, :resptext, :respproc, :avsresp, 
                    :cvvresp, :authcode, :commcard, :profileid, :check_cvv, :card_type, :zip_match, :address_match, :customer_name_match, :check_avs

      def validate
        self.errors = {}
 
        if respstat != APPROVED
          if resptext and !resptext.empty? and respproc and !respproc.empty?
            self.errors[respproc.to_sym] = resptext 
          else
            self.errors["Card Connect Gateway"] = I18n.t(:unknown_error)
          end
        end

        if check_cvv
          if cvvresp == CVV_NO_MATCH or cvvresp == CVV_MISSING
            self.errors[:cvv2] = I18n.t(:doesnt_match)
          elsif cvvresp == CVV_NOT_PROCESSED or cvvresp == CVV_NO_RESPONSE or cvvresp == CVV_UNKNOWN_OR_NO_PARTICIPATE
            self.errors[:cvv2] = I18n.t(:unknown_error)
          end
        end

        if errors.empty? and check_avs
          # card connect doesn't appear to even do AVS if the are other errors
          validate_avs_response 
          if CardConnectGateway.configuration.require_avs_zip_code_match
            self.errors[:postal] = I18n.t(:unknown_error) if zip_match.nil?
            self.errors[:postal] = I18n.t(:doesnt_match) if zip_match == false
          end
          if CardConnectGateway.configuration.require_avs_address_match
            self.errors[:address] = I18n.t(:unknown_error) if address_match.nil?
            self.errors[:address] = I18n.t(:doesnt_match) if address_match == false
          end
          if CardConnectGateway.configuration.require_avs_customer_name_match
            self.errors[:name] = I18n.t(:unknown_error) if customer_name_match.nil?
            self.errors[:name] = I18n.t(:doesnt_match) if customer_name_match == false
          end
        end

        @validated = true
        errors.empty?
      end

      def validate_avs_response
        # http://www.cardconnect.com/developer/docs/#address-verification-system
        # left empty if blocks in this function so it could easily be compared to the card connect documentation

        self.zip_match = nil
        self.address_match = nil
        self.customer_name_match = nil

        case avsresp 
        when A
          if card_type == DISCOVER
            self.address_match = true
            self.zip_match = true 
          elsif card_type == MASTERCARD or card_type == AMEX
            self.address_match = true
            self.zip_match = false
          end
        when B 
          if card_type == VISA 
            self.address_match = true
            self.zip_match = false # Postal code not verified due to incompatible formats.
          end
        when C 
          if card_type == VISA 
            # Street address and postal code not verified due to incompatible formats.
            self.address_match = false 
            self.zip_match = false 
          end
        when D 
          if card_type == AMEX 
            self.zip_match = true 
            self.customer_name_match = false
          elsif card_type == VISA
            self.zip_match = true
            self.address_match = true
          end
        when E 
          if card_type == AMEX 
            self.address_match = true
            self.zip_match = true 
            self.customer_name_match = false
          end
        when F 
          if card_type == AMEX 
            self.address_match = true
            self.customer_name_match = false
          elsif card_type == VISA 
            self.address_match = true 
            self.zip_match = true
          end
        when G 
          if card_type == VISA or card_type == DISCOVER
            # Address information not verified for international transaction
            #   unfortunately this means that we can't verify the AVS (according to CardConnect tech support)
            #   so we have to allow it through
            self.address_match = true 
            self.zip_match = true
          end
        when I 
          if card_type == VISA 
            # Address information not verified
            #   unfortunately this means that we can't verify the AVS (according to CardConnect tech support)
            #   so we have to allow it through
            self.address_match = true 
            self.zip_match = true
          end
        when K 
          if card_type == AMEX 
            self.customer_name_match = true 
          end
        when L 
          if card_type == AMEX 
            self.customer_name_match = true
            self.zip_match = true
          end
        when M
          if card_type == AMEX  or card_type == VISA 
            self.address_match = true
            self.customer_name_match = true
            self.zip_match = true
          end
        when N 
          if card_type == MASTERCARD or card_type == AMEX or card_type == DISCOVER or card_type == VISA
            self.address_match = false
            self.customer_name_match = false
            self.zip_match = false
          end
        when O 
          if card_type == AMEX 
            self.address_match = true
            self.customer_name_match = true
          end
        when P 
          if card_type == VISA 
            # street address not verified due to incompatible formats
            self.zip_match = true
          end
        when R 
          if card_type == MASTERCARD or card_type == AMEX
            # System Unavailable; retry
          end
        when S 
          if card_type == MASTERCARD or card_type == AMEX or card_type == DISCOVER
            # Issuer Does Not Support Address Verification
            self.address_match = true 
            self.zip_match = true
          end
        when T 
          if card_type == DISCOVER 
            self.zip_match = true 
            self.address_match = false
          end
        when U 
          if card_type == MASTERCARD or card_type == AMEX or card_type == DISCOVER
            # Address Information Is Unavailable
            #   unfortunately this means that we can't verify the AVS (according to CardConnect tech support)
            #   so we have to allow it through
            self.address_match = true 
            self.zip_match = true
          end
        when W 
          if card_type == DISCOVER 
            # No data from Issuer/Authorization system
            #   unfortunately this means that we can't verify the AVS (according to CardConnect tech support)
            #   so we have to allow it through
            self.address_match = true 
            self.zip_match = true
          elsif card_type == AMEX
            # No, Cardmember Name, Billing Address and Postal Code are all incorrect
            self.address_match = false
            self.customer_name_match = false
            self.zip_match = false
          elsif card_type == MASTERCARD
            self.zip_match = true
            self.address_match = false
          end
        when X 
          if card_type == DISCOVER 
            self.zip_match = true 
          elsif card_type == MASTERCARD
            self.zip_match = true
            self.address_match = true
          end
        when Y 
          if card_type == DISCOVER
            self.address_match = true
            self.zip_match = false
          elsif card_type == VISA or card_type == MASTERCARD or card_type == AMEX
            self.address_match = true 
            self.zip_match = true
          end
        when Z 
          if card_type == DISCOVER
            self.address_match = false
            self.zip_match = true
          elsif card_type == VISA or card_type == MASTERCARD or card_type == AMEX
            self.address_match = false 
            self.zip_match = true
          end
        else
          # UNKNOWN RESPONSE
        end
      end
    end
  end
end