'use strict'

### Youtube Player controller ###

angular.module('tubelistsApp.controllers.player', [])

.controller('PlayerCtrl', ['$scope', 'youTubePlayerService', 'playlistService'
  , ($scope, youTubePlayerService, playlistService) ->

    $scope.playlist = playlistService
    $scope.isPlaying = false

    # Loads or cues the current video
    $scope.loadVideo = (options)->
      options = options || {}
      if $scope.isPlaying or options.autoplay
        youTubePlayerService.loadVideo $scope.playlist.current().videoId
      else
        youTubePlayerService.cueVideo $scope.playlist.current().videoId

    $scope.remove = (video) ->
      return if @playlist.list.length == 1
      wasCurrent =  $scope.isCurrent(video)
      $scope.playlist.remove video
      $scope.loadVideo() if wasCurrent

    $scope.isCurrent = (video) ->
      $scope.playlist.current() == video


    # YouTube player event handlers
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


    # list initialization
    $scope.playlist.list = [
        videoId: "3MteSlpxCpo"
        title: "[Official Video] Daft Punk - Pentatonix"
        thumbnail: "https://i.ytimg.com/vi/3MteSlpxCpo/default.jpg"
      ,
        videoId: "ktvTqknDobU"
        title: "Imagine Dragons - Radioactive"
        thumbnail: "https://i.ytimg.com/vi/ktvTqknDobU/default.jpg"
      ,
        videoId: "6Ejga4kJUts"
        title: "The Cranberries - Zombie",
        thumbnail: "https://i.ytimg.com/vi/6Ejga4kJUts/default.jpg"
    ]

])






