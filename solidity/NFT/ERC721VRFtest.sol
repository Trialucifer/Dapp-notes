// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract MyERC721 is ERC721, ERC721Enumerable, ERC721URIStorage,  VRFConsumerBaseV2Plus{
    uint256 private _nextTokenId;
    // string METADATA_LAZY_PERSON = "ipfs://QmTWLwHvDem1bHF5S86ZmnFzxxjFdwvNeQTFfjeqHetRHx";
    //https://ipfs.filebase.io/ipfs/QmXw7TEAJWKjKifvLE25Z9yjvowWk2NWY3WgnZPUto9XoA
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


    //  Chainlink VRF Coordinator 地址:
    address vrfCoordinator = 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B;

    // Your subscription ID.  订阅一个服务，然后存钱进去，再去使用服务
    uint256 s_subscriptionId;

    // The gas lane to use, which specifies the maximum gas price to bump to.
    // For a list of available gas lanes on each network,
    // see https://docs.chain.link/docs/vrf/v2/subscription/supported-networks/#configurations
    bytes32 keyHash =
        0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae;

    // callbackGasLimit gas限制 : 最大 2,500,000
    uint32 callbackGasLimit = 40000;

    // The default is 3, but you can set this higher. 
    // 最小确认块数 : 3 （数字大安全性高，一般填12） 
    //在我们发送请求后，这个请求后面出现3个新的区块，预言机才认为是一个合理的请求
    uint16 requestConfirmations = 3;

    // 一次可以得到的随机数个数 : 最大 500  
    uint32 numWords = 1;

    mapping(uint256 => uint256) reqIdToTokenId;

     /**
     * HARDCODED FOR SEPOLIA
     * COORDINATOR: 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625
     */
    constructor(uint256 subId) ERC721("MyERC721", "MTK") 
    // Ownable(msg.sender)
    VRFConsumerBaseV2Plus(vrfCoordinator)
    {
        s_subscriptionId = subId;
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
        request(tokenId);
        
    }

    function mint() public payable {
        require(mintWindow, "mint is not open it");
        //发送交易的人必须支付 0.005
        require(msg.value == 0.005 ether, "The price of dog nft is 0.005 ether");
        require(totalSupply() < MAX_AMOUNT, "Dog NFT is sold out !");
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
        request(tokenId);
    }

    // Assumes the subscription is funded sufficiently.
    function request(uint256 _tokenId)
        internal  
        returns (uint256 requestId)
    {

        /** 
        * 向VRF合约申请随机数 
        */
       requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: keyHash,
                subId: s_subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                // Set nativePayment to true to pay for VRF requests with Sepolia ETH instead of LINK
                extraArgs: VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({nativePayment: false}))
            })
        );
        reqIdToTokenId[requestId] = _tokenId;
        return requestId;
    }

    /**
     * VRF合约的回调函数，验证随机数有效之后会自动被调用
     * 消耗随机数的逻辑写在这里
     */
    function fulfillRandomWords(
        uint256 _requestId,
        uint256[] calldata randomWords
    ) internal override {
        uint256 randomNumber = randomWords[0] % 4;
         if (randomNumber == 0) {
            _setTokenURI(reqIdToTokenId[_requestId], METADATA_SHIBAINU);
        }else if (randomNumber == 1) {
            _setTokenURI(reqIdToTokenId[_requestId], METADATA_HUSKY);
        }else if (randomNumber == 2) {
            _setTokenURI(reqIdToTokenId[_requestId], METADATA_BULLDOG);
        }else { // == 3
            _setTokenURI(reqIdToTokenId[_requestId], METADATA_SHEPHERD);
        }
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