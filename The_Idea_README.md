# Financial Contract for Banking Functions #

**Solidity** is one of the most common languages for **Decentralized Finance**.

## What if I can build an easy-to-use, bank-like, fully decentralized app for individuals financial services? ##

**Let's Begin!**

---

###First Contract: **The mother contract.**

It is a Simple Factory Contract that creates a new account for the user, registers the username, ID, and the user's address in the `createAccount` function. Also, that function associates the `msg.sender` address with the new contract address in the `mapping(address => address) public yourContract`

```solidity
contract CreatePersonalAccount{ //Factory

    mapping(address => address) public yourContract;

    function createAccount(string memory name, string memory id) public {
        personalAccount newPersonalAccount = new personalAccount(msg.sender, name, id);
        yourContract[msg.sender] = address(newPersonalAccount);
    }
}
```
