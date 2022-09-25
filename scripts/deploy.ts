import { ethers } from "hardhat";

async function main() {

  const Candy = await ethers.getContractFactory("Candy");
  const candy = await Candy.deploy();
  await candy.deployed();
  console.log(`Candy deployed to ${candy.address}`);

  const Bee = await ethers.getContractFactory("Bee");
  const bee = await Bee.deploy();
  await bee.deployed();
  console.log(`Bee deployed to ${bee.address}`);
  
  const Farm = await ethers.getContractFactory("Farm");
  const farm = await Farm.deploy(candy.address, bee.address);
  await farm.deployed();
  console.log(`Farm deployed to ${farm.address}`);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
