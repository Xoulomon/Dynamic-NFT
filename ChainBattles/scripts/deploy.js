// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  
  const ChainBattles = await hre.ethers.getContractFactory("ChainBattles2.0");
  const chainBattles = await ChainBattles.deploy();

  await chainBattles.deployed();

  console.log(
    `Contract deployed to ${chainBattles.address}`
  );
  process.exit(0);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exit(1);
});
