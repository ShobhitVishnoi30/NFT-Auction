//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.16;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract WhaleNFT is ERC721URIStorage, Ownable {
  struct IWhaleNFT {
    uint256 id;
    string name;
    string uri;
  }

  IWhaleNFT[] public whales;
  uint256 public totalWhales;

  mapping(address => bool) private governance;

  event Mint(uint256 id, string name, string uri);

  constructor(string memory _name, string memory _symbol)
    ERC721(_name, _symbol)
  {
    totalWhales = 0;
    governance[msg.sender] = true;
  }

  modifier onlyLiveToken(uint256 _nftId) {
    require(ownerOf(_nftId) != address(0), "Invalid NFT");
    _;
  }

  function addMinter(address _minter) public onlyOwner {
    require(_minter != address(0), "Invalid address");

    governance[_minter] = true;
  }

  function removeMinter(address _minter) public onlyOwner {
    require(_minter != address(0), "Invalid address");

    governance[_minter] = false;
  }

  function mint(string memory _name, string memory _uri)
    external
    returns (uint256)
  {
    require(governance[msg.sender], "No Permission");

    IWhaleNFT memory nft;
    nft.id = totalWhales;
    nft.name = _name;
    nft.uri = _uri;

    whales.push(nft);
    totalWhales++;

    _mint(msg.sender, nft.id);
    _setTokenURI(nft.id, _uri);

    emit Mint(nft.id, nft.name, nft.uri);

    return nft.id;
  }

  function burn(uint256 _nftId) external onlyLiveToken(_nftId) {
    require(_exists(_nftId), "Non existed NFT");

    _burn(_nftId);

    whales[_nftId].id = 0;
    whales[_nftId].name = "";
    whales[_nftId].uri = "";

    totalWhales--;
  }

  function transfer(uint256 _nftId, address _target)
    external
    onlyLiveToken(_nftId)
  {
    require(_exists(_nftId), "Non existed NFT");
    require(
      ownerOf(_nftId) == msg.sender || getApproved(_nftId) == msg.sender,
      "Not approved"
    );
    require(_target != address(0), "Invalid address");

    _transfer(ownerOf(_nftId), _target, _nftId);
  }
}
