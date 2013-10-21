'use strict'

### Controllers ###

angular.module('tubelistsApp.controllers', [])


# Video search controller
.controller 'SearchCtrl', ['$scope'
  , ($scope) ->

    $scope.firstName = "Ratoncito"
    $scope.secondName = "Pérez"

    $scope.fullName = ->
      "#{$scope.firstName} #{$scope.secondName}"

]



