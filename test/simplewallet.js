// we have access to access to accounts from ether pudding
// this checks to see if the owner is allowed to send funds
contract('SimpleWallet', function(accounts) {
	it('the owner is allowed to send funds', function() {
		// get access to the SimpleWallet contract by calling SimpleWallet.deployed
		var myContract = SimpleWallet.deployed();
		// can call function which returns the bool value of whether allowed or not 
		// we give the first account accounts[0] which was the one that setup the contract
		myContract.isAllowedToSend.call(accounts[0]).then(function(isAllowed) {
			// assert that isAllowed equals true
			assert.equal(isAllowed, true, 'the owner should have been allowed to send funds');
		})
	});

	it('the other account should not be allowed to send funds', function() {
		var myContract = SimpleWallet.deployed();
			return myContract.isAllowedToSend.call(accounts[2]).then(function(isAllowed) {
				// assert that isAllowed equals false
				assert.equal(isAllowed, false, 'the other account was allowed to send funds');
			})
	});

	// See if we can add accounts to the allowed list
	it('adding accounts to the allowed list', function() {
		var myContract = SimpleWallet.deployed();
			// first check to see if another account is allowed to send funds // it should return false
			return myContract.isAllowedToSend.call(accounts[1]).then(function(isAllowed) {
				assert.equal(isAllowed, false, 'the other account was allowed');
				// then allow the address to send money
			}).then(function() {
				return myContract.allowAddressToSendMoney(accounts[1])
				// then check to see if its allowed to send
			}).then(function() {
				return myContract.isAllowedToSend.call(accounts[1]);
				// this should return true now
			}).then(function(isAllowed) {
				assert.equal(true, isAllowed, 'the other account is allowed');
				// then disallow address from sending money again
			}).then(function() {
				return myContract.disallowAddressToSendMoney(accounts[1]);
				// then check if the account is allowed
			}).then(function() {
				return myContract.isAllowedToSend.call(accounts[1]);
				// it should return false again
			}).then(function(isAllowed) {
				assert.equal(false, isAllowed, 'the account was not allowed');
			});
	});


});