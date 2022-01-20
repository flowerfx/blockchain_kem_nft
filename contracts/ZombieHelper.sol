//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ZombieFeeding.sol";


contract ZombieHelper is ZombieFeeding {

    /**
     * aboveLevel : modifier to require zombie with zombieId >= level
     * @param level : level need to be compared
     * @param zombieId : id of the zombie need to be checked
     */
    modifier aboveLevel(uint level, uint zombieId) {
        require(zombies[zombieId].level >= level);
        _;
    }

    /************************************
     *  EXTERNAL FUNCTION DEFINED HERE  *
     ************************************/

    /**
     * changeName : external function change name of the zombie, and can be trigger outside the contract
     * @param zombieId : id of the zombie need to be rename
     * @param newName : new name of the zombie , calldata equal with memory, but can use only with external function
     */
    function changeName(uint zombieId , string calldata newName) external {
        //make sure the user excuse this contract same as the mapping zombieToOwer
        (bool res , address add) = PROTECTED_getAddressByZombieID(zombieID);
        require(res == true);
        require(msg.sender == add);
        //set new name of the zombie
        ls_zombies[zombieId].name = newName;
    }

    /**
     * changeDna : external function change dna of the zombie, and can be trigger outside the contract
     * modifier 'aboveLevel' mean only zombie with level above 20, can excuse this function
     * @param zombieId : id of the zombie need to be rename
     * @param newDna : new dna of the zombie
     */
    function changeDna(uint zombieId, uint newDna) external aboveLevel(20, zombieId) {
        //make sure the user excuse this contract same as the mapping zombieToOwer
        (bool res , address add) = PROTECTED_getAddressByZombieID(zombieID);
        require(res == true);
        require(msg.sender == add);
        //set new dna of the zombie
        zombies[zombieId].dna = newDna;
    }


}