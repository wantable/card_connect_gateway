module CardConnectGateway
  module Authorization
    class Response < BaseResponse

      # internal zip/address/customer name matching constants
      AVS_SUCCESS = 'success'
      AVS_FAIL = 'fail'
      AVS_UNKNOWN = 'unknown'

      # CVV codes from card connect
      CVV_MATCH = 'M'
      CVV_NO_MATCH = 'N'
      CVV_NOT_PROCESSED = 'P'
      CVV_MISSING = 'S'
      CVV_UNKNOWN_OR_NO_PARTICIPATE = 'U'
      CVV_NO_RESPONSE = 'X'

      # Card Connect avs response codes https://drive.google.com/file/d/0B3jCb2M9MdrKRVFXT043LUtuaDg/view
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

      VISA_ADDRESS_MATCH_CODES = [
        A, # Address matches, ZIP does not.
        B, # Street addresses match. Postal code not verified due to incompatible formats. (Acquirer sent both street address and postal code).
        D, # Street addresses and postal codes match. 
        F, # Street addresses and postal codes match. UK Only
        M, # Street address and postal code match. 
        X, # Not applicable. If present, replaced with ”Y” by V.I.P. Available for U.S. issuers only.
        Y  # Street address and postal code match.
      ]
      VISA_ZIPCODE_MATCH_CODES = [
        D, # Street addresses and postal codes match. 
        F, # Street addresses and postal codes match. UK Only
        M, # Street address and postal code match.
        P, # Postal code match. Acquirer sent both postal code and street address, but street address not verified due to incompatible formats.
        W, # Not applicable. If present, replaced with “Z” by V.I.P. Available to U.S. issuers only
        X, # Not applicable. If present, replaced with ”Y” by V.I.P. Available for U.S. issuers only.
        Y, # Street address and postal code match.
        Z  # Postal/ZIP matches; street address does not match or Street address not included in request.
      ]

      VISA_ADDRESS_MISMATCH_CODES = [
        C, # Street address and postal code not verified due to incompatible formats.
        N, # No match. Acquirer sent postal/ZIP code only, or, street address only, or, both postal code and street address. Also used when acquirer requests AVS, but sends no AVS data in Field 123.
        Z  # Postal/ZIP matches; street address does not match or Street address not included in request.
      ]

      VISA_ZIPCODE_MISMATCH_CODES = [
        A, # Address matches, ZIP does not.
        B, # Street addresses match. Postal code not verified due to incompatible formats. (Acquirer sent both street address and postal code).
        C, # Street address and postal code not verified due to incompatible formats.
        N  # No match.
      ]

      VISA_ADDRESS_UNKNOWN_CODES = [
        G, # Address information not verified for international transaction
        I, # Address information not verified,
        P, # Postal code match. Acquirer sent both postal code and street address, but street address not verified due to incompatible formats.
        S, # Not applicable. If present, replaced with “U” for domestic, and “G” for international by V.I.P. Available for U.S. issuers only
        U  # Address not verified for domestic transaction.
      ]

      VISA_ZIPCODE_UNKNOWN_CODES = [
        G, # Address information not verified for international transaction
        I, # Address information not verified
        S, # Not applicable
        U  # Address not verified for domestic transaction.
      ]

      MASTERCARD_ADDRESS_MATCH_CODES = [
        X, # Exact: Address and 9-digit ZIP Match
        Y, # Yes: Address and 5-digit ZIP Match
        A  # Address: Address Matches ZIP Does Not Match
      ]

      MASTERCARD_ZIPCODE_MATCH_CODES = [
        X, # Exact: Address and 9-digit ZIP Match
        Y, # Yes: Address and 5-digit ZIP Match
        W, # Whole Zip: 9-digit ZIP Matches, Address Does Not Match
        Z  # Zip: 5-digit ZIP Matches, Address Does Not Match
      ]

      MASTERCARD_ADDRESS_MISMATCH_CODES = [
        W, # Whole Zip: 9-digit ZIP Matches, Address Does Not Match
        Z, # Zip: 5-digit ZIP Matches, Address Does Not Match
        N  # No: Address and ZIP Do Not Match
      ]

      MASTERCARD_ZIPCODE_MISMATCH_CODES = [
        A, # Address: Address Matches ZIP Does Not Match
        N  # No: Address and ZIP Do Not Match
      ]
      
      MASTERCARD_ADDRESS_UNKNOWN_CODES = [
        U, # Address Info is Unavailable
        E, # Error: Transaction ineligible for address verification or edit error found in the message that prevents AVS from being performed
        S  # Service Not Supported: Issuer does not support address verification
      ]

      MASTERCARD_ZIPCODE_UNKNOWN_CODES = [
        U, # Address Info is Unavailable
        E, # Error: Transaction ineligible...
        S  # Service Not Supported: Issuer does not support address verification
      ]

      AMEX_ADDRESS_MATCH_CODES = [
        Y, # Address and ZIP Match
        A, # Address Matches ZIP Does Not Match
        M, # Cardmember Name, Billing Address and Postal Code match
        O, # Cardmember Name and Billing Address match
        E, # Cardmember Name incorrect, Billing Address and Postal Code match
        F  # Cardmember Name incorrect, Billing Address matches
      ]

      AMEX_ZIPCODE_MATCH_CODES = [
        Y, # Address and ZIP Match
        Z, # 9 or 5 digit ZIP Matches, Address Does Not Match
        L, # Cardmember Name and Billing Postal Code match
        M, # Cardmember Name, Billing Address and Postal Code match
        D, # Cardmember Name incorrect, Billing Postal Code matches
        E  # Cardmember Name incorrect, Billing Address and Postal Code match
      ]

      AMEX_CUSTOMER_NAME_MATCH_CODES = [
        L, # Cardmember Name and Billing Postal Code match
        M, # Cardmember Name, Billing Address and Postal Code match
        O  # Cardmember Name and Billing Address match
      ]

      AMEX_ADDRESS_MISMATCH_CODES = [
        Z, # 9 or 5 digit ZIP Matches, Address Does Not Match
        N, # Address and ZIP Do Not Match
        W  # No, Cardmember Name, Billing Address and Postal Code are allincorrect
      ]

      AMEX_ZIPCODE_MISMATCH_CODES = [
        A, # Address Matches ZIP Does Not Match
        N, # Address and ZIP Do Not Match
        W  # No, Cardmember Name, Billing Address and Postal Code are allincorrect
      ]

      AMEX_CUSTOMER_NAME_MISMATCH_CODES = [
        D, # Cardmember Name incorrect, Billing Postal Code matches
        E, # Cardmember Name incorrect, Billing Address and Postal Code match
        F, # Cardmember Name incorrect, Billing Address matches
        W  # No, Cardmember Name, Billing Address and Postal Code are allincorrect
      ]

      AMEX_ADDRESS_UNKNOWN_CODES = [
        U, # Address Information Is Unavailable
        S  # Issuer does not support address verification
      ]

      AMEX_ZIPCODE_UNKNOWN_CODES = [
        U, # Address Information Is Unavailable
        S  # Issuer does not support address verification
      ]

      DISCOVER_ADDRESS_MATCH_CODES = [
        A  # Address matches, Zip Code does not
      ]

      DISCOVER_ZIPCODE_MATCH_CODES = [
        X, # All digits match (9-digit Zip Code)
        Y, # All digits match (5-digit Zip Code)
        W, # 9-digit Zip matches, address does not
        Z # 5-digit Zip matches, address does not
      ]

      DISCOVER_ADDRESS_MISMATCH_CODES = [
        W, # 9-digit Zip matches, address does not
        Z, # 5-digit Zip matches, address does not
        N  # Nothing matches
      ]

      DISCOVER_ZIPCODE_MISMATCH_CODES = [
        A, # Address matches, Zip Code does not
        N  # Nothing matches
      ]

      DISCOVER_ADDRESS_UNKNOWN_CODES = [
        U, # No Data from Issuer/Auth System
        S, # AVS not supported at this time
        G  # Address information not verified for international transaction
      ]

      DISCOVER_ZIPCODE_UNKNOWN_CODES = [
        U, # No Data from Issuer/Auth System
        S, # AVS not supported at this time
        G  # Address information not verified for international transaction
      ]

      attr_accessor :retref, :account, :token, :amount, :avsresp, :cvvresp, :authcode, :commcard, :profileid, :check_cvv, 
                    :card_type, :zip_match, :address_match, :customer_name_match, :check_avs

      def validate
        self.errors = {}
 
        if respstat != APPROVED
          if resptext.present? and respproc.present?
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
            self.errors[:postal] = I18n.t(:doesnt_match) if zip_match == AVS_FAIL
          end
          if CardConnectGateway.configuration.require_avs_address_match
            self.errors[:address] = I18n.t(:unknown_error) if address_match.nil?
            self.errors[:address] = I18n.t(:doesnt_match) if address_match == AVS_FAIL
          end
          if CardConnectGateway.configuration.require_avs_customer_name_match
            self.errors[:name] = I18n.t(:unknown_error) if customer_name_match.nil?
            self.errors[:name] = I18n.t(:doesnt_match) if customer_name_match == AVS_FAIL
          end
        end

        @validated = true
        errors.empty?
      end

      def get_avs_response(match_codes, mis_match_codes, unknown_codes=[])
        if match_codes.include?(avsresp)
          AVS_SUCCESS
        elsif mis_match_codes.include?(avsresp)
          AVS_FAIL
        elsif unknown_codes.include?(avsresp)
          AVS_UNKNOWN
        end
      end

      def validate_avs_response
        # http://www.cardconnect.com/developer/docs/#address-verification-system
        # left empty if blocks in this function so it could easily be compared to the card connect documentation

        self.zip_match = nil
        self.address_match = nil
        self.customer_name_match = nil

        case card_type
        when VISA 
          self.zip_match = get_avs_response(VISA_ZIPCODE_MATCH_CODES, VISA_ZIPCODE_MISMATCH_CODES, VISA_ZIPCODE_UNKNOWN_CODES)
          self.address_match = get_avs_response(VISA_ADDRESS_MATCH_CODES, VISA_ADDRESS_MISMATCH_CODES, VISA_ADDRESS_UNKNOWN_CODES)
        when AMEX
          self.zip_match = get_avs_response(VISA_ZIPCODE_MATCH_CODES, VISA_ZIPCODE_MISMATCH_CODES, VISA_ZIPCODE_UNKNOWN_CODES)
          self.address_match = get_avs_response(VISA_ADDRESS_MATCH_CODES, VISA_ADDRESS_MISMATCH_CODES, VISA_ADDRESS_UNKNOWN_CODES)
          self.customer_name_match = get_avs_response(AMEX_CUSTOMER_NAME_MATCH_CODES, AMEX_CUSTOMER_NAME_MISMATCH_CODES)
        when MASTERCARD
          self.zip_match = get_avs_response(MASTERCARD_ZIPCODE_MATCH_CODES, MASTERCARD_ZIPCODE_MISMATCH_CODES, MASTERCARD_ZIPCODE_UNKNOWN_CODES)
          self.address_match = get_avs_response(MASTERCARD_ADDRESS_MATCH_CODES, MASTERCARD_ADDRESS_MISMATCH_CODES, MASTERCARD_ADDRESS_UNKNOWN_CODES)
        when DISCOVER
          self.zip_match = get_avs_response(DISCOVER_ZIPCODE_MATCH_CODES, DISCOVER_ZIPCODE_MISMATCH_CODES, DISCOVER_ZIPCODE_UNKNOWN_CODES)
          self.address_match = get_avs_response(DISCOVER_ADDRESS_MATCH_CODES, DISCOVER_ADDRESS_MISMATCH_CODES, DISCOVER_ADDRESS_UNKNOWN_CODES)
        end
      end
    end
  end
end