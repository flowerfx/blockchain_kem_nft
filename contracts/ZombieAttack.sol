//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ZombieHelper.sol";

contract ZombieAttack is ZombieHelper {
    uint randNonce = 0;
    uint attackVictoryProbability = 70;
    /************************************
     *  EXTERNAL FUNCTION DEFINED HERE  *
     ************************************/

    /**
     * attack : external function to call to make zombie attack the target
     * modifier 'ownerOfZombie()' mean that user excute this contract must own the zombie
     * @param zombieId : id of the zombie will attack
     * @param target : target id will be attacked
     */  
    function attack(uint zombieId, uint target) external ownerOfZombie(zombieId) {
        //get my zombie
        Zombie storage myZombie = ls_zombies[zombieId];
        //get the target zombie
        Zombie storage enemyZombie = ls_zombies[target];
        //win or not ?
        uint rand = PROTECTED_randMod(100);
        //check win or los
        if(rand <= attackVictoryProbability) {
            myZombie.winCount ++;
            myZombie.level ++;
            enemyZombie.lossCount ++;
            PROTECTED_feedAndMultiply(zombieId, enemyZombie.dna, "zombie");
        } else {
            myZombie.lossCount ++;
            enemyZombie.winCount ++;
            //trigger cool down when zombie attack complete
            PROTECTED_triggerCooldown(myZombie);
        }
    } 
    /************************************************************************
     *  PROTECTED FUNCTION DEFINED HERE (IN SOLIDITY DEFINED AS INTERNAL )  *
     ************************************************************************/

     /**
      * PROTECTED_randMod : internal function that will create the random number
      * @param modulus : param to generate
      * @return number in uint as a random number
      */
    function PROTECTED_randMod(uint modulus) internal returns(uint){
        randNonce++;
        uint value = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce)));
        return value % modulus;
    }
}