'use strict'

describe "PlayList Service", ->

  beforeEach module "tubelistsApp.services.playList"

  beforeEach(inject (playListService) ->
    @playList = playListService
    @playList.upcoming = ["Numa Numa"]
    @playList.history = ["Chocolate Rain"]
    @playList.current = "Rick roll"
  )

  describe "moving through the list", ->

    it "should move forward the play list and return the current item", ->
      item = @playList.next()
      expect(item).toEqual "Numa Numa"
      expect(@playList.upcoming.length).toBe 0
      expect(@playList.history.length).toBe 2
      expect(@playList.current).toBe item

    it "shouldn't move forward the list if upcoming list is empty", ->
      @playList.upcoming = []
      @playList.next()
      expect(@playList.current).toBeDefined()

    it "should move the list backwards and return the current item", ->
      item = @playList.previous()
      expect(@playList.upcoming.length).toBe 2
      expect(@playList.history.length).toBe 0
      expect(@playList.current).toBe item

    it "shouldn't move the list backwards if history list is tempty", ->
      @playList.history = []
      @playList.previous()
      expect(@playList.current).toBeDefined()


  describe "adding items to the list", ->
    beforeEach ->
      @item = "Top 10 fails"
      @item2 = "People are awesome 2012"

    it "should set the item as current if it's not set", ->
      @playList.current = null
      @playList.add @item
      expect(@playList.current).toEqual @item

    it "should add a new item to the upcoming list", ->
      @playList.add @item
      expect(@playList.upcoming.length).toBe 2

    it "should add a new item to the front of the upcoming list", ->
      @playList.add @item, front: true
      expect(@playList.upcoming[0]).toEqual @item

    it "should add a item to the history list", ->
      @playList.add @item, toHistory: true
      @playList.add @item2, toHistory: true
      expect(@playList.history.pop()).toEqual @item2

    it "should remove an item from the list before adding it", ->
      @playList.add @playList.history[0]
      expect(@playList.upcoming.length).toBe 2
      expect(@playList.history.length).toBe 0


  describe "removing items from the list",  ->
    beforeEach -> @item = "Top 10 fails"

    it "should remove an item from the upcoming list", ->
      @playList.upcoming.push @item
      @playList.remove @item
      expect(@playList.upcoming.length).toBe 1

    it "should remove an item from the history list", ->
      @playList.history.push @item
      @playList.remove @item
      expect(@playList.history.length).toBe 1

    it "shouldn't remove the current item", ->
      @playList.remove @playList.current
      expect(@playList.current).not.toBeNull()


  it "should export the playlist merging both arrays", ->
    @playList.history = ["Chocolate Rain", "Rick Roll"]

    list = @playList.playList()
    expect(list).toEqual(["Chocolate Rain", "Rick Roll", "Numa Numa"])
