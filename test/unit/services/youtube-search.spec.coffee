'use strict'

#
# Service that handles de YouTube player
#
describe "YouTube Search Service", ->

  beforeEach module "tubelistsApp.services.youTubeSearch"

  beforeEach ->
  	inject ($injector) =>
    	@youtube = $injector.get 'youTubeSearchService'
    	@scope = $injector.get('$rootScope').$new()
    	@httpBackend = $injector.get '$httpBackend'

  beforeEach ->
    @urlRegex = /\/\/www\.googleapis\.com\/youtube\/v3\/search/
    @searchData =
		  items: [
			    id:
			      videoId: "vid1"
			    snippet:
			      title: "video 1"
		    ,
			    id:
		    	  videoId: "vid2"
			    snippet:
			      title: "video 2"
		  ]

  it "should resolve an array of videos", ->
  	@httpBackend.expectGET(@urlRegex).respond @searchData
  	promise = @youtube.search "filter"
  	result = {}
  	promise.then (data) ->
  		result = data
  	@httpBackend.flush()
  	expect(result).toBeDefined()

  it "should transform the array of videos", ->
  	@httpBackend.expectGET(@urlRegex).respond @searchData
  	promise = @youtube.search "filter"
  	result = {}
  	promise.then (data) ->
  		result = data
  	@httpBackend.flush()
  	expect(result).toContain
  				videoId: "vid1"
  				title: "video 1"

  it "should reject the promise and respond with error", ->
  	@httpBackend.expectGET(@urlRegex).respond 400, "error"
  	promise = @youtube.search "filter"
  	result = {}
  	promise.then (data) ->
  		result = data
  	, (error) ->
  		result = error
  	@httpBackend.flush()
  	expect(result).toBe "error"


