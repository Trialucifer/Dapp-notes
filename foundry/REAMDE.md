[安装地址](https://getfoundry.sh/)
[Foundry 中文文档 | 登链社区](https://learnblockchain.cn/docs/foundry/i18n/zh/index.html)

# 执行命令

## forge
初始化新项目：forge init --force  
构建项目：forge build  
运行测试：forge test / forge test --mt testContractOwner 测试某一个函数  
测试覆盖率：forge coverage  
安装 openzeppelin：forge install OpenZeppelin/openzeppelin-contracts --no-git  
forge install foundry-rs/forge-std --no-commit  


### 本地部署和验证

创建 .env文件
开启一个新的窗口，执行 anvil
然后拿到测试环境的账号和地址添加到 env文件中

```
OWNER_PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
OWNER_PUBLIC_KEY=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266

USER_PRIVATE_KEY=0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d
USER_PUBLIC_KEY=0x70997970C51812dc3A010C7d01b50e0d17dc79C8
```
部署命令是：forge create --private-key ${OWNER_PRIVATE_KEY} --broadcast src/FundMe.sol:FundMe --constructor-args 100 ${SEPOLIA_ETH_USD_DATA_FEED}
注意：如果构造函数有多个参数，就用空格隔开

发送请求
cast send ${LOCK_FUND_ADDR} "fund()" --value 0.5ether --private-key ${OWNER_PRIVATE_KEY}
cast send ${LOCK_FUND_ADDR} "refund()" --private-key ${OWNER_PRIVATE_KEY}
cast send ${LOCK_FUND_ADDR} "fund()" --value 0.5ether --private-key ${OWNER_PRIVATE_KEY}
cast send ${LOCK_FUND_ADDR} "transfer(address, uint256)" ${USER_ADDRESS}, 1000000000000000000 --private-key ${OWNER_PRIVATE_KEY}

查看异常问题
如果报错信息是 Error: server returned an error response: error code 3: execution reverted: custom error 6x118cdaa7: 0000000000
可以执行 forge selectors find 6x118cdaa7

### 测试部署和验证

forge create --rpc-url <your_rpc_url> \
    --constructor-args "ForgeUSD" "FUSD" 18 1000000000000000000000 \
    --private-key <your_private_key> \
    --etherscan-api-key <your_etherscan_api_key> \
    --verify \
    src/MyToken.sol:MyToken
