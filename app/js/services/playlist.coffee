'use strict'

#
# Service that provides the playlists functionality
#
# All playlist manipulations are done through functions
#
class PlaylistService

  constructor: ->
    @position = 0
    @playlist = []

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
    if index < @position
      @position--
    else if (index == @position) and (index == (@list.length - 1))
      @position = 0
    @list.splice index, 1

  # Sets the item as current
  setCurrent: (item) ->
    index = @list.indexOf item
    return [] if index == -1
    @position = index



#
# Create the module and add the components
#
angular.module('tubelistsApp.services.playlist', [])

  .service('playlistService', PlaylistService)


