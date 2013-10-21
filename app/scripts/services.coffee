'use strict'

### Services ###

angular.module('tubelistsApp.services', [])

.service 'PlayListService',

  class PlayList
    constructor: -> @upcoming = @played = []

    next: ->
      item = @upcoming.shift()
      @played.push item if item?
      item

    add: (item) ->
      @upcoming.push item

    playList: ->
      @played.concat @upcoming


