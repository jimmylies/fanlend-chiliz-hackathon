require("dotenv").config();
require("@nomiclabs/hardhat-ethers");

module.exports = {
  solidity: "0.8.19",
  networks: {
    chiliz: {
      url: process.env.CHIIZ_RPC_URL || "https://rpc.ankr.com/chiliz",
      chainId: 88888,
      accounts: [process.env.PRIVATE_KEY],
    },
    spicy: {
      url: process.env.SPICY_RPC_URL || "https://spicy-rpc.chiliz.com/",
      chainId: 88882,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
};
