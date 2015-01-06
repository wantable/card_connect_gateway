(function() {
  describe("cardConnect", function() {
    return describe("ajaxTokenizer", function() {
      var CARDCONNECT_AJAX_URL, ajaxTokenizer, httpBackend;
      httpBackend = null;
      ajaxTokenizer = null;
      CARDCONNECT_AJAX_URL = 'fts.prinpay.com/cardsecure';
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
      return it("gets token", inject(function() {
        var number;
        number = '4444333322221111';
        httpBackend.whenJSONP("https://" + CARDCONNECT_AJAX_URL + "?type=json&action=CE&data=" + number).respond({
          data: "44-hzj9xh9N-1111",
          action: "CE"
        });
        ajaxTokenizer.tokenize(number).then(function(data) {
          var token;
          token = data.data.data;
          expect(token.substr(0, 2)).toEqual(number.substr(0, 2));
          return expect(token.substr(token.length - 4, token.length)).toEqual(number.substr(number.length - 4, number.length));
        });
        return httpBackend.flush();
      }));
    });
  });

}).call(this);
