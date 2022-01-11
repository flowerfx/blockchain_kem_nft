pragma solidity ^0.8.0;

contract ZombieFactory {
    //this variable is store enternal on blockchain
    //dna of the zombie will has 16 character
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits; // = 10^16
    //zombie struct
    struct Zombie {
        //name of the zoombie
        string name;
        //meta data of the zombie in json
        string metadata;
        //id of the zombie
        uint id;
        //dna of the zombie
        uint dna;
    }
    //list of the zombie in arrays
    Zombie[] public ls_zombies;

    /**
     * createZombie : private function to create the zombie with given params
     * @param name : name of the zombie
     * @param dna : dna of the zombie
     */
    function createZombie(string memory name, uint dna) private {
        ls_zombies.push(Zombie(name , "", 0 , dna));
    }
}