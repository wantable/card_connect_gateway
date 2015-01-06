(function() {
  (function(angular) {
    var cardConnect;
    cardConnect = angular.module('cardConnect', []);
    return cardConnect.service('ajaxTokenizer', function($http, $window) {
      this.tokenize = function(number) {
        return $http.jsonp("https://" + $window.CARDCONNECT_AJAX_URL + "?type=json&action=CE&data=" + number);
      };
      return this;
    });
  })(angular);

}).call(this);
