// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

/// this interface ensures that the contract we are sending nft to 
/// can actually receive nft so that the NFT won't be lost forever 
interface ERC721TokenReceiver {

     function onERC721Received(
        address _operator, 
        address _from, uint256
        _tokenId, bytes memory _data) 
     external returns(bytes4);
}

    
