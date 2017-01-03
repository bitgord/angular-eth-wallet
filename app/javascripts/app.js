var app = angular.module("mySimpleWalletDapp", ['ngRoute']);

app.controller("MainController", function($scope) {
  $scope.myVar ='Main';
});

app.controller("ShoweventsController", function($scope) {
  $scope.myVar ='Showevents';
});

app.controller("SendfundsController", function($scope) {
  $scope.myVar ='Sendfunds';
});

app.config(function($routeProvider) {
  $routeProvider.when('/', {
    templateUrl: 'views/main.html',
    controller: 'MainController'
  }).when('/events', {
    templateUrl: 'views/events.html',
    controller: 'ShoweventsController'
  }).when('/sendfunds', {
    templateUrl: 'views/sendfunds.html',
    controller: 'SendfundsController'
  }).otherwise({redirectTo: '/'});
});