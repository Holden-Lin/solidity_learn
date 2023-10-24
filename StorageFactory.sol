// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

// Any subsequent references to simple_storage will be referring to the imported contract \
// unless explicitly defined otherwise

// but as the contract name is SimpleStorage in simple_storage.sol \
// we must use SimpleStorage to refer to the imported contract
import "./simple_storage.sol";

contract storage_factory is SimpleStorage{

    // SimpleStorage to refer to the imported contract
    SimpleStorage[] public simpleStorageArray;
    
    function create_contract() public {
        // the first SimpleStorage is type declaration
        // simpleStorage is variable name
        // new SimpleStorage() is actuall initiation
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
        
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public{

        // below is the original code by the author. it's doing a round-trip: Contract -> Address -> Contract
        // SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).store(_simpleStorageNumber); 

        // now we use inherited function "store" to store the input number as favoriteNumber
        simpleStorageArray[_simpleStorageIndex].store(_simpleStorageNumber);

    }

    function sfGet(uint _simpleStorageIndex) public view returns (uint256) {
        // now we use inherited function "retrieve" to get favoriteNumber
        return simpleStorageArray[_simpleStorageIndex].retrieve();
    }

}