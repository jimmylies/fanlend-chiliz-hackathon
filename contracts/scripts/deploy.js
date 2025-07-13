const { ethers } = require("hardhat");

async function main() {
  // Fetch deployer account
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  // Deploy a mock or existing PriceOracle
  const PriceOracle = await ethers.getContractFactory("PriceOracle");
  const priceOracle = await PriceOracle.deploy();
  await priceOracle.deployed();
  console.log("PriceOracle deployed to:", priceOracle.address);

  // Deploy CollateralVault with the oracle address
  const CollateralVault = await ethers.getContractFactory("CollateralVault");
  const collateralVault = await CollateralVault.deploy(priceOracle.address);
  await collateralVault.deployed();
  console.log("CollateralVault deployed to:", collateralVault.address);

  // Set max LTV as 75%
  const maxLTV = ethers.utils.parseEther("0.75");
  const PositionManager = await ethers.getContractFactory("PositionManager");
  const positionManager = await PositionManager.deploy(
    collateralVault.address,
    priceOracle.address,
    maxLTV
  );
  await positionManager.deployed();
  console.log("PositionManager deployed to:", positionManager.address);

  // Set liquidation bonus as 5%
  const liquidationBonus = ethers.utils.parseEther("0.05");
  const LiquidationEngine = await ethers.getContractFactory(
    "LiquidationEngine"
  );
  const liquidationEngine = await LiquidationEngine.deploy(
    collateralVault.address,
    positionManager.address,
    priceOracle.address,
    liquidationBonus
  );
  await liquidationEngine.deployed();
  console.log("LiquidationEngine deployed to:", liquidationEngine.address);

  console.log("\nDeployed contract addresses:");
  console.log(`PriceOracle:       ${priceOracle.address}`);
  console.log(`CollateralVault:   ${collateralVault.address}`);
  console.log(`PositionManager:   ${positionManager.address}`);
  console.log(`LiquidationEngine: ${liquidationEngine.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
