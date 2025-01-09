const { network } = require("hardhat");
const {devlopmentChains} = require("../helper-hardhat-config")
module.exports = async({getNamedAccounts, deployments}) => {
    const {firstAccount} = await getNamedAccounts();
    const {deploy, log} = deployments

    if(devlopmentChains.includes(network.name)) {
        log("Deploying CCIP Simulator contract")
        await deploy("CCIPLocalSimulator", {
            contract: "CCIPLocalSimulator",
            from: firstAccount,
            log: true,
            args: []
        })
    
        log("CCIP Simulator contract deployed successfuully")
    }else {
        console.log("envrionment is not local, mock contract is skipp....")
    }
   
}
module.exports.tags = ["test", "all"]