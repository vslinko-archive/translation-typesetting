translationTypesetting = angular.module "translationTypesetting", []


translationTypesetting.config ($locationProvider) ->
  $locationProvider.hashPrefix "!"

translationTypesetting.config ($routeProvider) ->
  $routeProvider.when "/",
    templateUrl: "/views/signin.html"
