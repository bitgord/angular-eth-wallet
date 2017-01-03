var app = angular.module("mySimpleWalletDapp", ['ngRoute']);

app.controller("MainController", function($scope) {
  $scope.myVar ='Main';
});

app.controller("ShoweventsController", function($scope) {
  $scope.myVar ='Showevents';
});

app.controller("SendfundsController", function($scope) {

  $scope.accounts = web3.eth.accounts;

  var contract = SimpleWallet.deployed();

  $scope.depositFunds = function(address, amount) {
    var contract = SimpleWallet.deployed();

    web3.eth.sendTransaction({from: address, to: contract.address, value: web3.toWei(amount, "ether")}, function(error, result) {
      if(error) {
        $scope.has_errors = "I did not work";
      } else {
        $scope.transfer_success = true;
      }
      $scope.$apply();
    });
  }

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