translationTypesetting = angular.module "translationTypesetting", [
  "ngResource"
  "ui.ace"
]


translationTypesetting.config ($locationProvider) ->
  $locationProvider.hashPrefix "!"

translationTypesetting.config ($routeProvider) ->
  $routeProvider.when "/",
    templateUrl: "/views/signin.html"
    controller: "SigninCtrl"

  $routeProvider.when "/translations",
    templateUrl: "/views/translations.html"
    controller: "TranslationsCtrl"

  $routeProvider.when "/translations/:translationId/html",
    templateUrl: "/views/editor-html.html"
    controller: "TranslationCtrl"

  $routeProvider.when "/translations/:translationId/text",
    templateUrl: "/views/editor-text.html"
    controller: "TranslationCtrl"

translationTypesetting.factory "Translation", ($resource) ->
  $resource "/translations/:_id"

translationTypesetting.controller "SigninCtrl", ($scope, $location) ->
  $scope.signin = ->
      $location.path "/translations"

translationTypesetting.filter "id", ->
  (id) ->
    id.slice 16, 24

translationTypesetting.filter "date", ->
  (date) ->
    date = new Date date
    date.toString "MM/dd/yyyy hh:mmtt"

translationTypesetting.controller "TranslationsCtrl", ($scope, Translation) ->
  $scope.translations = Translation.query()

translationTypesetting.controller "TranslationCtrl", ($scope, $http, $routeParams, Translation) ->
  Translation.get _id: $routeParams.translationId, (translation) ->
    $scope.translation = translation

  $scope.save = (done = false) ->
    $scope.translation.$save
      _id: $routeParams.translationId

translationTypesetting.directive "nav", ($location) ->
  restrict: "C"
  link: (scope, element, attrs) ->
    do check = ->
      element.css "display", if $location.url() == "/" then "none" else "block"

    scope.$on "$routeChangeSuccess", ->
      check()

translationTypesetting.directive "autoresize", ->
  restrict: "C"
  link: (scope, element) ->
    do fitToContent = ->
      adjustedHeight = element[0].scrollHeight
      adjustedHeight = Math.round(adjustedHeight / 16) * 16
      element[0].style.height = adjustedHeight + "px"

    element.on "keyup", ->
      fitToContent()

