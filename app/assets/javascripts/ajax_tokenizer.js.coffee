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

    formatResponse = (responseText, number, deferred, status) ->
      data = JSON.parse(responseText.substring(14, responseText.length - 2));
      if data.action == "ER"
        deferred.reject({error: data.data.replace(/.*::/, ''), status: status})
      else
        deferred.resolve({token: data.data, last_four: data.data.substr(data.data.length - 4, data.data.length), card_type: getCardType(number), status: status})

    this.tokenize = (number) ->
      url = "https://#{$window.CARDCONNECT_AJAX_URL}?type=json&action=CE&data=#{number}"
      deferred = $q.defer()

      # http://stackoverflow.com/a/30655734/903043
      #Use the XDomainRequest for IE8-9, or angular get request will recieve "access denied" error.
      if window.XDomainRequest?
        xdr = new (window.XDomainRequest)
        #See explination below why global.pendingXDR is set.  Cleaning up that memory here.

        removeXDR = (xdr) ->
          #You will need a indexOf function defined for IE8.  See http://stackoverflow.com/questions/3629183/why-doesnt-indexof-work-on-an-array-ie8.
          index = $window.pendingXDR.indexOf(xdr)
          if index >= 0
            $window.pendingXDR.splice index, 1

        if xdr
          # bind xdr.onload before sending the request (or the event does nothing).

          xdr.onload = ->
            removeXDR xdr
            formatResponse(xdr.responseText, number, deferred)

          xdr.onerror = (error) ->
            removeXDR xdr
            deferred.reject(data)

          xdr.open 'get', url
          xdr.send()
          #In Internet Explorer 8/9, the XDomainRequest object is incorrectly subject to garbage collection after
          #send() has been called but not yet completed. The symptoms of this bug are the Developer Tools'
          #network trace showing "Aborted" for the requests and none of the error, timeout, or success event
          #handlers being called.
          #To correctly work around this issue, ensure the XDomainRequest is stored in a global variable until
          #the request completes.
          $window.pendingXDR = []
          $window.pendingXDR.push xdr
      else
        $http.get(url).success((responseText, status, headers, config) ->
          # this returns a JSONP response processToken( { "action" : "CE", "data" : "actual token" } ) 
          # but they don't set the content-type header correctly so we can't use $http.jsonp
          # instead we can do a straight GET and process it from text. 14 is the length of "processToken( "
          # a bit brittle but they didn't leave us much choice
          
          formatResponse(responseText, number, deferred, status)
        ).error((data, status, headers, config) ->
          deferred.reject({error: data, status: status})
        )
        
      deferred.promise
    this


) angular