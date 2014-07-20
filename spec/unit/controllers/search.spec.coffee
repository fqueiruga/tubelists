'use strict'

describe "Search Controller", ->

  beforeEach module 'tubelistsApp.controllers.search'

  beforeEach ->
    @ytSearch = jasmine.createSpyObj 'ytSearch', ['search']
    @playList = jasmine.createSpyObj 'playList', ['add']

    angular.mock.module ($provide) =>
      $provide.value 'youTubeSearchService', @ytSearch
      $provide.value 'playListService', @playList
      null

  beforeEach ->
    inject ($injector, $controller) =>
      @scope = $injector.get('$rootScope').$new()
      @ctrl = $controller 'SearchCtrl',
        $scope: @scope

  describe "youtube search", ->

    beforeEach ->
      @ytSearch.search.and.returnValue "result"
      @scope.query = "search filter"

    it "should invoke youtube search service", ->
      @scope.search()
      expect(@ytSearch.search).toHaveBeenCalledWith "search filter"

    it "check the value returned", ->
      @scope.search()
      expect(@scope.results).toEqual "result"

