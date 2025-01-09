module.exports = async({getNamedAccounts, deployments}) => {
    const {firstAccount} = await getNamedAccounts();
    const {deploy, log} = deployments

    log("Deploying nft contract")
    await deploy("MyToken", {
        contract: "MyToken",
        from: firstAccount,
        log: true,
        args: ["MyToken", "MT"]
    })

    log("nft contract deployed successfuully")
}
module.exports.tags = ["sourcechain", "all"]