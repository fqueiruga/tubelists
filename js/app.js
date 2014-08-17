'use strict';
angular.module('tubelistsApp', [
  'ui.bootstrap',
  'tubelistsApp.controllers',
  'tubelistsApp.services',
  'tubelistsApp.directives'
]);
'use strict';
angular.module('tubelistsApp.controllers', [
  'tubelistsApp.controllers.search',
  'tubelistsApp.controllers.player'
]);
'use strict';
/* Youtube Player controller */
angular.module('tubelistsApp.controllers.player', []).controller('PlayerCtrl', [
  '$scope',
  'youTubePlayerService',
  'playlistService',
  function ($scope, youTubePlayerService, playlistService) {
    $scope.playlist = playlistService;
    $scope.isPlaying = false;
    $scope.loadVideo = function (options) {
      options = options || {};
      if ($scope.isPlaying || options.autoplay) {
        return youTubePlayerService.loadVideo($scope.playlist.current().videoId);
      } else {
        return youTubePlayerService.cueVideo($scope.playlist.current().videoId);
      }
    };
    $scope.remove = function (video) {
      var wasCurrent;
      if (this.playlist.list.length === 1) {
        return;
      }
      wasCurrent = $scope.isCurrent(video);
      $scope.playlist.remove(video);
      if (wasCurrent) {
        return $scope.loadVideo();
      }
    };
    $scope.isCurrent = function (video) {
      return $scope.playlist.current() === video;
    };
    $scope.play = function (video) {
      $scope.playlist.setCurrent(video);
      return $scope.loadVideo();
    };
    $scope.$on('youtube:player:ready', function () {
      if ($scope.playlist.current() != null) {
        return $scope.loadVideo();
      }
    });
    $scope.$on('youtube:player:ended', function () {
      var next;
      next = playlistService.next();
      if (next != null) {
        return $scope.loadVideo({ autoplay: true });
      }
    });
    $scope.$on('youtube:player:playing', function () {
      return $scope.isPlaying = true;
    });
    $scope.$on('youtube:player:paused', function () {
      return $scope.isPlaying = false;
    });
    return $scope.playlist.list = [
      {
        videoId: '3MteSlpxCpo',
        title: '[Official Video] Daft Punk - Pentatonix',
        thumbnail: 'https://i.ytimg.com/vi/3MteSlpxCpo/mqdefault.jpg'
      },
      {
        videoId: 'ktvTqknDobU',
        title: 'Imagine Dragons - Radioactive',
        thumbnail: 'https://i.ytimg.com/vi/ktvTqknDobU/mqdefault.jpg'
      },
      {
        videoId: '6Ejga4kJUts',
        title: 'The Cranberries - Zombie',
        thumbnail: 'https://i.ytimg.com/vi/6Ejga4kJUts/mqdefault.jpg'
      }
    ];
  }
]);
'use strict';
/* Video Search controller */
angular.module('tubelistsApp.controllers.search', []).controller('SearchCtrl', [
  '$log',
  '$scope',
  'youTubeSearchService',
  'playlistService',
  function ($log, $scope, youTubeSearchService, playlistService) {
    $scope.search = function () {
      var promise;
      promise = youTubeSearchService.search($scope.query);
      return promise.then(function (items) {
        return $scope.results = items;
      });
    };
    return $scope.add = function (video) {
      return playlistService.add(video);
    };
  }
]);
'use strict';
angular.module('tubelistsApp.directives', ['tubelistsApp.directives.youtubeVideoPlayer']);
'use strict';
/* Directives */
angular.module('tubelistsApp.directives.youtubeVideoPlayer', []).directive('youtubeVideoPlayer', [
  '$window',
  '$log',
  'youTubePlayerService',
  function ($window, $log, youTubePlayerService) {
    return {
      restrict: 'AE',
      template: '<div></div>',
      scope: {
        videoId: '=',
        height: '=',
        width: '='
      },
      link: function (scope, element, attrs) {
        var unbindInitWatcher, youtube, _ref, _ref1;
        $log.info('Linking directive youtubeVideoPlayer');
        youtube = youTubePlayerService;
        youtube.playerId = attrs.id;
        youtube.height = (_ref = scope.height) != null ? _ref : 360;
        youtube.width = (_ref1 = scope.width) != null ? _ref1 : 640;
        return unbindInitWatcher = scope.$watch(function () {
          return youtube.apiReady;
        }, function (apiReady) {
          if (apiReady && scope.videoId) {
            unbindInitWatcher();
            youtube.videoId = scope.videoId;
            return youtube.createPlayer();
          }
        });
      }
    };
  }
]);
'use strict';
angular.module('tubelistsApp.services', [
  'tubelistsApp.services.playlist',
  'tubelistsApp.services.youTubePlayer',
  'tubelistsApp.services.youTubeSearch'
]);
'use strict';
var PlaylistService;
PlaylistService = function () {
  function PlaylistService() {
    this.position = 0;
    this.playlist = [];
  }
  PlaylistService.prototype.current = function () {
    return this.list[this.position];
  };
  PlaylistService.prototype.next = function () {
    this.position++;
    if (this.position >= this.list.length) {
      this.position = 0;
    }
    return this.current();
  };
  PlaylistService.prototype.previous = function () {
    this.position--;
    if (this.position < 0) {
      this.position = this.list.length - 1;
    }
    return this.current();
  };
  PlaylistService.prototype.add = function (item) {
    if (this.list.indexOf(item) !== -1) {
      return void 0;
    }
    return this.list.push(item);
  };
  PlaylistService.prototype.remove = function (item) {
    var index;
    index = this.list.indexOf(item);
    if (index === -1) {
      return [];
    }
    if (index < this.position) {
      this.position--;
    } else if (index === this.position && index === this.list.length - 1) {
      this.position = 0;
    }
    return this.list.splice(index, 1);
  };
  PlaylistService.prototype.setCurrent = function (item) {
    var index;
    index = this.list.indexOf(item);
    if (index === -1) {
      return [];
    }
    return this.position = index;
  };
  return PlaylistService;
}();
angular.module('tubelistsApp.services.playlist', []).service('playlistService', PlaylistService);
'use strict';
var YouTubePlayerService, __bind = function (fn, me) {
    return function () {
      return fn.apply(me, arguments);
    };
  };
