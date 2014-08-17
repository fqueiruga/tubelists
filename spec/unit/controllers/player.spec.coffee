'use strict'

describe "PlayerCtrl", ->

  beforeEach module "tubelistsApp.controllers.player"

  beforeEach ->
    @playlist = jasmine.createSpyObj 'playlist', [
      'remove'
      'add'
      'next'
      'current'
    ]
    @playlist.list = [
      {videoId: "vid1"}
      {videoId: "vid2"}
      {videoId: "vid3"}
      {videoId: "vid4"}
      {videoId: "vid5"}
    ]

    @ytPlayer = jasmine.createSpyObj 'ytPlayer', ['loadVideo', 'cueVideo']

  beforeEach ->
    angular.mock.module ($provide) =>
      $provide.value 'playlistService', @playlist
      $provide.value 'youTubePlayerService', @ytPlayer
      null

  beforeEach ->
    inject ($injector, $controller) =>
      @scope = $injector.get('$rootScope').$new()
      @ctrl = $controller 'PlayerCtrl',
        $scope: @scope


  describe "#remove", ->
    beforeEach ->
      @obj = {video: "vid1"}
      spyOn(@scope, 'loadVideo')

    it "should remove a video from the playlist", ->
      @playlist.current.and.returnValue {video: 'vid2'}
      @scope.remove @obj
      expect(@playlist.remove).toHaveBeenCalled()
      expect(@scope.loadVideo).not.toHaveBeenCalled()

    it 'should remove the current video from the playlist', ->
      @playlist.current.and.returnValue @obj
      @scope.remove @obj
      expect(@playlist.remove).toHaveBeenCalled()
      expect(@scope.loadVideo).toHaveBeenCalled()


  describe "#loadVideo", ->

    beforeEach ->
      @ytPlayer.player = jasmine.createSpyObj 'ytPlayer.player', [
        'playVideo'
        'pauseVideo'
        'reset'
      ]
      @playlist.current.and.returnValue @playlist.list[0]

    it "does not cue the current video if it is not playing", ->
      @scope.isPlaying = false
      @scope.loadVideo()
      expect(@ytPlayer.cueVideo).toHaveBeenCalled()

    it "cues the current video if autoplay is enabled", ->
      @scope.isPlaying = false
      @scope.loadVideo {autoplay: true}
      expect(@ytPlayer.loadVideo).toHaveBeenCalled()

    it "cues the current video if it is playing", ->
      @scope.isPlaying = true
      @scope.loadVideo()
      expect(@ytPlayer.loadVideo).toHaveBeenCalled()


  describe 'isCurrent', ->

    beforeEach ->
      @obj = { videoId: '123' }

    it 'returns true if the given video is the currently played', ->
      @playlist.current.and.returnValue @obj
      expect(@scope.isCurrent(@obj)).toBeTruthy()

    it 'returns false if the given video is not the currently played', ->
      @playlist.current.and.returnValue { videoId: 'abd' }
      expect(@scope.isCurrent(@obj)).toBeFalsy()


  describe "event listeners for youtube:player", ->

    beforeEach ->
      inject ($rootScope) => @rootScope = $rootScope
      @event = 'youtube:player'

    it 'tries to load the current video when the player is ready', ->
      spyOn(@scope, 'loadVideo')
      @playlist.current.and.returnValue @playlist.list[0]
      @rootScope.$broadcast 'youtube:player:ready'
      expect(@scope.loadVideo).toHaveBeenCalled()

    it "does not try to load the current video when the youtube player
        is ready and no current video is set", ->
      spyOn(@scope, 'loadVideo')
      @playlist.current.and.returnValue undefined
      @scope.$digest()
      @rootScope.$broadcast "youtube:player:ready"
      expect(@scope.loadVideo).not.toHaveBeenCalled()

    it "plays the next video when a video ends", ->
      spyOn(@scope, 'loadVideo')
      @playlist.next.and.returnValue @playlist.list[1]
      @rootScope.$broadcast 'youtube:player:ended'
      expect(@playlist.next).toHaveBeenCalled()
      expect(@scope.loadVideo).toHaveBeenCalledWith {autoplay: true}

    it "sets state as playing when Playing state is broadcast", ->
      @scope.isPlaying = false
      @scope.$digest()
      @rootScope.$broadcast "youtube:player:playing"
      expect(@scope.isPlaying).toBe true

    it "sets state as paused when Paused state is broadcast", ->
      @scope.isPlaying = true
      @rootScope.$broadcast "youtube:player:paused"
      expect(@scope.isPlaying).toBe false
