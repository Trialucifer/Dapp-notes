const {ethers, upgrades } = require("hardhat")

async function main() {
    const boxFactory = await ethers.getContractFactory("Box")
    console.log("Box contract is deploying....")
    const box = await upgrades.deployProxy(boxFactory, [70])
    console.log("Box deployed to:", box.target);
}

main().then(() => process.exit(0))
      .catch(error => {
        console.error(error)
        process.exit(1)
      })