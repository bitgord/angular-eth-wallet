contract SimpleWallet {
	
	// address is the owner
	address owner;
	// mapping to determine if someone is allowed to send funds
	mapping(address => bool) isAllowedToSendFundsMapping;

	// event for deposit and for withdraw
	event Deposit(address _sender, uint amount);
	event Withdraw(address _sender, uint amount, address _beneficiary);

	// set the owner as soon as the wallet is created
	function SimpleWallet() {
		owner = msg.sender;
	}

	// this anonymous function is called when the contract receives funds of if called from an address with no funds
	// the msg.sender needs to be the owner or allowed to send funds to deposit them
	// we also emit an event called deposit and declare the msg sender and the value 
	function() {
		if(msg.sender == owner || isAllowedToSendFundsMapping[msg.sender] == true) {
			Deposit(msg.sender, msg.value);
		} else {
			throw;
		}
	}

	// Someone that is allowed to send funds is allowed to send  
	// in this case if it is the owner or the boolean mapping is true
	// their balance must be higher than the event
	// if it goes through we emit a withdraw event and return the balance
	function sendFunds(uint amount, address receiver) returns (uint) {
		if(msg.sender == owner || isAllowedToSendFundsMapping[msg.sender]) {
			if(this.balance >= amount) {
				if(!receiver.send(amount)) {
					throw;
				}
				Withdraw(msg.sender, amount, receiver);
				return this.balance;
			}
		}
	}

	// Allowed to send funds when the boolean mapping is set to true
	function allowAddressToSendMoney(address _address) {
		if(msg.sender == owner) {
			isAllowedToSendFundsMapping[_address] = true;
		}
	}

	// Not allowed to send funds when the boolean mapping is set to false
	function disallowAddressToSendMoney(address _address) {
		if(msg.sender == owner) {
			isAllowedToSendFundsMapping[_address] = false;
		}
	}

	// Check function which returns the boolean value
	function isAllowedToSend(address _address) constant returns (bool) {
		return isAllowedToSendFundsMapping[_address] || _address == owner;
	}

	// check to make sure the msg.sender is the owner or it will suicide the contract and return funds to the owner
	function killWallet() {
		if(msg.sender == owner) {
			suicide(owner);
		}
	}
}





