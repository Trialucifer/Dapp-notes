require("@nomicfoundation/hardhat-toolbox");
require('@openzeppelin/hardhat-upgrades');
require("dotenv").config()

const SEPOLIA_TEST_URL = process.env.SEPOLIA_TEST_URL
const PRIVATE_TEST_KEY1 = process.env.PRIVATE_TEST_KEY1

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
  mocha: {
    timeout: 300000
  },
  networks: {
    sepolia: {
      url: SEPOLIA_TEST_URL,
      accounts: [PRIVATE_TEST_KEY1],
      chainId: 11155111
    }
  }
};
