const hre = require("hardhat");

async function main() {

  const contract = await hre.ethers.deployContract("ProVoting");

  await contract.waitForDeployment();

  console.log(
    `ProVoting deployed to ${contract.target}`
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});