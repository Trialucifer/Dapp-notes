const {ethers, network } = require("hardhat");
const {devlopmentChains, networkConfig} = require("../helper-hardhat-config")

module.exports = async({getNamedAccounts, deployments}) => {
    const {firstAccount} = await getNamedAccounts();
    const {deploy, log} = deployments;
    log("NFTPoolBurnAndMint deploying...")

    let ccipSimulatorDeployment
    let ccipSimulator
    let destRouter
    let linkTokenAddr
    if(devlopmentChains.includes(network.name)) {
         //address _router, address _link, address nftAddress
        ccipSimulatorDeployment = await deployments.get("CCIPLocalSimulator")
        ccipSimulator = await ethers.getContractAt("CCIPLocalSimulator", ccipSimulatorDeployment.address)
        const ccipConfig = await ccipSimulator.configuration()
        destRouter = ccipConfig.destinationRouter_
        linkTokenAddr = ccipConfig.linkToken_
    }else {
        destRouter = networkConfig[network.config.chainId].router
        linkTokenAddr = networkConfig[network.config.chainId].linkToken
    }
    const wnftDeployment = await deployments.get("WrappedMyToken")
    const wnftAddr = wnftDeployment.address
    await deploy("NFTPoolBurnAndMint", {
        from: firstAccount,
        log: true,
        args: [destRouter, linkTokenAddr, wnftAddr]
    })
    log("NFTPoolBurnAndMint deployed successfully")
}

module.exports.tags = ["destchain", "all"]