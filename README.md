# Smart Contract Audit Report Using Slither

## Given Solidity Smart Contract

```Solidity

pragma solidity ^0.4.23;

contract StorageVictim {
    address owner;

    struct Storage {
        address user;
        uint amount;
    }

    mapping(address => Storage) storages;

    function StorageVictim() public {
        owner = msg.sender;
    }

    function store(uint _amount) public {
        // uninitialised pointer. str.user points to the storage address 0 which is "owner"

        Storage str;

        str.user = msg.sender;

        str.amount = _amount;

        storages[msg.sender] = str;
    }

    function getStore() public view returns (address, uint) {
        Storage str = storages[msg.sender];

        return (str.user, str.amount);
    }

    function getOwner() public view returns (address) {
        return owner;
    }
}
```

## Audit Report Using Slither

### Syntax Error

<img width="1462" alt="Syntax Errors" src="https://github.com/PradeepSahhu/ETH-ADVANCE-Auditor/assets/94203408/44edba16-eb53-4fb4-bf85-ccaec004fcda">

### Explanation :

- Always use the latest stable solidity version and never use ^ with the versioning. Define a single version type. & Never miss a `SPDX-License-identifier`
- Giving Warning that using the function name same as contract name is depreciated.

  ```Solidity
   Storage str;

   Storage str = storages[msg.sender];
  ```

- Warning in the above line statements that `str` is declared as a pointer, try to use storage, or memory keyword to define it as a variable.
- Also Warning of that `Storage str` variable is never initiallized.

### Security Problems

<img width="1468" alt="Security Problems" src="https://github.com/PradeepSahhu/ETH-ADVANCE-Auditor/assets/94203408/dbc8cebb-5360-49bc-9126-4508e7873b3d">

### Explanation :

- There are two types of Vulnerabilities in the given program.

## !Red meaning the severe Problem in the code Base.

Here only one Severe Problem which is in red and i.e. the statement `Storage str` is never initiallized, or at least solc compiler thinks so.

## ! Some Security Problems which are in green are not that severe

- First one is obviously the old solidity versioning issue, slither says to use latest solidity compiler.
- specially that solidity version i.e. `version 0.4.23` contains some unknown bugs which might cause problem to our smart contract.
- and the last one is to use mixedCase as the variable name. ( which really doesn't matter that much)

# Fixing the Above Security Problems

```Solidity

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

```

## Explanation :

- Added the SPDX-License Identifier of MIT
- Uses the latest stable Solidity Version and defined a specific version
- Made the OWNER state variables as immutable as its value once assigned will never gonna change, hence it cost less gas fees and more secure.
- As the Owner is immutable wrote it in all UPPERCASE, (following Convention)
- used memory keyword with the `Storage memory str` variables
- Initiallized the `str varialble with Stroage(msg.sender, _amount)` which was causing Severe Issue in slither test.

After all the security Fixes the slither Report is shown below.

<img width="1470" alt="Solved the Security Vulnerabilities" src="https://github.com/PradeepSahhu/ETH-ADVANCE-Auditor/assets/94203408/e2969fb0-1569-47d1-bee6-119d52afbd10">
