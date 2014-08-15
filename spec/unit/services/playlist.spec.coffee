'use strict'

describe "PlayList Service", ->

  beforeEach module "tubelistsApp.services.playList"

  beforeEach ->
    inject (playListService) =>
      @playlist = playListService
      # @playlist.upcoming = ["Numa Numa"]
      # @playlist.history = ["Chocolate Rain"]
      # @playlist.current = "Rick roll"
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



    # it "should move forward the play list and return the current item", ->
    #   item = @playlist.next()
    #   expect(item).toEqual "Numa Numa"
    #   expect(@playlist.upcoming.length).toBe 0
    #   expect(@playlist.history.length).toBe 2
    #   expect(@playlist.current).toBe item

  #   it "shouldn't move forward the list if upcoming list is empty", ->
  #     @playlist.upcoming = []
  #     @playlist.next()
  #     expect(@playlist.current).toBeDefined()

  #   it "should move the list backwards and return the current item", ->
  #     item = @playlist.previous()
  #     expect(@playlist.upcoming.length).toBe 2
  #     expect(@playlist.history.length).toBe 0
  #     expect(@playlist.current).toBe item

  #   it "shouldn't move the list backwards if history list is tempty", ->
  #     @playlist.history = []
  #     @playlist.previous()
  #     expect(@playlist.current).toBeDefined()


  # describe "adding items to the list", ->
  #   beforeEach ->
  #     @item = "Top 10 fails"
  #     @item2 = "People are awesome 2012"

  #   it "should set the item as current if it's not set", ->
  #     @playlist.current = null
  #     @playlist.add @item
  #     expect(@playlist.current).toEqual @item

  #   it "should add a new item to the upcoming list", ->
  #     @playlist.add @item
  #     expect(@playlist.upcoming.length).toBe 2

  #   it "should add a new item to the front of the upcoming list", ->
  #     @playlist.add @item, front: true
  #     expect(@playlist.upcoming[0]).toEqual @item

  #   it "should add a item to the history list", ->
  #     @playlist.add @item, toHistory: true
  #     @playlist.add @item2, toHistory: true
  #     expect(@playlist.history.pop()).toEqual @item2

  #   it "should remove an item from the list before adding it", ->
  #     @playlist.add @playlist.history[0]
  #     expect(@playlist.upcoming.length).toBe 2
  #     expect(@playlist.history.length).toBe 0


  # describe "removing items from the list",  ->
  #   beforeEach -> @item = "Top 10 fails"

  #   it "should remove an item from the upcoming list", ->
  #     @playlist.upcoming.push @item
  #     @playlist.remove @item
  #     expect(@playlist.upcoming.length).toBe 1

  #   it "should remove an item from the history list", ->
  #     @playlist.history.push @item
  #     @playlist.remove @item
  #     expect(@playlist.history.length).toBe 1

  #   it "shouldn't remove the current item", ->
  #     @playlist.remove @playlist.current
  #     expect(@playlist.current).not.toBeNull()


  # it "should export the playlist merging both arrays", ->
  #   @playlist.history = ["Chocolate Rain", "Rick Roll"]
  #   expect(@playlist.list).toEqual(["Chocolate Rain", "Rick Roll", "Numa Numa"])
