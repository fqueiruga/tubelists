'use strict'

### Youtube Player controller ###

angular.module('tubelistsApp.controllers.player', [])

.controller('PlayerCtrl', ['$scope', 'youTubePlayerService', 'playListService'
  , ($scope, youTubePlayerService, playListService) ->

    $scope.playList = playListService
    $scope.isPlaying = false

    $scope.controls =
      play: ->
          youTubePlayerService.player.playVideo() unless $scope.isPlaying

      pause: ->
          youTubePlayerService.player.pauseVideo() if $scope.isPlaying

      next: ->
        next = $scope.playList.next()
        $scope.controls.loadVideo() if next?

      previous: ->
        previous = $scope.playList.previous()
        $scope.controls.loadVideo() if previous?

      loadVideo: (options)->
        options = options || {}
        if $scope.isPlaying or options.autoplay
          youTubePlayerService.loadVideo $scope.playList.current.videoId
        else
          youTubePlayerService.cueVideo $scope.playList.current.videoId

    $scope.$watch 'isPlaying', ->
      $scope.state = if $scope.isPlaying then "playing" else "paused"

    $scope.queue = (video) ->
      $scope.playList.add video

    $scope.remove = (video) ->
      $scope.playList.remove video

    $scope.$on 'youtube:player:ready', ->
      $scope.controls.loadVideo() if $scope.playList.current?

    $scope.$on 'youtube:player:ended', ->
      # Youtube player will broadcast the PAUSED event before the ENDED event
      #   isPlaying will be false, so autoplay has to be forced
      next = $scope.playList.next()
      $scope.controls.loadVideo {autoplay: true} if next?

    $scope.$on 'youtube:player:playing', ->
      $scope.isPlaying = true

    $scope.$on 'youtube:player:paused', ->
      $scope.isPlaying = false

])






