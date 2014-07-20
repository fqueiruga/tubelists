'use strict'

#
# Create the module and add the components
#
angular.module('tubelistsApp.services.youTubeSearch', [])

  .factory('youTubeSearchService', ['$log', '$http', '$q'
    , ($log, $http, $q) ->

      apiKey = 'AIzaSyDJSX08GtPqiQwddpvJ65diuhu0S8upK0U'
      url = 'https://www.googleapis.com/youtube/v3/search'

      return service =
        search: (query) ->
          deferred = $q.defer()

          $http.get(url, params: {
              key: apiKey
              type: 'video'
              maxResults: '6'
              part: 'id,snippet'
              fields: 'items/id,items/snippet/title'
              q: query
          })

          .success (data) ->
            deferred.resolve data.items.map (item) ->
                videoId: item.id.videoId
                title: item.snippet.title


          .error (data) ->
            deferred.reject data

          return deferred.promise
  ])

  .config(['$httpProvider', ($httpProvider) ->
    # Disable this header or the youtube API won't work
    delete $httpProvider.defaults.headers.common['X-Requested-With']
  ])
