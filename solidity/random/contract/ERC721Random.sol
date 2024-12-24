// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MyERC721_v3 is ERC721, ERC721Enumerable, ERC721URIStorage{
    uint256 private _nextTokenId;
    // string METADATA_LAZY_PERSON = "ipfs://QmTWLwHvDem1bHF5S86ZmnFzxxjFdwvNeQTFfjeqHetRHx";
    // METADATA
    string constant METADATA_SHIBAINU = "ipfs://QmXw7TEAJWKjKifvLE25Z9yjvowWk2NWY3WgnZPUto9XoA";
    string constant METADATA_HUSKY = "ipfs://QmTFXZBmmnSANGRGhRVoahTTVPJyGaWum8D3YicJQmG97m";
    string constant METADATA_BULLDOG = "ipfs://QmSM5h4WseQWATNhFWeCbqCTAGJCZc11Sa1P5gaXk38ybT";
    string constant METADATA_SHEPHERD = "ipfs://QmRGryH7a1SLyTccZdnatjFpKeaydJcpvQKeQTzQgEp9eK";
    uint256 MAX_AMOUNT = 6;
    //增加白名单，只有一部分人可以执行 preMint
    mapping(address => bool) whiteList;
    bool public preMintWindw = false;
    bool public mintWindow = false;
    address contractOwner;
    event MintUrl(uint256 indexed  _token, uint256 random);


     /**
     * HARDCODED FOR SEPOLIA
     * COORDINATOR: 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625
     */
    constructor() ERC721("MyERC721", "MTK")
    {
        contractOwner = msg.sender;
    }

    modifier contractOnlyOwner() {
        require(contractOwner == msg.sender, "the Caller is not owner");
        _;
    }

    function preMint() public payable {
        //发送交易的人必须支付 0.001
        require(preMintWindw, "Premint is not open it");
        require(msg.value == 0.001 ether, "The price of dog nft is 0.001 ether");
        require(whiteList[msg.sender], "The caller not in the white list");
        require(totalSupply() < MAX_AMOUNT, "Dog NFT is sold out !");
        require(balanceOf(msg.sender) < 1, "Max amout of NFT mintted by an address is 1");
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
        fulfillRandomOnchain(tokenId, getRandomOnchain());
        
    }

    function mint() public payable {
        require(mintWindow, "mint is not open it");
        //发送交易的人必须支付 0.005
        require(msg.value == 0.005 ether, "The price of dog nft is 0.005 ether");
        require(totalSupply() < MAX_AMOUNT, "Dog NFT is sold out !");
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
        fulfillRandomOnchain(tokenId, getRandomOnchain());
    }




     /** 
    * 链上伪随机数生成
    * keccak256(abi.encodePacked()中填上一些链上的全局变量/自定义变量
    * 返回时转换成uint256类型
    */
    function getRandomOnchain() public view returns(uint256){
        /*
         * 本例链上随机只依赖区块哈希，调用者地址，和区块时间，
         * 想提高随机性可以再增加一些属性比如nonce等，但是不能根本上解决安全问题
         */
        bytes32 randomBytes = keccak256(abi.encodePacked(blockhash(block.number-1), msg.sender, block.timestamp));
        return uint256(randomBytes);
    }

    function fulfillRandomOnchain(uint256 tokenId, uint256 random) internal {
        uint256 randomNumber = random % 4;
        if (randomNumber == 0) {
            _setTokenURI(tokenId, METADATA_SHIBAINU);
        }else if (randomNumber == 1) {
            _setTokenURI(tokenId, METADATA_HUSKY);
        }else if (randomNumber == 2) {
            _setTokenURI(tokenId, METADATA_BULLDOG);
        }else { // == 3
            _setTokenURI(tokenId, METADATA_SHEPHERD);
        }
        emit MintUrl(tokenId, randomNumber);
    }


    function addToWhiteList(address[] calldata addrs) public contractOnlyOwner{
        for (uint256 i=0; i<addrs.length; i++) {
            whiteList[addrs[i]] = true;
        }
    }

    function setWindow(bool _preMintWindow, bool _mintWindow) public contractOnlyOwner {
        preMintWindw = _preMintWindow;
        mintWindow = _mintWindow;
    }

    function withDraw(address addr) external contractOnlyOwner {
        payable(addr).transfer(address(this).balance);
    }

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}