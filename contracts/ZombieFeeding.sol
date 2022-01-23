//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./ZombieFactory.sol";
/** 
 * the KittyInterface is a external contract and we will excuse the function 'getKitty'
 * of the constract kittyInterface, this will be defined in another contract
 */
interface KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}
contract ZombieFeeding is ZombieFactory {
    /**
     * ckAddress is contract address of kittyAddress on ETH blockchain
     * ref : https://etherscan.io/token/0x06012c8cf97BEaD5deAe237070F9587f8E7A266d
     * we will create the kittyContract by the address of the kittyInterface
     */
    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    KittyInterface kittyContract = KittyInterface(ckAddress);
    /**
     * ownerOf : modifier to require zombie is own of user who excuse the contract
     * @param zombieId : id of the zombie need to be checked
     */  
    modifier ownerOf(uint zombieId) {
        //make sure the user excuse this contract same as the mapping zombieToOwer
        (bool res , address add) = PROTECTED_getAddressByZombieID(zombieId);
        require(res == true);
        require(msg.sender == add);
        _;
    }
    /************************************
     *  EXTERNAL FUNCTION DEFINED HERE  *
     ************************************/  

    /**
     * setKittyContractAddress : in case the contract is change, so we re-update the contract of the kitty
     * attribute 'external' mean that this function can be call outside of the contract
     * modifier 'onlyOwner()' mean that only owner of contract can use its
     * @param kittyAdrress : new contract address of the kitty
     */
    function setKittyContractAddress(address kittyAdrress) external onlyOwner() {
        if(kittyAdrress == ckAddress) {
            return;
        }
        ckAddress = kittyAdrress;
        kittyContract = KittyInterface(ckAddress);
    }
    /**********************************
     *  PUBLIC FUNCTION DEFINED HERE  *
     **********************************/    

    /**
     * feedOnKitty : public function that will trigger when zombie eat a kitty
     * this function will excuse the function from external contract is kittyInterface and return the kittyDna
     * @param zombieID : id of the zombie
     * @param kittyID : id of the kitty
     */
    function feedOnKitty(uint zombieID, uint kittyID) public {
        // get the kittyDna from external contract
        (,,,,,,,,,uint kittyDna) = kittyContract.getKitty(kittyID);
        // excuse this ....
        PROTECTED_feedAndMultiply(zombieID, kittyDna, "kitty");
    }

    /************************************************************************
     *  PROTECTED FUNCTION DEFINED HERE (IN SOLIDITY DEFINED AS INTERNAL )  *
     ************************************************************************/

    /**
     * PROTECTED_triggerCooldown : internal function that wil trigger cooldown of the zoombie to begin
     * @param zombie : the zombie will be triggered
     */
    function PROTECTED_triggerCooldown(Zombie storage zombie) internal {
        zombie.readyTime = uint32(block.timestamp + cooldownTime);
    }

    /**
     * PROTECTED_isReady : internal function that check the zombie is ready or not
     * attribute 'view' mean is constant
     * 'view' also mean that function read on blockchain and dont modify anything on its
     * @param zombie : the zombie will be checked
     */
    function PROTECTED_isReady(Zombie storage zombie) internal view returns (bool) {
        return (zombie.readyTime <= block.timestamp);
    }

    /**
     * PROTECTED_feedAndMultiply : protected function that will perform the zombie bite another one and create new zombie
     * modifier 'ownerOf()' mean that user excute this contract must own the zombie
     * this function will only permit user that have own the zombie to excuse this
     * change the 'public' into 'internal' to check the security
     * @param zombieID : id of the zombie
     * @param targetDna : DNA of the one is bited
     */
    function PROTECTED_feedAndMultiply(uint zombieID, uint targetDna, string memory species) internal ownerOf(zombieID) {
        //storage mean the zombie is storage from blockchain network
        Zombie storage zombie = ls_zombies[zombieID];
        //make sure the zombie is ready
        require(PROTECTED_isReady(zombie) == true);
        // make sure target dna dont have pass the limit 16 character
        targetDna = targetDna % dnaDigits;
        // create new dna by target and zombie dna
        uint newDna = (targetDna + zombie.dna) / 2;
        //detect zombie ate kitty or not
        if (keccak256(abi.encodePacked(species)) == keccak256(abi.encodePacked("kitty"))) {
            //exp : newDna = 334455 , so newDna of kitty will be 334455 - 334455 % 100 = 334400 + 99 = 334499
            newDna = newDna - newDna% 100 + 99;
        }
        // create new zombie by new dna
        PROTECTED_createZombie("Unknown_Name", newDna);
        //trigger cooldown of the zombie
        PROTECTED_triggerCooldown(zombie);
    }
}