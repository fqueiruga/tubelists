'use strict'

describe "PlayList Service", ->

  beforeEach module "tubelistsApp.services.playList"

  beforeEach ->
    inject (playListService) =>
      @playlist = playListService
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

    it 'should move forward the list', ->
      @playlist.next()
      expect(@playlist.position).toEqual 1

    it 'should cycle the list if current is the last element', ->
      @playlist.position = @playlist.list.length - 1
      @playlist.next()
      expect(@playlist.position).toEqual 0

    it 'should return the next element', ->
      item = @playlist.next()
      expect(@playlist.list.indexOf(item)).toEqual 1

  describe '#previous', ->

    it 'should move backwards the list', ->
      @playlist.position = 1
      @playlist.previous()
      expect(@playlist.position).toEqual 0

    it 'should cycle the list backwards if current is the first element', ->
      @playlist.previous()
      expect(@playlist.position).toEqual (@playlist.list.length - 1)

    it 'should return the previous element', ->
      @playlist.position = 1
      item = @playlist.previous()
      expect(@playlist.list.indexOf(item)).toEqual 0

  describe '#add', ->

    beforeEach ->
      @item = 'new_video'

    it 'should add an item to the list', ->
      oldLength = @playlist.list.length
      @playlist.add @item
      expect(@playlist.list.length).toEqual (oldLength + 1)

  describe '#remove', ->

    beforeEach ->
      @item = @playlist.current()

    it 'should remove an item from the array', ->
      @playlist.remove @item
      expect(@item).not.toEqual @playlist.current()

    it 'does not remove anything from the list if the item is not found', ->
      listLength = @playlist.list.length
      @playlist.remove "not_in_list"
      expect(@playlist.list.length).toEqual listLength
