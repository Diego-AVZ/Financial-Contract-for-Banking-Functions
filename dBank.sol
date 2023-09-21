//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//______________________________________________
//___Financial Contract for Banking Functions___
//______________21/09/2023, Author: Diego-AVZ___
//______________________________________________

contract CreatePersonalAccount{ //Factory

    mapping(address => address) public yourContract;

    function createAccount() public {
        personalAccount newPersonalAccount = new personalAccount(msg.sender);
        yourContract[msg.sender] = address(newPersonalAccount);
    }
}

contract personalAccount {

    address public owner;

    constructor (address _owner) {
        owner = _owner;
    }

    modifier onlyOwner () {
        require(msg.sender == owner, "Not Owner");
        _;
    }

    mapping(address => address) PayFromToAddresses;
    
    struct payments{
        address to;
        uint amount;
    }
    
    payments[] payList;

    function depositETH() public payable {
        balanceETH = balanceETH + msg.value;
    }

    uint public balanceETH;

    function payFromContract(address receiver, uint amount) public onlyOwner {
        require(amount <= balanceETH);
        payable(receiver).transfer(amount);
        balanceETH = balanceETH - amount;
        payments memory newPayment = payments(receiver, amount);
        payList.push(newPayment);
    }

    function payFromAddress(address receiver) public payable {
        require(msg.value <= address(msg.sender).balance);
        depositETH();
        payFromContract(receiver, msg.value);
    }
}
