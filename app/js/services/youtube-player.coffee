'use strict'

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
      @$log.info "Youtube API ready"
      @$rootScope.$apply =>
        @apiReady = true

  # Creates an instance of the youtube video player and binds the callbacks
  createPlayer: ->
    if @apiReady and @playerId?
      @player = new YT.Player @playerId,
          height: @height
          width: @width
          videoId: @videoId
          events:
            'onReady': @onPlayerReady
            'onStateChange': @onPlayerStateChange
      @$log.info "Created Youtube Player"
    else
      @$log.info "Could not create Youtube player"

  # Callback that broadcasts the event of youtube player ready
  onPlayerReady: =>
    @$log.info "Youtube player ready"
    @$rootScope.$apply =>
      @$rootScope.$broadcast 'youtube:player:ready'

  onPlayerStateChange: (event) =>
    switch event.data
      when @YTPlayerStates.ENDED then newEvent = "youtube:player:ended"
      when @YTPlayerStates.PLAYING then newEvent = "youtube:player:playing"
      when @YTPlayerStates.PAUSED then newEvent = "youtube:player:paused"
      else newEvent = "youtube:player:unknownState"
    @$rootScope.$apply =>
      @$rootScope.$broadcast newEvent

  # Loads and plays a video given its youtube ID
  loadVideo: (videoId) ->
    @videoId = videoId
    @player.loadVideoById videoId: @videoId

  # Loads a video but does not play it, given its youtube ID
  cueVideo: (videoId) ->
    @videoId = videoId
    @player.cueVideoById videoId: @videoId


#
# Create the module and add the components
#
angular.module('tubelistsApp.services.youTubePlayer', [])

  .constant 'YTPlayerStates',
    ENDED: 0
    PLAYING: 1
    PAUSED: 2
    BUFFERING: 3
    CUED: 5

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
