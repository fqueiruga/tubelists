'use strict'

### Directives ###

angular.module('tubelistsApp.directives.youtubeVideoPlayer', [])

  .directive 'youtubeVideoPlayer', ['$window', '$log', 'youTubePlayerService'
    , ($window, $log, youTubePlayerService) ->

      restrict: "AE"
      template: '<div></div>'
      scope: {
        videoId: '='
        height: '='
        width: '='
      }

      link: (scope, element, attrs) ->
        $log.info "Linking directive youtubeVideoPlayer"

        youtube = youTubePlayerService
        youtube.playerId = attrs.id
        youtube.height = scope.height ? 360
        youtube.width = scope.width ? 640

        unbindInitWatcher = scope.$watch ->
          youtube.apiReady
        , (apiReady) ->
          if apiReady and  scope.videoId
            unbindInitWatcher()
            youtube.videoId = scope.videoId
            youtube.createPlayer()

  ]
