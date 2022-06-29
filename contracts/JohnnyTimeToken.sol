// SPDX-License-Identifier: MIT
  pragma solidity ^0.8.10;

  import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
  import "@openzeppelin/contracts/access/Ownable.sol";
  import "./IJohnnyTimeNFT.sol";

  contract JohnnyTimeToken is ERC20, Ownable {
    uint256 public constant tokenPrice = 0.001 ether;

    // 10 tokens per minted NFT, 18 Decimals
    uint256 public constant tokensPerNFT = 10 * 10**18;
    // 10,000 total supply
    uint256 public constant maxTotalSupply = 10000 * 10**18;
    JohnnyTimeNFT JohnnyTimeNFTContract;

    mapping(uint256 => bool) public tokenIdsClaimed;

    // The constructor loads the previous NFT contract
    constructor (address _johnnyTimeNFTAddress) public ERC20("JohnnyTime Token", "JTT") {
        JohnnyTimeNFTContract = JohnnyTimeNFT(_johnnyTimeNFTAddress);
    }





  }