// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Burnable, Ownable {
    uint256 private _nextTokenId;
    // string METADATA_LAZY_PERSON = "ipfs://QmTWLwHvDem1bHF5S86ZmnFzxxjFdwvNeQTFfjeqHetRHx";
    //https://ipfs.filebase.io/ipfs/QmXw7TEAJWKjKifvLE25Z9yjvowWk2NWY3WgnZPUto9XoA
    // METADATA
    string constant METADATA_SHIBAINU = "ipfs://QmXw7TEAJWKjKifvLE25Z9yjvowWk2NWY3WgnZPUto9XoA";
    string constant METADATA_HUSKY = "ipfs://QmTFXZBmmnSANGRGhRVoahTTVPJyGaWum8D3YicJQmG97m";
    string constant METADATA_BULLDOG = "ipfs://QmSM5h4WseQWATNhFWeCbqCTAGJCZc11Sa1P5gaXk38ybT";
    string constant METADATA_SHEPHERD = "ipfs://QmRGryH7a1SLyTccZdnatjFpKeaydJcpvQKeQTzQgEp9eK";

    constructor(string memory tokenName, string memory tokenSymbol)
        ERC721(tokenName, tokenSymbol)
        Ownable(msg.sender)
    {}

    function safeMint(address to)
        public
    {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, METADATA_SHIBAINU);
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