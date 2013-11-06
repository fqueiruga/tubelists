'use strict'

#
# Service that provides the playlists functionality
#
# All playlist manipulations are done through functions
#
class PlayListService

  constructor: ->
    @upcoming = [
        videoId: "OpQFFLBMEPI"
        title: "P!nk - Just Give Me A Reason ft. Nate Ruess"
      ,
        videoId: "KV2ssT8lzj8"
        title: "Eminem - No Love (Explicit Version) ft. Lil Wayne"
    ]
    @history = [
        videoId: "j5-yKhDd64s"
        title: "Music video by Eminem performing Not Afraid"
      ,
        videoId: "W-w3WfgpcGg"
        title: "Bruno Mars - It Will Rain [OFFICIAL VIDEO]"
    ]

    @current =
      videoId: "0G3_kG5FFfQ"
      title: "Avril Lavigne - When You're Gone"
    # @upcoming = []
    # @history = []
    # @current = null

  # Moves first element to upcoming to the end of history
  next: ->
    nextItem = @upcoming.shift()
    if nextItem?
      @history.push @current if @current?
      @current = nextItem

  # Moves the last element of history to the beggining of upcoming
  previous: ->
    previousItem = @history.pop()
    if previousItem?
      @upcoming.unshift @current if @current?
      @current = previousItem


  # Adds an item to the play list
  # if called with (item, {front: true}) it will be the first item of upcoming
  add: (item, options) ->
    if @current?
      @remove item
      options = options || {}
      if options.front
        @upcoming.unshift item
      else if options.toHistory
        @history.push item
      else
        @upcoming.push item
    else
      @current = item

  # Removes an item from the play list
  remove: (item) ->
    if item in @upcoming
      @upcoming.splice @upcoming.indexOf(item), 1
    if item in @history
      @history.splice @history.indexOf(item), 1

  # Returns an array of the full play list
  playList: ->
    @history.concat @upcoming


#
# Create the module and add the components
#
angular.module('tubelistsApp.services.playList', [])

  .service('playListService', PlayListService)


