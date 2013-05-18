translationTypesetting = angular.module "translationTypesetting", [
  "ngResource"
  "ngCookies"
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

  $routeProvider.when "/translations/:translationId",
    templateUrl: "/views/translation.html"
    controller: "TranslationCtrl"

translationTypesetting.config ($httpProvider) ->
  $httpProvider.responseInterceptors.push ($location, $cookieStore) ->
    (promise) ->
      success = (response) ->
        response

      error = (response) ->
        if response.status == 401
          $cookieStore.remove "token"
          $location.path "/"
        response

      promise.then success, error

translationTypesetting.factory "Translation", ($resource) ->
  $resource "/translations/:_id"

translationTypesetting.factory "user", ($resource, $http, $cookieStore) ->
  setToken = (token) ->
    $http.defaults.headers.common.Authorization = "Token #{token}"
    
  if $cookieStore.get "username" and $cookieStore.get "token"
    promise = $http.get("/sessions/#{$cookieStore.get "token"}")
    promise.success (data, status) ->
      setToken $cookieStore.get "token" if status is 200
      $cookieStore.remove "token" if status is 404

  setToken: setToken

translationTypesetting.controller "SigninCtrl", ($scope, $http, $location, $cookieStore, user) ->
  $scope.user = {}

  $scope.signin = ->
    promise = $http.post("/sessions", $scope.user)
    promise.success (auth, status) ->
      $cookieStore.put "username", $scope.user.username
      $cookieStore.put "token", auth.token if auth.token

      user.setToken auth.token

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
  $scope.translations = Translation.query _id: $routeParams.translationId

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

