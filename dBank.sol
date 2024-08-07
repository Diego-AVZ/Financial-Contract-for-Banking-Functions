//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//______________________________________________
//___Financial Contract for Banking Functions___
//______________21/09/2023, Author: Diego-AVZ___
//______________________________________________

contract CreatePersonalAccount{ //Factory

    mapping(address => address) public yourContract;

    function createAccount(string memory name, string memory id) public {
        personalAccount newPersonalAccount = new personalAccount(msg.sender, name, id);
        yourContract[msg.sender] = address(newPersonalAccount);
    }
}

// Personal Account

contract personalAccount {

    address public owner;
    string public ownerName;
    string public ownerId;

    constructor (address _owner, string memory _name, string memory id) {
        owner = _owner;
        ownerName = _name;
        ownerId = id;

    }

    modifier onlyOwner () {
        require(msg.sender == owner, "Not Owner");
        _;
    }

    mapping(address => address) PayFromToAddresses;
    
    struct payments{
        address to;
        uint amount;
        string concept;
    }
    
    payments[] payList;

    function depositETH() public payable {
        balanceETH = balanceETH + (msg.value - (msg.value/fee));
        payable(protocolAddress).transfer(msg.value/fee);
        feesPaidCount = feesPaidCount + (msg.value/fee);
    }

    function getContractBalanceEth() public view returns(uint){
        return(balanceETH);
    }

    function getAddressBalanceETH() public view returns(uint){
        return(owner.balance);
    }

    address protocolAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4; // My Address
    uint public feesPaidCount;
    uint public balanceETH;
    uint256 fee = 900;

    function payFromContract(address receiver, uint amount, string memory concept) public onlyOwner {
        require(amount <= balanceETH);
        payable(receiver).transfer(amount - amount/fee);
        payable(protocolAddress).transfer(amount/fee);
        balanceETH = balanceETH - amount;
        feesPaidCount = feesPaidCount + amount/fee;
        payments memory newPayment = payments(receiver, amount, concept);
        payList.push(newPayment);  
        
    }

    function payFromAddress(address receiver,  string memory concept) public payable {
        require(msg.value <= address(msg.sender).balance);
        depositETH();
        payFromContract(receiver, msg.value, concept);
        payments memory newPayment = payments(receiver, msg.value, concept);
        payList.push(newPayment);
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
        require(isFamilyMember[msg.sender] == true, "NotFamily");
        _;
    }

    function seeFamily(uint index) public view returns(address, string memory){
        family memory selectedFamily = familyList[index];
        return(selectedFamily.familyAddress, selectedFamily.familyName);
    }


    function requirePayment(address to, uint amount, string memory concept) public {
        //Función para solicitar pagos tipo Bizum
    }
    
}
