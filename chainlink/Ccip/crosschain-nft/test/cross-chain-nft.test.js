const {getNamedAccounts, ethers, deployments} = require("hardhat")
const {assert, expect} = require("chai")

let firstAccount
let ccipSimulator
let nft
let nftPoolLockAndRelease
let wnft
let nftPoolBurnAndMint
let destChainSelector

before(async function () {
    firstAccount = (await getNamedAccounts()).firstAccount;
    await deployments.fixture(["all"])
    ccipSimulator = await ethers.getContract("CCIPLocalSimulator", firstAccount)
    nft = await ethers.getContract("MyToken", firstAccount);
    nftPoolLockAndRelease = await ethers.getContract("NFTPoolLockAndRelease", firstAccount)
    wnft = await ethers.getContract("WrappedMyToken", firstAccount)
    nftPoolBurnAndMint = await ethers.getContract("NFTPoolBurnAndMint", firstAccount)
    destChainSelector = (await ccipSimulator.configuration()).chainSelector_
})

describe("source chain -> dest chain test", async function () {
    it("test if user can mit a nft from nft contract successfully", async function() {
        await nft.safeMint(firstAccount)
        const owner = await nft.ownerOf(0)
        expect(owner).to.equal(firstAccount)
    })
})

describe("test if the nft can be locked and transferred to destchain", 
    async function() {
        it("transfer NFT from source chain to dest chain, check if the nft is locked", async function() {
            await nft.approve(nftPoolLockAndRelease.target, 0)
            //mock合约给 nftPoolLockAndRelease 10 link
            await ccipSimulator.requestLinkFromFaucet(nftPoolLockAndRelease.target, ethers.parseEther("10"))
            await nftPoolLockAndRelease.lockAndSendNFT(0, firstAccount, destChainSelector, nftPoolBurnAndMint.target)
            //check if owner of ntf is pool's address
            const newOwner = await nft.ownerOf(0)
            expect(newOwner).to.equal(nftPoolLockAndRelease.target)
        })

        it("check if wnft's account is onwer", async function() {
            const newOwner = await wnft.ownerOf(0)
            expect(newOwner).to.equal(firstAccount)
        })
    }
)

describe("test if the nft can be burned and transferred back to sourcechain",
    async function() {
        it("wnft can be burn", async function () {
            await ccipSimulator.requestLinkFromFaucet(nftPoolBurnAndMint.target, ethers.parseEther("10"))
            await wnft.approve(nftPoolBurnAndMint.target, 0)
            await nftPoolBurnAndMint.burnAndSendNFT(0, firstAccount, destChainSelector, nftPoolLockAndRelease.target)
            const wnftTotalSupply = await wnft.totalSupply()
            expect(wnftTotalSupply).to.equal(0)
        })

        it("owner of the NFT is transferred t0 firstAccount", async function () {
            const newOwner = await nft.ownerOf(0)
            expect(newOwner).to.equal(firstAccount)
        })
    }
)




