translationTypesetting = angular.module "translationTypesetting", []


translationTypesetting.config ($locationProvider) ->
  $locationProvider.hashPrefix "!"

translationTypesetting.config ($routeProvider) ->
  $routeProvider.when "/",
    templateUrl: "/views/signin.html"
    controller: "SigninCtrl"

  $routeProvider.when "/translations",
    templateUrl: "/views/translations.html"

translationTypesetting.controller "SigninCtrl", ($scope, $location) ->
  $scope.signin = ->
    $location.path "/translations"

translationTypesetting.directive "nav", ($location) ->
  restrict: "C"
  link: (scope, element, attrs) ->
    do check = ->
      element.css "display", if $location.url() == "/" then "none" else "block"

    scope.$on "$routeChangeSuccess", ->
      check()
