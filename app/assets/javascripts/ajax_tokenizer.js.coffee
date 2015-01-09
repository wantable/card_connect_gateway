((angular) ->
  cardConnect = angular.module('cardConnect', [])

  # same regex as in CardConnectGateway::Authorization::Request
  cardTypes = {
    "Visa": new RegExp(/^4\d{12}(\d{3})?$/),
    "MasterCard": new RegExp(/^(5[1-5]\d{4}|677189)\d{10}$/,),
    "Maestro": new RegExp(/^(5[06-8]|6\d)\d{10,17}$/),
    "Diners Club": new RegExp(/^3(0[0-5]|[68]\d)\d{11}$/),
    "AMEX": new RegExp(/^3[47]\d{13}$/),
    "Discover": new RegExp(/^(6011|65\d{2}|64[4-9]\d)\d{12}|(62\d{14})$/,),
    "JCB": new RegExp(/^35(28|29|[3-8]\d)\d{12}$/)
  }

  cardConnect.service 'ajaxTokenizer', ($http, $window, $q) ->
    getCardType = (number) -> 
      found = null
      angular.forEach cardTypes, (regex, type_) ->
        found = type_ if regex.test(number) is true

      found

    this.getCardType = getCardType

    this.tokenize = (number) ->
      deferred = $q.defer()
      $http.get("https://#{$window.CARDCONNECT_AJAX_URL}?type=json&action=CE&data=#{number}").success((responseText, status, headers, config) ->
        # this returns a JSONP response processToken( { "action" : "CE", "data" : "actual token" } ) 
        # but they don't set the content-type header correctly so we can't use $http.jsonp
        # instead we can do a straight GET and process it from text. 14 is the length of "processToken( "
        # a bit brittle but they didn't leave us much choice
        
        data = JSON.parse(responseText.substring(14, responseText.length - 2));
        deferred.resolve({token: data.data, last_four: data.data.substr(data.data.length-4, 4), card_type: getCardType(number)})
      ).error((data, status, headers, config) ->
        deferred.reject(data)
      )
      deferred.promise
    this


) angular