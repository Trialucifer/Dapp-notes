//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Test is ERC20 {
    
    error TransferFailed();
    constructor(string memory _name, string memory _symbol) ERC20 ("zbc", "zbc") {}

        function _safeTransfer(address from, address to, uint256 value) public {
        (bool success, bytes memory data) = from.call(abi.encodeWithSignature("transfer(address,uint256)", to, value));
        if(!success || (data.length != 0 && !abi.decode(data,(bool)))) {
        revert TransferFailed();
        }
    }

    function _safeTranfrom(ERC20Test erc20Test, address to, uint256 value) public {
        SafeERC20.safeTransfer(erc20Test, to, value);
    }

    function _safeApprove(ERC20Test erc20Test, address to, uint256 value) public {
     SafeERC20.forceApprove(erc20Test, to, value);
    }
}

