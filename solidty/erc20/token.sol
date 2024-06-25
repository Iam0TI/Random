// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./ERC20.sol";

contract LW3Token is ERC20Im {
    constructor(string memory _name, string memory _symbol) ERC20Im(_name, _symbol) {
         mintNewToken( 10000000 * 10 ** 18);
    }
}