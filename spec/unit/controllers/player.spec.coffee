'use strict'

describe "PlayerCtrl", ->

  beforeEach module "tubelistsApp.controllers.player"

  beforeEach ->
    @playlist = jasmine.createSpyObj 'playlist', ['remove', 'add']
    @playlist.history = [{videoId: "vid1"}, {videoId: "vid2"}]
    @playlist.upcoming = [{videoId: "vid4"}, {videoId: "vid5"}]
    @playlist.current = {videoId : "vid3"}

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

  it "should work", ->
    expect(true).toEqual true

  it "should queue a video", ->
    @scope.queue {video: "vid1"}
    expect(@playlist.add).toHaveBeenCalled()

  it "should remove a video from the play list", ->
    @scope.remove {video: "vid1"}
    expect(@playlist.remove).toHaveBeenCalled()

  it "should watch the values of $scope.isPlaying to set the state", ->
    @scope.isPlaying = true
    @scope.$digest()
    expect(@scope.state).toEqual "playing"

    @scope.isPlaying = false
    @scope.$digest()
    expect(@scope.state).toEqual "paused"


  describe "player controls", ->

    beforeEach ->
      @ytPlayer.player = jasmine.createSpyObj 'ytPlayer.player', [
        'playVideo'
        'pauseVideo'
        'reset'
      ]


    it "should play the current video if the player is paused", ->
      @scope.isPlaying = false
      @scope.controls.play()
      expect(@ytPlayer.player.playVideo).toHaveBeenCalled()

      @ytPlayer.player.playVideo.calls.reset()
      @scope.isPlaying = true
      @scope.controls.play()
      expect(@ytPlayer.player.playVideo).not.toHaveBeenCalled()

    it "should pause the current video if the player is playing", ->
      @scope.isPlaying = true
      @scope.controls.pause()
      expect(@ytPlayer.player.pauseVideo).toHaveBeenCalled()

      @ytPlayer.player.pauseVideo.calls.reset()
      @scope.isPlaying = false
      @scope.controls.pause()
      expect(@ytPlayer.player.pauseVideo).not.toHaveBeenCalled()

    it "should play the next video", ->
      spyOn(@scope.controls, 'loadVideo')
      @playlist.next = jasmine.createSpy("playlist next")
        .and.returnValue @playlist.upcoming[0]
      @scope.controls.next()
      expect(@scope.controls.loadVideo).toHaveBeenCalled()

    it "should play the previous video", ->
      spyOn(@scope.controls, 'loadVideo')
      @playlist.previous = jasmine.createSpy("playlist previous")
        .and.returnValue @playlist.upcoming[0]
      @scope.controls.previous()
      expect(@scope.controls.loadVideo).toHaveBeenCalled()

    it "should load the current video", ->
      @scope.isPlaying = false
      @scope.controls.loadVideo()
      expect(@ytPlayer.cueVideo).toHaveBeenCalled()

      @scope.controls.loadVideo {autoplay: true}
      expect(@ytPlayer.loadVideo).toHaveBeenCalled()

      @ytPlayer.loadVideo.calls.reset()
      @scope.isPlaying = true
      @scope.controls.loadVideo()
      expect(@ytPlayer.loadVideo).toHaveBeenCalled()


  describe "scope event listeners for youtube:player", ->

    beforeEach ->
      inject ($rootScope) => @rootScope = $rootScope
      @event = 'youtube:player'

    it "should try to load the current video
         when the youtube player is ready", ->
      spyOn(@scope.controls, 'loadVideo')
      @rootScope.$broadcast "youtube:player:ready"
      expect(@scope.controls.loadVideo).toHaveBeenCalled()

    it "shouln't try to load the current video when the youtube player
        is ready and no current video is set", ->
      spyOn(@scope.controls, 'loadVideo')
      @scope.playlist.current = null
      @scope.$digest()
      @rootScope.$broadcast "youtube:player:ready"
      expect(@scope.controls.loadVideo).not.toHaveBeenCalled()

    it "should play the next video when a video ends", ->
      spyOn(@scope.controls, 'loadVideo')
      @playlist.next = jasmine.createSpy("playlist next")
        .and.returnValue "video"
      @rootScope.$broadcast "youtube:player:ended"

      expect(@scope.playlist.next).toHaveBeenCalled()
      expect(@scope.controls.loadVideo).toHaveBeenCalledWith {autoplay: true}

    it "should set state as playing when Playing state is broadcast", ->
      @scope.isPlaying = false
      @scope.$digest()
      @rootScope.$broadcast "youtube:player:playing"
      expect(@scope.isPlaying).toBe true

    it "should set state as paused when Paused state is broadcast", ->
      @scope.isPlaying = true
      @rootScope.$broadcast "youtube:player:paused"
      expect(@scope.isPlaying).toBe false
