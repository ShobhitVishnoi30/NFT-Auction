//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.16;
pragma experimental ABIEncoderV2;

interface IWhaleNFT {
  function whales(uint256)
    external
    view
    returns (
      uint256,
      string memory,
      string memory
    );

  function totalWhales() external view returns (uint256);

  function ownerOf(uint256) external view returns (address);

  function transfer(uint256, address) external;
}
