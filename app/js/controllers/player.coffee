'use strict'

### Youtube Player controller ###

angular.module('tubelistsApp.controllers.player', [])

.controller('PlayerCtrl', ['$scope', 'youTubePlayerService', 'playlistService'
  , ($scope, youTubePlayerService, playlistService) ->

    $scope.playlist = playlistService
    $scope.isPlaying = false

    $scope.controls =
      play: ->
          youTubePlayerService.player.playVideo() unless $scope.isPlaying

      pause: ->
          youTubePlayerService.player.pauseVideo() if $scope.isPlaying

      next: ->
        next = $scope.playlist.next()
        $scope.controls.loadVideo() if next?

      previous: ->
        previous = $scope.playlist.previous()
        $scope.controls.loadVideo() if previous?

      loadVideo: (options)->
        options = options || {}
        if $scope.isPlaying or options.autoplay
          youTubePlayerService.loadVideo $scope.playlist.current.videoId
        else
          youTubePlayerService.cueVideo $scope.playlist.current.videoId

    $scope.$watch 'isPlaying', ->
      $scope.state = if $scope.isPlaying then "playing" else "paused"

    $scope.queue = (video) ->
      $scope.playlist.add video

    $scope.remove = (video) ->
      $scope.playlist.remove video

    $scope.$on 'youtube:player:ready', ->
      $scope.controls.loadVideo() if $scope.playlist.current?

    $scope.$on 'youtube:player:ended', ->
      # Youtube player will broadcast the PAUSED event before the ENDED event
      #   isPlaying will be false, so autoplay has to be forced
      next = $scope.playlist.next()
      $scope.controls.loadVideo {autoplay: true} if next?

    $scope.$on 'youtube:player:playing', ->
      $scope.isPlaying = true

    $scope.$on 'youtube:player:paused', ->
      $scope.isPlaying = false

])






