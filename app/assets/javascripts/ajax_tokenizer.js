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
      var formatResponse, getCardType;
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
      formatResponse = function(responseText, number, deferred) {
        var data;
        data = JSON.parse(responseText.substring(14, responseText.length - 2));
        if (data.action === "ER") {
          return deferred.reject(data.data.replace(/.*::/, ''));
        } else {
          return deferred.resolve({
            token: data.data,
            last_four: data.data.substr(data.data.length - 4, data.data.length),
            card_type: getCardType(number)
          });
        }
      };
      this.tokenize = function(number) {
        var deferred, removeXDR, url, xdr;
        url = "https://" + $window.CARDCONNECT_AJAX_URL + "?type=json&action=CE&data=" + number;
        deferred = $q.defer();
        if (window.XDomainRequest != null) {
          xdr = new window.XDomainRequest;
          removeXDR = function(xdr) {
            var index;
            index = $window.pendingXDR.indexOf(xdr);
            if (index >= 0) {
              return $window.pendingXDR.splice(index, 1);
            }
          };
          if (xdr) {
            xdr.onload = function() {
              removeXDR(xdr);
              return formatResponse(xdr.responseText, number, deferred);
            };
            xdr.onerror = function(error) {
              removeXDR(xdr);
              return deferred.reject(data);
            };
            xdr.open('get', url);
            xdr.send();
            $window.pendingXDR = [];
            $window.pendingXDR.push(xdr);
          }
        } else {
          $http.get(url).success(function(responseText, status, headers, config) {
            return formatResponse(responseText, number, deferred);
          }).error(function(data, status, headers, config) {
            return deferred.reject(data);
          });
        }
        return deferred.promise;
      };
      return this;
    });
  })(angular);

}).call(this);
