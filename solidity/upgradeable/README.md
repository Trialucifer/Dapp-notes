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
环境安装  
npm install --save-dev @openzeppelin/hardhat-upgrades  
npm install --save-dev @nomicfoundation/hardhat-ethers ethers hardhat-deploy hardhat-deploy-ethers  
npm install @openzeppelin/contracts —save-dev  
npm install --save-dev dotenv  

测试方法

npx hardhat console --network sepolia

# 参考文档

[openzeppelin插件升级](https://docs.openzeppelin.com/upgrades-plugins/1.x/)  
[智能合约升级现状](https://blog.openzeppelin.com/the-state-of-smart-contract-upgrades)
[合约升级实战](https://learnblockchain.cn/article/7907#%E6%8B%9B%E8%81%98%E5%8F%91%E5%B8%83%E6%8E%A5%E5%8F%A3)