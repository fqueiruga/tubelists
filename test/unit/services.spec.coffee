'use strict'

# jasmine specs for services go here

describe "Services", ->

  #
  # Service that handles the playlists
  #
  describe "PlayList Service", ->

    beforeEach module "tubelistsApp.services"

    beforeEach(inject (playListService) ->
      @playList = playListService
      @playList.upcoming = ["Numa Numa"]
      @playList.played = []
    )

    it "should add a new item to the upcoming list", ->
      expect(@playList.upcoming.length).toBe 1
      @playList.add "Chocolate Rain"
      expect(@playList.upcoming.length).toBe 2


    it "should change to the next item", ->
      next = @playList.next()
      expect(next).toEqual "Numa Numa"
      expect(@playList.upcoming.length).toBe 0
      expect(@playList.played.length).toBe 1

      expect(@playList.next()).not.toBeDefined()


    it "should export the playlist merging both arrays", ->
      @playList.played = ["Chocolate Rain", "Rick Roll"]

      list = @playList.playList()
      expect(list).toEqual(["Chocolate Rain", "Rick Roll", "Numa Numa"])



  #
  # Service that handles de YouTube player
  #
  describe "YouTube Player Service", ->

    beforeEach module "tubelistsApp.services"

    beforeEach(inject ($injector) ->
      @playerStates = $injector.get 'YTPlayerStates'
      @youtube = $injector.get 'youTubePlayerService',
        YTPlayerStates: @playerStates

      @window = $injector.get '$window'

      @youtube.createPlayer =
            jasmine.createSpy("createPlayer() spy").andCallFake -> @player = {}
    )

    it "should react to YouTubeAPIReady", ->
      @window.onYouTubeIframeAPIReady()
      expect(@youtube.apiReady).toEqual true
      expect(@youtube.player).not.toBeNull()

    it "should bind the player parameters", ->
      params =
        height: 200
        width: 200
        playerId: "player"
      @youtube.bindPlayer params
      expect(@youtube.playerId).toBeDefined()

    it "should play a video given its id", ->
      @youtube.player = loadVideoById: jasmine.createSpy("loadVideoById spy")
      videoId = "myVideo"
      @youtube.play videoId

      expect(@youtube.videoId).toEqual videoId
      expect(@youtube.player.loadVideoById)
        .toHaveBeenCalledWith videoId: videoId


    describe "responding to youtube state", ->

      beforeEach(inject ($injector) ->
        @rootScope = $injector.get '$rootScope'
        spyOn @rootScope, '$broadcast'
        @event = 'youtube:player'
      )

      it "should broadcast video ended event", ->
        @youtube.onPlayerStateChange { data: @playerStates.ENDED }
        expect(@rootScope.$broadcast).toHaveBeenCalledWith 'youtube:player',
          data: 'ended'

      it "should broadcast video playing event", ->
        @youtube.onPlayerStateChange { data: @playerStates.PLAYING }
        expect(@rootScope.$broadcast).toHaveBeenCalledWith @event,
          data: 'playing'

      it "should broadcast video paused event", ->
        @youtube.onPlayerStateChange { data: @playerStates.PAUSED }
        expect(@rootScope.$broadcast).toHaveBeenCalledWith @event,
          data: 'paused'

      it "should broadcast video in unknownState event", ->
        @youtube.onPlayerStateChange { data: 1337 }
        expect(@rootScope.$broadcast).toHaveBeenCalledWith @event,
          data: 'unknownState'

