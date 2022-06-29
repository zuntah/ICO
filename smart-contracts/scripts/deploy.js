const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });
const { JOHNNY_TIME_NFT_CONTRACT_ADDRESS } = require("../constants");

async function main() {
  
  const johnnyTimeNFTContraactAddress = JOHNNY_TIME_NFT_CONTRACT_ADDRESS;
  
  const tokenSaleContract = await ethers.getContractFactory("JohnnyTimeToken");

  // deploy the contract
  const deployedTokenSaleContract = await tokenSaleContract.deploy(
    johnnyTimeNFTContraactAddress
  );

  // print the address of the deployed contract
  console.log(
    "Address:",
    deployedTokenSaleContract.address
  );
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });