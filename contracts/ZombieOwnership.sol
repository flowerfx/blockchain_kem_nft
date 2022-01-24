//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./ZombieAttack.sol";

//the zo
contract ZombieOwnership is ZombieAttack, ERC721 {
    //use safemath
    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;
    //
    //mapping 
    mapping (uint => address) zombieApprovals;
    /****************************************
     *  ERC721 FUNCTION LOGIC DEFINED HERE  *
     ****************************************/
    function balanceOf(address _owner) external override view returns (uint256) {
        // 1. Return the number of zombies `_owner` has here
        return ownerZombieCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external override view returns (address) {
        // 2. Return the owner of `_tokenId` here
        return zombieToOwner[_tokenId];
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external override payable {
        require (zombieToOwner[_tokenId] == msg.sender || zombieApprovals[_tokenId] == msg.sender);
        INTERNAL_transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) external override payable ownerOfZombie(_tokenId) {
        zombieApprovals[_tokenId] = _approved;
        //raise the event from ERC721
        emit Approval(msg.sender, _approved, _tokenId);
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
        ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
        //number of zombie of from decrease
        ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
        //change owner of the zombie id
        zombieToOwner[_tokenId] = _to;
        //raise the event from ERC721
        emit Transfer(_from, _to, _tokenId);
    }
}