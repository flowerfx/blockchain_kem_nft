pragma solidity ^0.8.0;
import "./ZombieFactory.sol";
contract ZombieFeeding is ZombieFactory {
    /**
     * feedAndMultiply : public function that will perform the zombie bite another one and create new zombie
     * this function will only permit user that have own the zombie to excuse this
     * @param zombieID : id of the zombie
     * @param targetDna : DNA of the one is bited
     */
    function feedAndMultiply(uint zombieID, uint targetDna) public {
        //make sure the user excuse this contract same as the mapping zombieToOwer
        (bool res , address add) = INTERNAL_SOL_getAddressByZombieID(zombieID);
        require(res == true);
        require(msg.sender == add);
        //storage mean the zombie is storage from blockchain network
        Zombie storage zombie = ls_zombies[zombieID];
        // make sure target dna dont have pass the limit 16 character
        targetDna = targetDna % dnaDigits;
        // create new dna by target and zombie dna
        uint new_dna = (targetDna + zombie.dna) / 2;
        // create new zombie by new dna
        INTERNAL_SOL_createZombie("Unknown name", new_dna);
    }
}