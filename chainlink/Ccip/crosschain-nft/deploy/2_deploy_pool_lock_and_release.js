const {ethers, network } = require("hardhat");
const {devlopmentChains, networkConfig} = require("../helper-hardhat-config")

module.exports = async({getNamedAccounts, deployments}) => {
    const {firstAccount} = await getNamedAccounts();
    const {deploy, log} = deployments;
    log("NFTPoolLockAndRelease deploying...")

    let ccipSimulatorDeployment
    let ccipSimulator
    let sourceRouter
    let linkTokenAddr
    if(devlopmentChains.includes(network.name)) {
        ccipSimulatorDeployment = await deployments.get("CCIPLocalSimulator")
        ccipSimulator = await ethers.getContractAt("CCIPLocalSimulator", ccipSimulatorDeployment.address)
        const ccipConfig = await ccipSimulator.configuration()
        sourceRouter = ccipConfig.sourceRouter_
        linkTokenAddr = ccipConfig.linkToken_
    }else {
        sourceRouter = networkConfig[network.config.chainId].router
        linkTokenAddr = networkConfig[network.config.chainId].linkToken
    }

    const nftDeployment = await deployments.get("MyToken")
    const nftAddr = nftDeployment.address
    await deploy("NFTPoolLockAndRelease", {
        from: firstAccount,
        log: true,
        args: [sourceRouter, linkTokenAddr, nftAddr]
    })
    log("NFTPoolLockAndRelease deployed successfully")
}

module.exports.tags = ["sourcechain", "all"]