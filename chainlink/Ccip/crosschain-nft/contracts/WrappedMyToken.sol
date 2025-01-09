// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {MyToken} from "./MyToken.sol";

contract WrappedMyToken is MyToken {

    constructor(string memory tokenName, string memory tokenSymbol) 
        MyToken(tokenName, tokenSymbol) 
    {}

    //想要去跨链的人不确定，可能是第一个人也有可能是第十个人想去跨链，所以这里tokenId不能用自增
    //生产中，这里需要加个权限控制，比如智能有CCIP调用，或者加个白名单
    function mintTokenWithSpecificTokenId(address to, uint256 tokenId) public {
        _safeMint(to, tokenId);
    }


}


