// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "./ERC721Errors.sol";
import "./IERC721Receiver.sol";
contract ERC721 {
    string public name;
    string public symbol;
    
    uint256 public  nextTokenIdToMint;
    address public contractOwner;


    // token id => owner
    mapping (uint256 => address) internal _owners;
    // owner  => number of token owned
    mapping (address => uint256) internal _balances;
    //token id => toapproved address
    // allow an EOA or a contract to transfer a particular token
    mapping(uint256 => address) internal _tokenApprovals;
    // allow an EOA or a contract to transfer any token
    // owners => (isapprovedaddress => true/false)
    mapping(address => mapping(address => bool)) internal _operatorApprovals;
     //token id => token uri
    mapping(uint256 => string) internal _tokenUris;

    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    constructor (string memory _name , string memory _symbol){
        name = _name;
        symbol =_symbol;
        nextTokenIdToMint = 0;
        contractOwner = msg.sender;

    }

    function balanceOf(address _owner) public view returns (uint256){
        if (_owner == address(0)){
            revert ERC721InvalidOwner( _owner);
        }
        return _balances[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address){
        return _owners[_tokenId];
    }

    function tokenURI(uint256 _tokenId) public view returns(string memory) {
        return _tokenUris[_tokenId];
    }

    function totalSupply() public view returns(uint256) {
        return nextTokenIdToMint;
    }
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public payable{
        if (!(ownerOf(_tokenId) == msg.sender || _tokenApprovals[_tokenId] == msg.sender || _operatorApprovals[ownerOf(_tokenId)][msg.sender])) {
            revert ERC721InvalidOwner( msg.sender);
}
        _transfer(_from, _to, _tokenId);
        
       if(!(_checkOnERC721Received(msg.sender,_from, _to, _tokenId, _data))){
            revert ERC721InvalidReceiver(_to);
       }
           
  }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public payable{
            safeTransferFrom(_from, _to, _tokenId, "");
    }

    // 
    function transferFrom(address _from, address _to, uint256 _tokenId) public payable{
        if (!(ownerOf(_tokenId) == msg.sender || _tokenApprovals[_tokenId] == msg.sender || _operatorApprovals[ownerOf(_tokenId)][msg.sender])) {
            revert ERC721InvalidOwner( msg.sender);
            }
        _transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) public payable{
        if (ownerOf(_tokenId) != msg.sender){
            revert ERC721InvalidOwner(msg.sender);
        }
        _tokenApprovals[_tokenId] = _approved;
        emit Approval(ownerOf(_tokenId), _approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) public{
        _operatorApprovals[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) public view returns (address){
            return _tokenApprovals[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator) public view returns (bool){
        return _operatorApprovals[_owner][_operator];
    }
    function mintTo(address _to, string memory _uri) public {
        if (contractOwner != msg.sender){
            revert  ERC721InvalidOwner(msg.sender);
        }
        _owners[nextTokenIdToMint] = _to;
        _balances[_to] += 1;
        _tokenUris[nextTokenIdToMint] = _uri;
        emit Transfer(address(0), _to, nextTokenIdToMint);
        nextTokenIdToMint += 1;
    }

    function _burn(uint256 _tokenId) internal {
       if (ownerOf(_tokenId) != msg.sender){
            revert ERC721InvalidOwner(msg.sender);
        }
        delete _tokenApprovals[_tokenId];
        _balances[msg.sender] -= 1;
        _balances[address(0)] += 1;
        _owners[_tokenId] = address(0);

        emit Transfer(msg.sender, address(0), _tokenId);
    }
   
    // this is a scary function from openzeppelin  I Know said from scratch  but this function is gas efficent  and I explained each line
     function _checkOnERC721Received(
    address operator,
    address from,
    address to,
    uint256 tokenId,
    bytes memory data
    ) internal returns(bool valid){
        // Check if the `to` address is a contract (one the blockhain we have to type of account contracts and EOAs)
        if (to.code.length > 0) {
            // Try calling `onERC721Received` on the `to` address
            try ERC721TokenReceiver(to).onERC721Received(operator, from, tokenId, data) returns (bytes4 retval) {
                // Verify if the return value matches the expected selector
                if (retval != ERC721TokenReceiver.onERC721Received.selector) {
                    // If not, revert the transaction with an error indicating the receiver is invalid
                    valid = false;
                    revert ERC721InvalidReceiver(to);
                
                }
            } catch (bytes memory reason) {
                // If the call failed, check the reason for failure
                if (reason.length == 0) {
                    // If there's no reason, it means the `to` address does not implement the interface
                    valid = false;
                    revert ERC721InvalidReceiver(to);
                } else {
                    // Otherwise, bring up the original revert reason using low-level assembly
                    /// @solidity memory-safe-assembly
                    valid = false;

                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            valid = true;
        }
    }
     function _transfer(address _from, address _to, uint256 _tokenId) internal {
        if (ownerOf(_tokenId) != _from){
            revert ERC721InvalidOwner(_from);
        }
       
        if (_to == address(0)){
            revert ERC721InvalidReceiver( _to);
        }
        delete _tokenApprovals[_tokenId];
        _balances[_from] -= 1;
        _balances[_to] += 1;
        _owners[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }
}
