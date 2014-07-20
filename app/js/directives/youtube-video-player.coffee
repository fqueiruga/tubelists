'use strict'

### Directives ###

angular.module('tubelistsApp.directives.youtubeVideoPlayer', [])

  .directive 'youtubeVideoPlayer', ['$window', '$log', 'youTubePlayerService'
    , ($window, $log, youTubePlayerService) ->

      restrict: "AE"
      scope: {}
      template: '<div></div>'
      link: (scope, element, attrs) ->
        $log.info "Linking directive youtubeVideoPlayer"

        scope.params =
          playerId: attrs.id
          height: attrs.height
          width: attrs.width

        youTubePlayerService.bindPlayer scope.params
  ]
