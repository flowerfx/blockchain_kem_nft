//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//use safe math
import "./SafeMath.sol";
//import ownable to this
import "./Ownable.sol";
//
contract ZombieFactory is Ownable {
    //use safemath
    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;
    //this variable is store enternal on blockchain
    //dna of the zombie will has 16 character
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits; // = 10^16
    //time countdown will be set to 1 days 
    uint32 cooldownTime = 1 days;
    //zombie struct
    struct Zombie {
        //name of the zoombie
        string name;
        //dna of the zombie
        uint dna;
        //id of the zombie
        uint32 id;
        //
        uint32 level;
        //
        uint32 readyTime;
        //number win of this zombie
        uint16 winCount;
        //number lose of this zombie
        uint16 lossCount;
    }
    //list of the zombie in arrays
    //in the blockchain, the user will share this list of zombies
    Zombie[] public ls_zombies;
    //mapping of the zombie owner
    //which id of zombie will be mapped with address of the user
    mapping (uint => address) public zombieToOwner;
    //which address of the user will have the number zombie counting
    mapping (address => uint) ownerZombieCount;

    /**********************************
     *  EVENT FUNCTION DEFINED HERE  *
     **********************************/

    // event in solidy when have zombie added
    event EVENT_newZombie(uint id, string name, uint dna);

    /**********************************
     *  PUBLIC FUNCTION DEFINED HERE  *
     **********************************/

    /**
     * createRandomZombie : public function to create zombie with given name
     *  in the function we will restrict user call this multi time to make the game unbalance, so only count of zoombie of user = 0 is permissed
     * @param name : name of the zombie
     */
    function createRandomZombie(string memory name) public {
        //only user that not own any zombie that can excuse this function
        require(ownerZombieCount[msg.sender] == 0);
        //we will create the dna first 
        uint dna = INTERNAL_generateRandomDna(name);
        //then we will create the zombie
        PROTECTED_createZombie(name, dna);
    }

    /************************************************************************
     *  PROTECTED FUNCTION DEFINED HERE (IN SOLIDITY DEFINED AS INTERNAL )  *
     ************************************************************************/

    /**
     * PROTECTED_getAddressByZombieID : internal function to get address of user that hold the zombie by ID
     * the function have 'view' attribute mean the value return is constant and could not be modified
     * 'view' also mean that function read on blockchain and dont modify anything on its
     * the function have mark 'internal' mean, the constract inherited this constract can call this func
     * @param zombieID : id of the zoombie
     * @return succeed : get the address succeed or not
     * @return res : address if succeed
     */
    function PROTECTED_getAddressByZombieID(uint zombieID) internal view returns (bool succeed, address res) {
        if(zombieID >= ls_zombies.length) {
            succeed = false;
            res = address(0x0);
        } else {
            succeed = true;
            res = zombieToOwner[zombieID];
        }
        return (succeed , res);
    }

    /**
     * PROTECTED_createZombie : internal function to create the zombie with given params
     * the function have mark 'internal' mean, the constract inherited this constract can call this func
     * @param name : name of the zombie
     * @param dna : dna of the zombie
     */
    function PROTECTED_createZombie(string memory name, uint dna) internal {
        //size of the list zoombie
        uint len = ls_zombies.length;
        //add the new zombie to the list control
        ls_zombies.push(Zombie(name , dna , uint32(len) , 1 , uint32(block.timestamp + cooldownTime) , 0 , 0 ));
        //
        // msg.sender is global value that handle the address of the user in excusing this contract
        // @param len is the id of the zombie
        zombieToOwner[len] = msg.sender;
        //++
        ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);
        //emit the event in blockchain network
        emit EVENT_newZombie(len, name, dna);
    }

    /***********************************
     *  PRIVATE FUNCTION DEFINED HERE  *
     ***********************************/

    /**
     * INTERNAL_generateRandomDna : private function to generate the DNA, with param string by mem (like const string & in c++)
     * the function have 'view' attribute mean the value return is constant and could not be modified
     * 'view' also mean that function read on blockchain and dont modify anything on its
     * @param str : string to seed
     * @return unint : DNA in uint with 16 char
     */
    function INTERNAL_generateRandomDna(string memory str) private view returns (uint) {
        //keccak256 is function of ETH to create hash number
        //abi.encodePacked(...) -> byte value in hex 0xabc.....
        //keccak256 convert the byte value into number hash
        uint rand = uint(keccak256(abi.encodePacked(str)));
        //to make sure the uint result have dnaModulus character
        return rand % dnaModulus;
    }

    /**
     * INTERNAL_multiply : private pure function to mutiply 2 number
     * the function have 'pure' attribute ensure that they not read or modify the state
     * 'pure' also mean that function dont read or write on blockchain
     * @param a : number 1 in uint
     * @param b : number 2 in uint
     * @return a*b in uint
     */
    function INTERNAL_multiply(uint a, uint b) private pure returns (uint) {
        return a * b;
    }

    /**
     * INTERNAL_add : private pure function to add 2 number
     * the function have 'pure' attribute ensure that they not read or modify the state
     * 'pure' also mean that function dont read or write on blockchain
     * @param a : number 1 in uint
     * @param b : number 2 in uint
     * @return c = a+b in uint
     */
    function INTERNAL_add(uint a, uint b) private pure returns (uint c) {
        c = a * b;
    }
}