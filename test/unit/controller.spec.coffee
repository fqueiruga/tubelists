'use strict'

# jasmine specs for controllers go here

# TODO figure out how to test Controllers that use modules
describe "controllers", ->

  beforeEach(module "tubelistsApp.controllers")

  describe "SearchCtrl", ->

    beforeEach(inject ($rootScope, $controller) ->
      @scope = $rootScope.$new()
      @ctrl = $controller 'SearchCtrl', {
        $scope: @scope
      }
    )

    it "should build the full name", ->
      @scope.firstName = "Felix"
      @scope.secondName = "Queiruga"
      expect(@scope.fullName()).toEqual("Felix Queiruga")



