'use strict'

#
# Service that provides the playlists functionality
#
# All playlist manipulations are done through functions
#
class PlayListService

  constructor: ->
    @position = 0

    @list = [
        videoId: "OpQFFLBMEPI"
        title: "P!nk - Just Give Me A Reason ft. Nate Ruess"
      ,
        videoId: "KV2ssT8lzj8"
        title: "Eminem - No Love (Explicit Version) ft. Lil Wayne"
      ,
        videoId: "j5-yKhDd64s"
        title: "Music video by Eminem performing Not Afraid"
      ,
        videoId: "W-w3WfgpcGg"
        title: "Bruno Mars - It Will Rain [OFFICIAL VIDEO]"
      ,
        videoId: "0G3_kG5FFfQ"
        title: "Avril Lavigne - When You're Gone"
    ]

    # @playList = []

  # Returns the current element
  current: ->
    return @list[@position]

  # Moves the list forward and returns the next element
  next: ->
    @position++
    @position = 0 if @position >= @list.length
    @current()

  # Moves the list backwards and returns the previous element
  previous: ->
    @position--
    @position = (@list.length - 1) if @position < 0
    @current()

  # # Adds an item to the play list
  # # if called with (item, {front: true}) it will be the first item of upcoming
  # add: (item, options) ->
  #   if @current?
  #     @remove item
  #     options = options || {}
  #     if options.front
  #       @upcoming.unshift item
  #     else if options.toHistory
  #       @history.push item
  #     else
  #       @upcoming.push item
  #   else
  #     @current = item

  # # Removes an item from the play list
  # remove: (item) ->
  #   if item in @upcoming
  #     @upcoming.splice @upcoming.indexOf(item), 1
  #   if item in @history
  #     @history.splice @history.indexOf(item), 1



#
# Create the module and add the components
#
angular.module('tubelistsApp.services.playList', [])

  .service('playListService', PlayListService)


