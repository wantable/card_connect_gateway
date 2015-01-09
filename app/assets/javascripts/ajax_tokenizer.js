(function() {
  (function(angular) {
    var cardConnect, cardTypes;
    cardConnect = angular.module('cardConnect', []);
    cardTypes = {
      "Visa": new RegExp(/^4\d{12}(\d{3})?$/),
      "MasterCard": new RegExp(/^(5[1-5]\d{4}|677189)\d{10}$/),
      "Maestro": new RegExp(/^(5[06-8]|6\d)\d{10,17}$/),
      "Diners Club": new RegExp(/^3(0[0-5]|[68]\d)\d{11}$/),
      "AMEX": new RegExp(/^3[47]\d{13}$/),
      "Discover": new RegExp(/^(6011|65\d{2}|64[4-9]\d)\d{12}|(62\d{14})$/),
      "JCB": new RegExp(/^35(28|29|[3-8]\d)\d{12}$/)
    };
    return cardConnect.service('ajaxTokenizer', function($http, $window, $q) {
      var getCardType;
      getCardType = function(number) {
        var found;
        found = null;
        angular.forEach(cardTypes, function(regex, type_) {
          if (regex.test(number) === true) {
            return found = type_;
          }
        });
        return found;
      };
      this.getCardType = getCardType;
      this.tokenize = function(number) {
        var deferred;
        deferred = $q.defer();
        $http.get("https://" + $window.CARDCONNECT_AJAX_URL + "?type=json&action=CE&data=" + number).success(function(responseText, status, headers, config) {
          var data;
          data = JSON.parse(responseText.substring(14, responseText.length - 2));
          return deferred.resolve({
            token: data.data,
            last_four: data.data.substr(data.data.length - 4, 4),
            card_type: getCardType(number)
          });
        }).error(function(data, status, headers, config) {
          return deferred.reject(data);
        });
        return deferred.promise;
      };
      return this;
    });
  })(angular);

}).call(this);
