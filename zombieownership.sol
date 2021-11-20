  pragma solidity ^0.8.0;

import "./zombieattack.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

abstract contract ZombieOwnership is ZombieAttack, IERC721 {

  mapping (uint => address) zombieApprovals;

  function balanceOf(address _owner) external view virtual returns (uint256) {
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    return zombieToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerZombieCount[_to]++;
    ownerZombieCount[_from]--;
    zombieToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external {
    require (zombieToOwner[_tokenId] == msg.sender || zombieApprovals[_tokenId] == msg.sender);
    _transfer(_from, _to, _tokenId);
  }

  function approve(address _approved, uint256 _tokenId) external onlyOwnerOf(_tokenId) {
    zombieApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }
}
