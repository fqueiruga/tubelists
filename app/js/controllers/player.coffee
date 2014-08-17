'use strict'

### Youtube Player controller ###

angular.module('tubelistsApp.controllers.player', [])

.controller('PlayerCtrl', ['$scope', 'youTubePlayerService', 'playlistService'
  , ($scope, youTubePlayerService, playlistService) ->

    $scope.playlist = playlistService
    $scope.isPlaying = false

    $scope.loadVideo = (options)->
      options = options || {}
      if $scope.isPlaying or options.autoplay
        youTubePlayerService.loadVideo $scope.playlist.current().videoId
      else
        youTubePlayerService.cueVideo $scope.playlist.current().videoId

    $scope.remove = (video) ->
      playlistService.remove video

    $scope.$on 'youtube:player:ready', ->
      $scope.loadVideo() if $scope.playlist.current()?

    $scope.$on 'youtube:player:ended', ->
      # Youtube player will broadcast the PAUSED event before the ENDED event
      #   isPlaying will be false, so autoplay has to be forced
      next = playlistService.next()
      $scope.loadVideo { autoplay: true } if next?

    $scope.$on 'youtube:player:playing', ->
      $scope.isPlaying = true

    $scope.$on 'youtube:player:paused', ->
      $scope.isPlaying = false

])






