// SPDX-License-Identifier:MIT
// Adding the License Identifier
pragma solidity 0.8.23; // Version should be latest Solidity Stable Version which is also bug free.

contract StorageVictim {
    address immutable OWNER; // it should be immutable as once set it will never change. (as immutable should be in all UPPERCASE to show that they are imutable.)
    // Also immutable state variables cost less gas. (better for optimization and security)
    struct Storage {
        address user;
        uint amount;
    }

    mapping(address => Storage) storages;

    constructor() {
        OWNER = msg.sender;
    }

    function store(uint _amount) public {
        // in the case of Struture , Array and mapping, we need to explicitely define either it is stored in memory or storage.

        Storage memory str = Storage(msg.sender, _amount); // added memory (its temporarly stored and later will be assigned to other)

        storages[msg.sender] = str;
    }

    function getStore() public view returns (address, uint) {
        Storage memory str = storages[msg.sender];

        return (str.user, str.amount);
    }

    function getOwner() public view returns (address) {
        return OWNER;
    }
}
