'use strict'

#
# Service that handles de YouTube player
#
describe "YouTube Player Service", ->

  beforeEach module "tubelistsApp.services.youTubePlayer"

  beforeEach ->
    inject ($injector) =>
      @playerStates = $injector.get 'YTPlayerStates'
      @youtube = $injector.get 'youTubePlayerService',
        YTPlayerStates: @playerStates

      @window = $injector.get '$window'

      @youtube.createPlayer =
            jasmine.createSpy("createPlayer() spy").and.callFake -> @player = {}


  it "should react to YouTubeAPIReady", ->
    inject ($rootScope) =>
      @rootScope = $rootScope
      spyOn @rootScope, '$broadcast'

    @window.onYouTubeIframeAPIReady()
    expect(@youtube.apiReady).toEqual true

  it "should emit the playerReady event", ->
    inject ($rootScope) =>
      @rootScope = $rootScope
      spyOn @rootScope, '$broadcast'

    @youtube.onPlayerReady()
    expect(@rootScope.$broadcast)
      .toHaveBeenCalledWith 'youtube:player:ready'

  it "should load and play a video", ->
    @youtube.player = loadVideoById: jasmine.createSpy("loadVideoById spy")
    videoId = "myVideo"
    @youtube.loadVideo videoId

    expect(@youtube.videoId).toEqual videoId
    expect(@youtube.player.loadVideoById)
      .toHaveBeenCalledWith videoId: videoId

  it "should load a video", ->
    @youtube.player = cueVideoById: jasmine.createSpy("cueVideoById spy")
    videoId = "myVideo"
    @youtube.cueVideo videoId

    expect(@youtube.videoId).toEqual videoId
    expect(@youtube.player.cueVideoById)
      .toHaveBeenCalledWith videoId: videoId


  describe "responding to youtube state", ->

    beforeEach ->
      inject ($injector) =>
        @rootScope = $injector.get '$rootScope'
        spyOn @rootScope, '$broadcast'

    it "should broadcast video ended event", ->
      @youtube.onPlayerStateChange { data: @playerStates.ENDED }
      expect(@rootScope.$broadcast)
        .toHaveBeenCalledWith "youtube:player:ended"

    it "should broadcast video playing event", ->
      @youtube.onPlayerStateChange { data: @playerStates.PLAYING }
      expect(@rootScope.$broadcast)
        .toHaveBeenCalledWith "youtube:player:playing"

    it "should broadcast video paused event", ->
      @youtube.onPlayerStateChange { data: @playerStates.PAUSED }
      expect(@rootScope.$broadcast)
        .toHaveBeenCalledWith "youtube:player:paused"

    it "should broadcast video in unknownState event", ->
      @youtube.onPlayerStateChange { data: 1337 }
      expect(@rootScope.$broadcast)
        .toHaveBeenCalledWith "youtube:player:unknownState"
