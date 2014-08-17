'use strict'

#
# Service that provides the playlists functionality
#
# All playlist manipulations are done through functions
#
class PlaylistService

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

    # @playlist = []

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

  # Adds an item to the list
  add: (item) ->
    return undefined if @list.indexOf(item) != -1
    @list.push item

  # Removes an item from the list
  remove: (item) ->
    index = @list.indexOf item
    return [] if index == -1
    @list.splice index, 1
    @position-- if index < @position


#
# Create the module and add the components
#
angular.module('tubelistsApp.services.playlist', [])

  .service('playlistService', PlaylistService)


