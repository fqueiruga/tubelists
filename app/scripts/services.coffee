'use strict'

#
# Service that provides the playlists functionality
#
class PlayListService

  constructor: -> @upcoming = @played = []

  next: ->
    item = @upcoming.shift()
    @played.push item if item?
    item

  add: (item) ->
    @upcoming.push item

  playList: ->
    @played.concat @upcoming


#
# Service that provides the functionality handle the Youtube Player
#
class YouTubePlayerService

  constructor: (@$rootScope, @$log, $window, @YTPlayerStates) ->
    @player = null
    @playerId = null
    @videoId = null
    @apiReady = false

    # Sets the global youtube API callback
    $window.onYouTubeIframeAPIReady = =>
      @apiReady = true
      @$log.info "Youtube API ready"
      @createPlayer()

  # Creates an instance of the youtube video player and binds the callbacks
  createPlayer: ->
    if @apiReady and @playerId?
      @player = new YT.Player @playerId,
          height: @height
          width: @width
          videoId: 'M7lc1UVf-VE'
          events:
            'onReady': => @$log.info "Youtube player ready"
            'onStateChange': @onPlayerStateChange
      @$log.info "Created Youtube Player"
    else
      @$log.info "Could not create Youtube player"

  # Callback that broadcasts the event ofyoutube video changing states
  onPlayerStateChange: (event) =>
    state = ""
    switch event.data
      when @YTPlayerStates.ENDED then state = "ended"
      when @YTPlayerStates.PLAYING then state = "playing"
      when @YTPlayerStates.PAUSED then state = "paused"
      else state = "unknownState"
    @$rootScope.$broadcast 'youtube:player', data: state

  # Binds the video player attributes
  bindPlayer: (params) ->
    @playerId = params.playerId
    @height = params.height
    @width = params.width
    @$log.info "Player params bound"

  # Plays a video given its youtube ID
  play: (videoId) ->
    @videoId = videoId
    @player.loadVideoById videoId: @videoId


#
# Create the module and add the components
#
angular.module('tubelistsApp.services', [])

  .constant 'YTPlayerStates',
    ENDED: 0
    PLAYING: 1
    PAUSED: 2
    BUFFERING: 3
    CUED: 5

  .service('playListService', PlayListService)

  .service('youTubePlayerService', [
    '$rootScope'
    '$log'
    '$window'
    'YTPlayerStates'
    YouTubePlayerService
  ])

  .run(['$log', 'youTubePlayerService'
    , ($log, youTubePlayerService) ->

        # Load Iframe Player API asynchronously
        tag = document.createElement 'script'
        tag.src = "https://www.youtube.com/iframe_api"
        firstScriptTag = document.getElementsByTagName('script')[0]
        firstScriptTag.parentNode.insertBefore tag, firstScriptTag

        $log.info "youTubePlayerService is ready"
  ])
