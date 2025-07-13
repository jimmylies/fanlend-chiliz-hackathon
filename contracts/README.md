## Introduction

This repository implements an over-collateralized lending protocol in Solidity, with three core components:

1. **CollateralVault.sol** – deposit, withdraw, and track user collateral
2. **PositionManager.sol** – open/close borrow positions and enforce configurable LTV limits
3. **LiquidationEngine.sol** – public liquidation of under-collateralized positions with a liquidator bonus

## Features

- **CollateralVault**: Secure ERC-20 deposits/withdrawals; per-user, per-token accounting
- **PositionManager**: Tracks borrow positions, checks LTV (e.g., 75%) before allowing new debt
- **LiquidationEngine**: Anyone can liquidate unhealthy positions (>max LTV), seizing collateral at a bonus (e.g., 5%)
- **PriceOracle (Mock)**: Easily swap in Chainlink or another on-chain oracle
- **Deploy Script**: One-click Hardhat deployment of all contracts in order

## Repository Structure

```
contracts/
├─ CollateralVault.sol
├─ PositionManager.sol
├─ LiquidationEngine.sol
└─ interfaces/
 ├─ ICollateralVault.sol
 ├─ IPositionManager.sol
 ├─ ILiquidationEngine.sol
 └─ IPriceOracle.sol

scripts/
└─ deploy.js ← Hardhat deployment script

test/ ← Your unit tests go here
hardhat.config.js ← Hardhat configuration
README.md ← You are here!

```

## Installation

1. **Node.js & npm** (LTS)
2. Clone & install dependencies:
   ```bash
   git clone <your-repo-url>
   cd <repo>
   npm install
   ```

````

## Compilation & Testing

- **Compile** contracts
  ```bash
  npx hardhat compile
  ```
- **Run tests** (Mocha + Chai):
  ```bash
  npx hardhat test
  ```

## Deployment

Deploy to your chosen network (local, testnet, or mainnet):

```bash
node scripts/deploy.js
```

This script will:

1. Fetch your deployer account
2. Deploy `PriceOracle` (mock)
3. Deploy `CollateralVault`
4. Deploy `PositionManager` (max LTV = 75%)
5. Deploy `LiquidationEngine` (bonus = 5%)
6. Print all deployed addresses
````
