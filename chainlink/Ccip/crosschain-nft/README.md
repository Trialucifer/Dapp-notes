# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.js
```
https://docs.chain.link/ccip/tutorials/send-arbitrary-data

# 环境安装

npm install -D @openzeppelin/contracts
npm install -D @chainlink/contracts-ccip

# mock合约

因为需要第三方工具，在本地执行的时候，先用mock合约验证是否异常
https://github.com/smartcontractkit/chainlink-local

npm install -D @chainlink/local

# 测试

npx hardhat test

部署sepolia 
npx hardhat deploy --network sepolia --tags sourcechain
npx hardhat deploy --network amoy --tags destchain
