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


});