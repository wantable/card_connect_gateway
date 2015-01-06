((angular) ->
  cardConnect = angular.module('cardConnect', [])

  cardConnect.service 'ajaxTokenizer', ($http, $window) ->
    this.tokenize = (number) ->
      $http.jsonp("https://#{$window.CARDCONNECT_AJAX_URL}?type=json&action=CE&data=#{number}")

    this

) angular