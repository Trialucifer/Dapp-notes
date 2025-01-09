require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-ethers");
require("hardhat-deploy");
require("hardhat-deploy-ethers");
// npm install --save-dev dotenv
require("dotenv").config()
//进行合约验证 npm install --save-dev @nomicfoundation/hardhat-verify
require("@nomicfoundation/hardhat-verify");
//端口代理
const { ProxyAgent, setGlobalDispatcher } = require("undici");
//配置ABI导出 npm install --save-dev hardhat-abi-exporter
require('hardhat-abi-exporter');
require("./task")

const proxyAgent = new ProxyAgent("http://127.0.0.1:7890");//查看自己的代理 修改端口
setGlobalDispatcher(proxyAgent);

const SEPOLIA_TEST_URL = process.env.SEPOLIA_TEST_URL
const AMOY_TEST_URL = process.env.AMOY_TEST_URL
const PRIVATE_TEST_KEY1 = process.env.PRIVATE_TEST_KEY1
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
  mocha: {
    //修改配置等待200秒，默认配置超过40秒就报错
    //即合约部署的时间，一般来说合约部署到测试网不止需要40秒的
    timeout: 300000
 },
 networks: {
   sepolia: {
     //如果要部署真实的测试网，通过第三方服务商拿到免费的url Elchemy,Infura,QuickNode
     url: SEPOLIA_TEST_URL,
     //acounts 钱包私钥
     accounts: [PRIVATE_TEST_KEY1],
     chainId: 11155111,
     blockConfirmations: 6, //交易发送后，经历多少个区块才算成功
     companionNetworks: {
       destChain: "amoy"
     }
   },
   amoy: {
    url: AMOY_TEST_URL,
    accounts: [PRIVATE_TEST_KEY1],
    chainId: 80002,
    blockConfirmations: 6,
    companionNetworks: {
      destChain: "sepolia"
    }
   }
 },
 etherscan: {
   apiKey: {
     //etherscan 进行合约验证是时候用的
     sepolia: ETHERSCAN_API_KEY
   }
 },
 namedAccounts: {
   firstAccount: {
    default: 0
   }
 },
 abiExporter: {
    path: './abis', // ABI导出目录的路径（相对于Hardhat根目录）
    runOnCompile: true, // 是否在编译时自动导出ABI
    clear: true, // 是否在编译时清除旧的ABI文件
    flat: true, // 是否将输出目录扁平化（可能会造成命名冲突）
    only: [], // 选择包含的合约数组
    except: [], // 排除的合约数组
    spacing: 2, // 格式化输出的缩进空格数
    pretty: true // 是否使用接口风格的格式化输出
  }
};
