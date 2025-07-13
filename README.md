![FanLend](frontend/src/assets/FanLend_logo.png)

# FanLend - A Chiliz Fan Token Lending & Borrowing Protocol

A decentralized lending & borrowing ecosystem on the Chiliz Chain, tailored specifically for sports fan tokens. This protocol enables margin trading—both long and short positions—against stablecoins, unlocking deeper liquidity, advanced risk management tools, and new revenue opportunities for fans, traders, and clubs.

---

## 📂 Repository Structure

├── whitepaper/
│ └── Chiliz-Fan-Token-Lending-Borrowing-Protocol.pdf
├── contracts/
│ ├── CollateralVault.sol
│ ├── PositionManager.sol
│ ├── LiquidationEngine.sol
│ ├── interfaces/
├── frontend/
│ ├── src/
│ │ ├── components/
│ │ ├── pages/
│ │ └── utils/
│ ├── public/
│ ├── package.json
│ └── tailwind.config.js
├── .gitignore
├── README.md
└── LICENSE

---

## 🚀 Key Features

- **Lending Pool**  
  Deposit stablecoins (CHZ, USDC, DAI) to earn variable APY, paid in both interest and protocol governance token (LEND).

- **Long & Short Margin Trading**

  - **Longs:** Use fan tokens as collateral to borrow stablecoins, repurchase tokens, and profit from price rises.
  - **Shorts:** Deposit stablecoins to borrow fan tokens, sell immediately, and profit from price falls.

- **Automated Liquidations**  
  Real-time collateral monitoring via Chainlink + SportFi oracles; under-collateralized positions are auctioned to maintain protocol solvency.

- **Governance & Incentives**

  - **LEND Token:** 120M total supply; earn LEND through lending, borrowing rebates, and staking.
  - **Dynamic Fees & Rewards:** Borrowing fees 0.03–0.07% per block; rebates and boosted yields on match days.

- **Modular Architecture**  
  Smart contracts are split across vaults, position manager, liquidation engine, and oracle integration for extensibility and ease of audit.

---

## 📖 Documentation

- **Whitepaper**  
  Detailed protocol design, tokenomics, market opportunity, and go-to-market strategy can be found in `whitepaper/Chiliz-Fan-Token-Lending-Borrowing-Protocol.pdf`.

- **Contract Specs**  
  Each contract in `contracts/` includes NatSpec comments and interface definitions for easy reference.

- **Frontend UX Flow**  
  The `frontend/` directory contains React + TailwindUI code for deposit/borrow dashboards, margin trading interfaces, and governance voting modules.

## ❤️ Acknowledgments

Built on the Chiliz Chain
Thanks to Chiliz for help during hackathon
Supported by the community of sports fans, traders, and developers
