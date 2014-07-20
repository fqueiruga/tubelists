'use strict'

### Video Search controller ###

angular.module('tubelistsApp.controllers.search', [])

.controller('SearchCtrl', ['$log', '$scope', 'youTubeSearchService'
  , 'playListService'
  , ($log, $scope, youTubeSearchService, playListService) ->

    $scope.search = ->
      $scope.results = youTubeSearchService.search $scope.query

    $scope.add = (video) ->
      playListService.add video
])