YouTubePlayerService = function () {
  function YouTubePlayerService($rootScope, $log, $window, YTPlayerStates) {
    this.$rootScope = $rootScope;
    this.$log = $log;
    this.YTPlayerStates = YTPlayerStates;
    this.onPlayerStateChange = __bind(this.onPlayerStateChange, this);
    this.onPlayerReady = __bind(this.onPlayerReady, this);
    this.player = null;
    this.playerId = null;
    this.videoId = null;
    this.apiReady = false;
    $window.onYouTubeIframeAPIReady = function (_this) {
      return function () {
        _this.$log.info('Youtube API ready');
        return _this.$rootScope.$apply(function () {
          return _this.apiReady = true;
        });
      };
    }(this);
  }
  YouTubePlayerService.prototype.createPlayer = function () {
    if (this.apiReady && this.playerId != null) {
      this.player = new YT.Player(this.playerId, {
        height: this.height,
        width: this.width,
        videoId: this.videoId,
        events: {
          'onReady': this.onPlayerReady,
          'onStateChange': this.onPlayerStateChange
        }
      });
      return this.$log.info('Created Youtube Player');
    } else {
      return this.$log.info('Could not create Youtube player');
    }
  };
  YouTubePlayerService.prototype.onPlayerReady = function () {
    this.$log.info('Youtube player ready');
    return this.$rootScope.$apply(function (_this) {
      return function () {
        return _this.$rootScope.$broadcast('youtube:player:ready');
      };
    }(this));
  };
  YouTubePlayerService.prototype.onPlayerStateChange = function (event) {
    var newEvent;
    switch (event.data) {
    case this.YTPlayerStates.ENDED:
      newEvent = 'youtube:player:ended';
      break;
    case this.YTPlayerStates.PLAYING:
      newEvent = 'youtube:player:playing';
      break;
    case this.YTPlayerStates.PAUSED:
      newEvent = 'youtube:player:paused';
      break;
    default:
      newEvent = 'youtube:player:unknownState';
    }
    return this.$rootScope.$apply(function (_this) {
      return function () {
        return _this.$rootScope.$broadcast(newEvent);
      };
    }(this));
  };
  YouTubePlayerService.prototype.loadVideo = function (videoId) {
    this.videoId = videoId;
    return this.player.loadVideoById({ videoId: this.videoId });
  };
  YouTubePlayerService.prototype.cueVideo = function (videoId) {
    this.videoId = videoId;
    return this.player.cueVideoById({ videoId: this.videoId });
  };
  return YouTubePlayerService;
}();
angular.module('tubelistsApp.services.youTubePlayer', []).constant('YTPlayerStates', {
  ENDED: 0,
  PLAYING: 1,
  PAUSED: 2,
  BUFFERING: 3,
  CUED: 5
}).service('youTubePlayerService', [
  '$rootScope',
  '$log',
  '$window',
  'YTPlayerStates',
  YouTubePlayerService
]).run([
  '$log',
  'youTubePlayerService',
  function ($log, youTubePlayerService) {
    var firstScriptTag, tag;
    tag = document.createElement('script');
    tag.src = 'https://www.youtube.com/iframe_api';
    firstScriptTag = document.getElementsByTagName('script')[0];
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
    return $log.info('youTubePlayerService is ready');
  }
]);
'use strict';
angular.module('tubelistsApp.services.youTubeSearch', []).factory('youTubeSearchService', [
  '$log',
  '$http',
  '$q',
  function ($log, $http, $q) {
    var apiKey, service, url;
    apiKey = 'AIzaSyDJSX08GtPqiQwddpvJ65diuhu0S8upK0U';
    url = 'https://www.googleapis.com/youtube/v3/search';
    return service = {
      search: function (query) {
        var deferred;
        deferred = $q.defer();
        $http.get(url, {
          params: {
            key: apiKey,
            type: 'video',
            maxResults: '6',
            part: 'id,snippet',
            fields: 'items/id,items/snippet/title,items/snippet/thumbnails',
            q: query
          }
        }).success(function (data) {
          return deferred.resolve(data.items.map(function (item) {
            return {
              videoId: item.id.videoId,
              title: item.snippet.title,
              thumbnail: item.snippet.thumbnails.medium.url
            };
          }));
        }).error(function (data) {
          return deferred.reject(data);
        });
        return deferred.promise;
      }
    };
  }
]).config([
  '$httpProvider',
  function ($httpProvider) {
    return delete $httpProvider.defaults.headers.common['X-Requested-With'];
  }
]);
angular.module("tubelistsApp").run(["$templateCache", function($templateCache) {$templateCache.put("/templates/google-analytics.tpl.html","<script>\n\n  (function(i,s,o,g,r,a,m){i[\'GoogleAnalyticsObject\']=r;i[r]=i[r]||function(){\n  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),\n  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)\n  })(window,document,\'script\',\'//www.google-analytics.com/analytics.js\',\'ga\');\n\n  ga(\'create\', \'UA-53907461-1\', \'auto\');\n  ga(\'send\', \'pageview\');\n\n</script>\n");
$templateCache.put("/templates/player.tpl.html","<div data-ng-controller=\"PlayerCtrl\">\n  <div class=\"videos-container\">\n\n    <article class=\"player-container\">\n      <div class=\"player-wrapper\">\n        <youtube-video-player\n          id=\"youtube-player\" height=\"360\" width=\"640\"\n          video-id=\"playlist.current().videoId\"></youtube-video-player>\n      </div>\n\n      <h2 class=\"current-video\">{{playlist.current().title}}</h2>\n    </article>\n\n    <div data-ng-include src=\"\'/templates/playlist.tpl.html\'\"></div>\n\n  </div>\n</div>\n");
$templateCache.put("/templates/playlist.tpl.html","<aside class=\"playlist-container\">\n  <ol class=\"playlist-list\">\n\n    <li class=\"playlist-item\" data-ng-class=\"{\'current\': isCurrent(video)}\"\n          data-ng-repeat=\"video in playlist.list\">\n\n      <p class=\"playlist-item-remove\" data-ng-click=\"remove(video)\">\n        <i class=\"fa fa-times-circle-o\"></i>\n      </p>\n\n      <a href=\"\" data-ng-click=\"play(video)\" class=\"playlist-item-link\">\n\n        <img class=\"l-thumbnail\"\n              data-ng-src=\"{{video.thumbnail}}\"\n              alt=\"{{video.title}}\">\n        <p class=\"search-results-item-title\">{{video.title}}</p>\n\n      </a>\n\n    </li>\n\n  </ol>\n</aside>\n");
$templateCache.put("/templates/search.tpl.html","<div data-ng-controller=\"SearchCtrl\">\n\n  <h1 class=\"l-site-title\">Tubelists</h1>\n\n  <div>\n    <input type=\"text\"\n      class=\"l-input search-box\"\n      data-ng-model=\"query\" placeholder=\"Search video...\">\n\n    <button class=\"l-button\" data-ng-click=\"search()\">\n      Search!\n    </button>\n  </div>\n\n  <ol class=\"search-results\">\n    <li class=\"search-results-item\" data-ng-repeat=\"item in results\">\n      <a href=\"\" class=\"search-results-item-link\" target=\"blank\"\n        data-ng-click=\"add(item)\">\n        <img class=\"search-results-item-img\"\n          data-ng-src=\"{{item.thumbnail}}\"\n          alt=\"{{item.title}}\">\n\n        <p class=\"search-results-item-title\">{{item.title}}</p>\n      </a>\n    </li>\n  </ol>\n\n</div>\n");}]);