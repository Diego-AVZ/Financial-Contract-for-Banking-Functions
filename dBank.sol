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
        // addFee fee = amount*((1/3)/100)
    }

    function payFromAddress(address receiver) public payable {
        require(msg.value <= address(msg.sender).balance);
        depositETH();
        payFromContract(receiver, msg.value);
        // addFee fee = amount*((1/3)/100)
    }

    mapping(string => address) public searchAddress;

    struct yourContacts{
        address Contact;
        string name;
    }

    yourContacts[] public contactList;

    function addContact(address newContact, string memory name) public {
        searchAddress[name] = newContact;
        yourContacts memory newYourContacts = yourContacts(newContact, name);
        contactList.push(newYourContacts);
    }

    struct family {
        address familyAddress;
        string familyName;
    }
    
    family[] familyList;
    mapping(address => bool) public isFamilyMember;

    function addFamily(address member, string memory name) public {
        family memory newFamily = family(member, name);
        familyList.push(newFamily);
        isFamilyMember[member] = true;
    }

    modifier onlyFamily() {
        require(isFamilyMember[msg.sender] = true, "NotFamily");
        _;
    }

    function seeFamily(uint index) public view returns(address, string memory){
        family memory selectedFamily = familyList[index];
        return(selectedFamily.familyAddress, selectedFamily.familyName);
    }

}
