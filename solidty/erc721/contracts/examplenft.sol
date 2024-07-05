// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


import "./ERC721.sol";
contract MyNFT is ERC721 {
    constructor() ERC721("MyNFT", "Yay") {
        // mint an NFT to yourself
        mintTo(msg.sender, "rrr");
    }
}

