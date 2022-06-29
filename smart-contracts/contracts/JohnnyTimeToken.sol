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

    function mint(uint256 _requestedAmount) public payable {

        // Check that the user sent enough ETH
        uint256 requiredETHAmount = tokenPrice * _requestedAmount;
        require(msg.value >= requiredETHAmount, "Need to send more ETH. 1 token = 0.001 ETH.");
        
        uint256 amountWithDecimals = _requestedAmount * 10**18;

        // Check that we don't surpass max supply
        require(
            (totalSupply() + amountWithDecimals) <= maxTotalSupply,
            "Exceeds the max total supply available."
        );

        _mint(msg.sender, amountWithDecimals);
    }

    function claim() public {

        // Check if sender has JohnnyTime NFTs
        address sender = msg.sender;
        uint256 balance = JohnnyTimeNFTContract.balanceOf(sender);
        require(balance > 0, "You don't own any JohnnyTime NFTs");

        // Calculate how many claimable NFTs the user have
        uint256 validClaimableNFTs = 0;
        for(uint256 i = 0; i < balance; i++) {
            uint256 tokenId = JohnnyTimeNFTContract.tokenOfOwnerByIndex(sender, i);

            if(!tokenIdsClaimed[tokenId]){
                validClaimableNFTs += 1;
                tokenIdsClaimed[tokenId] = true;
            }
        }
        require(validClaimableNFTs > 0, "You've already claimed all the tokens for your NFTs");

        uint256 tokensToMint = validClaimableNFTs * tokensPerNFT;

        // Check that we don't surpass max supply
        require(
            (totalSupply() + tokensToMint) <= maxTotalSupply,
            "Exceeds the max total supply available."
        );

        _mint(msg.sender, tokensToMint);
    }

    function withdraw() public onlyOwner() {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent,) = _owner.call{value: amount}("");
        require(sent, "Failed to withdraw ETH");
    }

    receive() external payable {}

    fallback() external payable {}

  }