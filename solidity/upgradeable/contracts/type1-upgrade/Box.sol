// contracts/Box.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract Box is Initializable {
    uint256 private _value;

    //initializer 保证只初始化一次
    function initialize(uint256 value) public initializer {
        _value = value;
    }

    // Emitted when the stored value changes
    event ValueChanged(address _addr, uint256 indexed value);

    // Stores a new value in the contract
    function store(uint256 value) public {
        _value = value;
        emit ValueChanged(msg.sender, value);
    }

    // Reads the last stored value
    function retrieve() public view returns (uint256) {
        return _value;
    }
}
