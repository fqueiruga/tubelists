'use strict'

### Video Search controller ###

angular.module('tubelistsApp.controllers.search', [])

.controller('SearchCtrl', ['$log', '$scope', 'youTubeSearchService'
  , 'playListService'
  , ($log, $scope, youTubeSearchService, playListService) ->

    $scope.search = ->
      promise = youTubeSearchService.search $scope.query
      promise.then (items) ->
        $scope.results = items

    $scope.add = (video) ->
      playListService.add video

])







