describe "cardConnect", ->
  describe "ajaxTokenizer", ->
    httpBackend = null
    ajaxTokenizer = null
    CARDCONNECT_AJAX_URL = 'some.url'

    VISA_APPROVAL_ACCOUNT = '4788250000121443'
    MASTERCARD_APPROVAL_ACCOUNT = '5454545454545454'
    AMEX_APPROVAL_ACCOUNT = '371449635398431'
    DISCOVER_APPROVAL_ACCOUNT = '6011000995500000'
    DINERS_APPROVAL_ACCOUNT = '36438999960016'
    JCB_APPROVAL_ACCOUNT = '3528000000000007'

    beforeEach module("cardConnect")

    beforeEach inject((_ajaxTokenizer_, $httpBackend, $window) ->
      ajaxTokenizer = _ajaxTokenizer_
      httpBackend = $httpBackend
      $window.CARDCONNECT_AJAX_URL = CARDCONNECT_AJAX_URL
    )

    afterEach( ->
      httpBackend.verifyNoOutstandingExpectation()
      httpBackend.verifyNoOutstandingRequest()
    )

    it "gets token", inject( -> 

      httpBackend.whenGET("https://#{CARDCONNECT_AJAX_URL}?type=json&action=CE&data=#{VISA_APPROVAL_ACCOUNT}").respond('processToken( { "action" : "CE", "data" : "47-hzj9xh9N-1443" } )')

      ajaxTokenizer.tokenize(VISA_APPROVAL_ACCOUNT).then((tokenizedCard) ->
        expect(tokenizedCard.token.substr(0,2)).toEqual(VISA_APPROVAL_ACCOUNT.substr(0,2))
        expect(tokenizedCard.token.substr(tokenizedCard.token.length-4, tokenizedCard.token.length)).toEqual(VISA_APPROVAL_ACCOUNT.substr(VISA_APPROVAL_ACCOUNT.length-4, VISA_APPROVAL_ACCOUNT.length))
        expect(tokenizedCard.token.substr(tokenizedCard.token.length-4, tokenizedCard.token.length)).toEqual(tokenizedCard.last_four)
      )
      httpBackend.flush()

    )

    it "checks numbers", inject( ->
      expect(ajaxTokenizer.getCardType(VISA_APPROVAL_ACCOUNT)).toEqual("Visa")
      expect(ajaxTokenizer.getCardType(MASTERCARD_APPROVAL_ACCOUNT)).toEqual("MasterCard")
      expect(ajaxTokenizer.getCardType(AMEX_APPROVAL_ACCOUNT)).toEqual("AMEX")
      expect(ajaxTokenizer.getCardType(DISCOVER_APPROVAL_ACCOUNT)).toEqual("Discover")
      expect(ajaxTokenizer.getCardType(DINERS_APPROVAL_ACCOUNT)).toEqual("Diners Club")
      expect(ajaxTokenizer.getCardType(JCB_APPROVAL_ACCOUNT)).toEqual("JCB")
    )

