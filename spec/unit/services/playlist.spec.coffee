'use strict'

describe "PlaylistService", ->

  beforeEach module "tubelistsApp.services.playlist"

  beforeEach ->
    inject (playlistService) =>
      @playlist = playlistService
      @playlist.position = 0
      @playlist.list = [
        'video1'
        'video2'
        'video3'
      ]

  describe '#current', ->

    it 'returns the current element', ->
      expect(@playlist.current()).toEqual 'video1'
      @playlist.position = 1
      expect(@playlist.current()).toEqual 'video2'

    it 'returns null if an invalid position is set', ->
      @playlist.position = -1
      expect(@playlist.current()).toBeUndefined()

  describe '#next', ->

    it 'moves forward the list', ->
      @playlist.next()
      expect(@playlist.position).toEqual 1

    it 'cycles the list if current is the last element', ->
      @playlist.position = @playlist.list.length - 1
      @playlist.next()
      expect(@playlist.position).toEqual 0

    it 'returns the next element', ->
      item = @playlist.next()
      expect(@playlist.list.indexOf(item)).toEqual 1

  describe '#previous', ->

    it 'moves backwards the list', ->
      @playlist.position = 1
      @playlist.previous()
      expect(@playlist.position).toEqual 0

    it 'cycles the list backwards if current is the first element', ->
      @playlist.previous()
      expect(@playlist.position).toEqual (@playlist.list.length - 1)

    it 'returns the previous element', ->
      @playlist.position = 1
      item = @playlist.previous()
      expect(@playlist.list.indexOf(item)).toEqual 0

  describe '#add', ->

    beforeEach ->
      @item = 'new_video'

    it 'adds an item to the list', ->
      oldLength = @playlist.list.length
      @playlist.add @item
      expect(@playlist.list.length).toEqual (oldLength + 1)

    it 'does not add a video already on the list', ->
      oldLength = @playlist.list.length
      @playlist.add 'video1'
      expect(@playlist.list.length).toEqual oldLength

  describe '#remove', ->

    beforeEach ->
      @item = @playlist.current()

    it 'removes an item from the array', ->
      @playlist.remove @item
      expect(@item).not.toEqual @playlist.current()

    it 'does not remove anything from the list if the item is not found', ->
      listLength = @playlist.list.length
      @playlist.remove "not_in_list"
      expect(@playlist.list.length).toEqual listLength

    it 'changes the position field if the removed item index was lower', ->
      @playlist.position = 2
      @playlist.remove @playlist.list[1]
      expect(@playlist.position).toEqual 1

    it 'changes the position field if the removed element was the last one', ->
      lastPosition = @playlist.list.length - 1
      @playlist.position = lastPosition
      @playlist.remove @playlist.list[lastPosition]
      expect(@playlist.position).toEqual 0


  describe '#setCurrent', ->

    it 'sets an item as current', ->
      @playlist.position = 0
      item = @playlist.list[1]
      @playlist.setCurrent item
      expect(@playlist.position).toEqual 1
      expect(@playlist.current()).toEqual item
