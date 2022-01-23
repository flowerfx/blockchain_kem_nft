//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./ZombieAttack.sol";

//the zo
contract ZombieOwnership is ZombieAttack, ERC721 {

    /****************************************
     *  ERC721 FUNCTION LOGIC DEFINED HERE  *
     ****************************************/
    function balanceOf(address _owner) external view returns (uint256) {
        // 1. Return the number of zombies `_owner` has here
        return ownerZombieCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        // 2. Return the owner of `_tokenId` here
        return zombieToOwner[_tokenId];
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {

    }

    function approve(address _approved, uint256 _tokenId) external payable {

    }

    /***********************************
     *  PRIVATE FUNCTION DEFINED HERE  *
     ***********************************/

    /**
     * INTERNAL_transfer : private function that will handle transfer tokenId from address to address
     * @param _from : from address 
     * @param _to : to address
     * @param _tokenId : id of the token will be tranfered
     */ 
    function INTERNAL_transfer(address _from, address _to, uint256 _tokenId) private {
        //number of zombie of to increase
        ownerZombieCount[_to]++;
        //number of zombie of from decrease
        ownerZombieCount[_from]--;
        //change owner of the zombie id
        zombieToOwner[_tokenId] = _to;
        //raise the event from ERC721
        emit Transfer(_from, _to, _tokenId);
    }
}