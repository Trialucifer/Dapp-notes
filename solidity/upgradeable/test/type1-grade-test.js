const {ethers, upgrades} = require("hardhat")
const {assert, expect} = require("chai")
//用来模拟时间流失
const helpers = require("@nomicfoundation/hardhat-network-helpers")

describe("test type1 upgrade contract", function() {
    it("test type1 upgrad", async () => {
        const boxFactory = await ethers.getContractFactory("Box")
        console.log("Box contract is deploying....")
        const box = await upgrades.deployProxy(boxFactory, [70])
        await box.waitForDeployment()
        console.log("Box deployed to:", box.target)

        const boxV2Factory = await ethers.getContractFactory("BoxV2")
        console.log("Upgrading Box...")
        const upgraded = await upgrades.upgradeProxy(box.target, boxV2Factory)
        console.log("Box upgraded: ", upgraded.target)

        await upgraded.increment()
        await new Promise(resolve => setTimeout(resolve, 60 * 1000))
        const getRetTx = await upgraded.retrieve()
        console.log('当前结果是：', getRetTx)
        await expect((await upgraded.retrieve()).toString()).to.equal('71');
    })
})
