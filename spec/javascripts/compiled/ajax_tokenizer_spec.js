(function() {
  describe("cardConnect", function() {
    return describe("ajaxTokenizer", function() {
      var AMEX_APPROVAL_ACCOUNT, CARDCONNECT_AJAX_URL, DINERS_APPROVAL_ACCOUNT, DISCOVER_APPROVAL_ACCOUNT, JCB_APPROVAL_ACCOUNT, MASTERCARD_APPROVAL_ACCOUNT, VISA_APPROVAL_ACCOUNT, ajaxTokenizer, httpBackend;
      httpBackend = null;
      ajaxTokenizer = null;
      CARDCONNECT_AJAX_URL = 'some.url';
      VISA_APPROVAL_ACCOUNT = '4788250000121443';
      MASTERCARD_APPROVAL_ACCOUNT = '5454545454545454';
      AMEX_APPROVAL_ACCOUNT = '371449635398431';
      DISCOVER_APPROVAL_ACCOUNT = '6011000995500000';
      DINERS_APPROVAL_ACCOUNT = '36438999960016';
      JCB_APPROVAL_ACCOUNT = '3528000000000007';
      beforeEach(module("cardConnect"));
      beforeEach(inject(function(_ajaxTokenizer_, $httpBackend, $window) {
        ajaxTokenizer = _ajaxTokenizer_;
        httpBackend = $httpBackend;
        return $window.CARDCONNECT_AJAX_URL = CARDCONNECT_AJAX_URL;
      }));
      afterEach(function() {
        httpBackend.verifyNoOutstandingExpectation();
        return httpBackend.verifyNoOutstandingRequest();
      });
      it("gets token", inject(function() {
        httpBackend.whenJSONP("https://" + CARDCONNECT_AJAX_URL + "?type=json&action=CE&data=" + VISA_APPROVAL_ACCOUNT).respond({
          data: "47-hzj9xh9N-1443",
          action: "CE"
        });
        ajaxTokenizer.tokenize(VISA_APPROVAL_ACCOUNT).then(function(tokenizedCard) {
          expect(tokenizedCard.token.substr(0, 2)).toEqual(VISA_APPROVAL_ACCOUNT.substr(0, 2));
          expect(tokenizedCard.token.substr(tokenizedCard.token.length - 4, tokenizedCard.token.length)).toEqual(VISA_APPROVAL_ACCOUNT.substr(VISA_APPROVAL_ACCOUNT.length - 4, VISA_APPROVAL_ACCOUNT.length));
          return expect(tokenizedCard.token.substr(tokenizedCard.token.length - 4, tokenizedCard.token.length)).toEqual(tokenizedCard.last_four);
        });
        return httpBackend.flush();
      }));
      return it("checks numbers", inject(function() {
        expect(ajaxTokenizer.getCardType(VISA_APPROVAL_ACCOUNT)).toEqual("Visa");
        expect(ajaxTokenizer.getCardType(MASTERCARD_APPROVAL_ACCOUNT)).toEqual("MasterCard");
        expect(ajaxTokenizer.getCardType(AMEX_APPROVAL_ACCOUNT)).toEqual("AMEX");
        expect(ajaxTokenizer.getCardType(DISCOVER_APPROVAL_ACCOUNT)).toEqual("Discover");
        expect(ajaxTokenizer.getCardType(DINERS_APPROVAL_ACCOUNT)).toEqual("Diners Club");
        return expect(ajaxTokenizer.getCardType(JCB_APPROVAL_ACCOUNT)).toEqual("JCB");
      }));
    });
  });

}).call(this);
