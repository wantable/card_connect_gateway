describe "cardConnect", ->
  describe "ajaxTokenizer", ->
    httpBackend = null
    ajaxTokenizer = null
    CARDCONNECT_AJAX_URL = 'fts.prinpay.com/cardsecure'

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
      number = '4444333322221111'

      httpBackend.whenJSONP("https://#{CARDCONNECT_AJAX_URL}?type=json&action=CE&data=#{number}").respond({
        data: "44-hzj9xh9N-1111",
        action: "CE"
      })

      ajaxTokenizer.tokenize(number).then((data) ->
        token = data.data.data
        expect(token.substr(0,2)).toEqual(number.substr(0,2))
        expect(token.substr(token.length-4, token.length)).toEqual(number.substr(number.length-4, number.length))
        

      )
      httpBackend.flush()

    )

