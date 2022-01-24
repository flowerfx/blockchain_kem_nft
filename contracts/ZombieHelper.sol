//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ZombieFeeding.sol";

contract ZombieHelper is ZombieFeeding {
    //use safemath
    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;
    //fee to level up a zombie by ether
    uint levelUpFee = 0.001 ether;
    /**
     * aboveLevel : modifier to require zombie with zombieId >= level
     * @param level : level need to be compared
     * @param zombieId : id of the zombie need to be checked
     */
    modifier aboveLevel(uint level, uint zombieId) {
        require(ls_zombies[zombieId].level >= level);
        _;
    }
    /************************************
     *  EXTERNAL FUNCTION DEFINED HERE  *
     ************************************/
     /**
     * setLevelUpFee : external function that will change the fee of levelup, and only owner of contract can excuse this function
     * attribute 'external' mean that this function can be call outside of the contract
     * modifier 'onlyOwner()' mean that only owner of contract can use its
     * @param fee : new level up feee
     */
    function setLevelUpFee(uint fee) external onlyOwner() {
        levelUpFee = fee;
    }

     /**
     * withdraw : external function that will withdraw the ETH of the owner
     * attribute 'external' mean that this function can be call outside of the contract
     * modifier 'onlyOwner()' mean that only owner of contract can use its
     */
    function withdraw() external onlyOwner() {
        address payable _owner = payable(address(owner()));
        _owner.transfer(address(this).balance);
    }
    /**
     * levelUp : external function to levelup a zombie with fee ETH
     * attribue 'payable' mean that when excuse this function, user will be cost fee ETH
     * modifier 'ownerOfZombie()' mean that user excute this contract must own the zombie
     * @param zombieId : id of the zombie that need to be leveled up
     */
    function levelUp(uint zombieId) external payable ownerOfZombie(zombieId) {
        //check that user have paid fee
        require(msg.value == levelUpFee);
        //safe math
        ls_zombies[zombieId].level = ls_zombies[zombieId].level.add(1);
    }
    /**
     * changeName : external function change name of the zombie, and can be trigger outside the contract
     * modifier 'ownerOfZombie()' mean that user excute this contract must own the zombie
     * @param zombieId : id of the zombie need to be rename
     * @param newName : new name of the zombie , calldata equal with memory, but can use only with external function
     */
    function changeName(uint zombieId , string calldata newName) external ownerOfZombie(zombieId) {
        //set new name of the zombie
        ls_zombies[zombieId].name = newName;
    }

    /**
     * changeDna : external function change dna of the zombie, and can be trigger outside the contract
     * modifier 'aboveLevel' mean only zombie with level above 20, can excuse this function
     * modifier 'ownerOfZombie()' mean that user excute this contract must own the zombie
     * @param zombieId : id of the zombie need to be rename
     * @param newDna : new dna of the zombie
     */
    function changeDna(uint zombieId, uint newDna) external aboveLevel(20, zombieId) ownerOfZombie(zombieId){
        //set new dna of the zombie
        ls_zombies[zombieId].dna = newDna;
    }

    /**
     * getZombiesByOwner : external function to get list zombie by owner address
     * this function have attribute 'external' and 'view' mean that when excuse this function, we dont need gas fee on ETH network
     * 'view' also mean that function read on blockchain and dont modify anything on its
     * @param owner : address of the owner
     * @return array of uint to point to the address
     */
    function getZombiesByOwner(address owner) external view returns(uint[] memory) {
       uint[] memory result = new uint[](ownerZombieCount[owner]);
        uint counter = 0;
        for (uint i = 0; i < ls_zombies.length; i++) {
            if (zombieToOwner[i] == owner) {
                //assign
                result[counter] = i;
                //safe math
                counter = counter.add(1);
            }
        }
        return result;
    }
}