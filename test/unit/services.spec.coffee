'use strict'

# jasmine specs for services go here

describe "Services", ->

  describe "PlayList Service", ->

    beforeEach(module "tubelistsApp.services")

    beforeEach(inject (PlayListService) ->
      @playList = PlayListService
      @playList.upcoming = ["Numa Numa"]
      @playList.played = []
    )

    it "should add a new item to the upcoming list", ->
      expect(@playList.upcoming.length).toBe 1
      @playList.add "Chocolate Rain"
      expect(@playList.upcoming.length).toBe 2


    it "should change to the next item", ->
      next = @playList.next()
      expect(next).toEqual "Numa Numa"
      expect(@playList.upcoming.length).toBe 0
      expect(@playList.played.length).toBe 1

      expect(@playList.next()).not.toBeDefined()


    it "should export the playlist merging both arrays", ->
      @playList.played = ["Chocolate Rain", "Rick Roll"]

      list = @playList.playList()
      expect(list).toEqual(["Chocolate Rain", "Rick Roll", "Numa Numa"])

