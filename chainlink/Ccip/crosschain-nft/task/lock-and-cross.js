const { task } = require("hardhat/config")
const {networkConfig} = require("../helper-hardhat-config")

task("lock-and-cross")
    .addOptionalParam("chainselector", "chain selector of dest chain") // addOptionalParam 可选的
    .addOptionalParam("receiver", "receiver address on dest chain")
    .addParam("tokenid", "tokenId of nft")  //如果是tokenId ，命令就是 --token-id
    .setAction(async(taskArgs, hre) => {
        let destChainSelector
        let receiver
        const tokenId = taskArgs.tokenid
        let {firstAccount} = await getNamedAccounts()
        
        if(taskArgs.chainselector) {
            destChainSelector = taskArgs.chainselector
        }else {
            destChainSelector = networkConfig[network.config.chainId].destChainSelector
        }
        console.log(`destination chain selector is ${chainselector}`)

        if(taskArgs.receiver) {
            receiver = taskArgs.receiver
        }else {
            const nftPoolBurnAndMint = await hre.companionNetworks["destChain"].deployments.get("NFTPoolBurnAndMint")
            receiver = nftPoolBurnAndMint.address
        }
        console.log(`NFTPoolBurnAndMint address on destination chain is ${receiver}`)

        // tranfer link token to address of the pool
        // const linkTokenAddress = networkConfig[network.config.chainId].linkToken
        // const linkToken = await ethers.getContractAt("LinkToken", linkTokenAddress)
        const nftPoolLockAndRelease = await ethers.getContract("NFTPoolLockAndRelease", firstAccount)
        // const balanceBefore = await linkToken.balanceOf(nftPoolLockAndRelease.target)
        // console.log(`balance before: ${balanceBefore}`)
        // const transerTx = await linkToken.transfer(nftPoolLockAndRelease.target, ethers.parseEther("10"))
        // await transerTx.wait(6)
        // const balanceAfter = await linkToken.balanceOf(nftPoolLockAndRelease.target)
        // console.log(`balance after: ${balanceAfter}`)
        //approve pool address to call transferFrom
        const nft = await ethers.getContract("MyToken", firstAccount)
        await nft.approve(nftPoolLockAndRelease.target, tokenId)
        console.log("approve successfully")

        // call lockAndSendNFT
        console.log(`${tokenId}, ${firstAccount}, ${chainselector}, ${receiver}`)
        const lockAndSendNFTTx = await nftPoolLockAndRelease.lockAndSendNFT(
            tokenId, 
            firstAccount,
            destChainSelector,
            receiver
        )
        await lockAndSendNFTTx.wait(6)
        console.log(`ccip transaction is sent, the tx hash is ${lockAndSendNFTTx.hash}`)
    })

    module.exports = {}

    //检测方法：npx hardhat lock-and-cross --network sepolia --tokenid 0