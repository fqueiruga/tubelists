'use strict'

### Video Search controller ###

angular.module('tubelistsApp.controllers.search', [])

.controller('SearchCtrl', ['$log', '$scope', 'youTubeSearchService'
  , 'playlistService'
  , ($log, $scope, youTubeSearchService, playlistService) ->

    $scope.search = ->
      promise = youTubeSearchService.search $scope.query
      promise.then (items) ->
        $scope.results = items

    $scope.add = (video) ->
      playlistService.add video

])







