contract SimpleWallet {
	
	// address is the owner
	address owner;

	struct WithdrawlStruct {
		address to;
		uint amount;
	}

	struct Senders {
		bool allowed;
		uint amount_sends;
		mapping(uint => WithdrawlStruct) withdrawls;
	}

	// mapping to determine if sender is allowed to send funds
	mapping(address => Senders) isAllowedToSendFundsMapping;

	// event for deposit and for withdraw
	event Deposit(address _sender, uint amount);
	event Withdraw(address _sender, uint amount, address _beneficiary);

	// set the owner as soon as the wallet is created
	function SimpleWallet() {
		owner = msg.sender;
	}

	// this anonymous function is called when the contract receives funds from an address that is allowed to send funds
	// the msg.sender needs to be the owner and allowed to send funds to deposit them
	// we also emit an event called deposit and declare the msg sender and the value 
	function() {
		if(isAllowedToSend(msg.sender)) {
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
		if(isAllowedToSend(msg.sender)) {
			if(this.balance >= amount) {
				if(!receiver.send(amount)) {
					throw;
				}
				Withdraw(msg.sender, amount, receiver);
				// log each withdrawl, receiver, amount
				isAllowedToSendFundsMapping[msg.sender].amount_sends++;
				isAllowedToSendFundsMapping[msg.sender].withdrawls[isAllowedToSendFundsMapping[msg.sender].amount_sends].to = receiver;
				isAllowedToSendFundsMapping[msg.sender].withdrawls[isAllowedToSendFundsMapping[msg.sender].amount_sends].amount = amount;
				return this.balance;
			}
		}
	}

	// function to get the number of withdrawls and return each withdrawl
	function getAmountOfWithdrawls(address _address) constant returns (uint) {
        return isAllowedToSendFundsMapping[_address].amount_sends;
      }

	// function to get the withdrawl amount for the address and return amount and address
	function getWithdrawlForAddress(address _address, uint index) constant returns (address, uint) {
        return (isAllowedToSendFundsMapping[_address].withdrawls[index].to, isAllowedToSendFundsMapping[_address].withdrawls[index].amount);
      }

	// Allowed to send funds when the boolean mapping is set to true
	function allowAddressToSendMoney(address _address) {
		if(msg.sender == owner) {
			isAllowedToSendFundsMapping[_address].allowed = true;
		}
	}

	// Not allowed to send funds when the boolean mapping is set to false
	function disallowAddressToSendMoney(address _address) {
		if(msg.sender == owner) {
			isAllowedToSendFundsMapping[_address].allowed = false;
		}
	}

	// Check function which returns the boolean value
	function isAllowedToSend(address _address) constant returns (bool) {
		return isAllowedToSendFundsMapping[_address].allowed || _address == owner;
	}

	// check to make sure the msg.sender is the owner or it will suicide the contract and return funds to the owner
	function killWallet() {
		if(msg.sender == owner) {
			suicide(owner);
		}
	}
}





