//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract ERC20PermitTest is ERC20Permit {

    mapping (address => uint) public staked;

    address public token;

    constructor(address _token) {
        token = _token;
    }

    function permitStake(address user, uint amount, uint deadline, uint8 v, bytes32 r, bytes32 s) public {
        permit(msg.sender, address(this), amount, deadline, v , r, s);
        state(user, amount);
    }

    function state(address user, uint amount) public {
        require(IERC20(token).transferFrom(msg.sender, address(this), amount), "Transfer is failed");
        staked[user] += amount;
    }

}