// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract  ERC20Im {

    string private  _name;
    string private  _symbol;
    uint256 private  _totalsupply;
    mapping  (address => uint256) private balances;
    mapping (address => mapping (address => uint256)) public allowances;


     constructor(string memory nameInput, string memory symbolInput) {
        _name = nameInput;
        _symbol = symbolInput;
    }
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    //Returns the name of the token - e.g. "MyToken".
    function name () public view returns  (string memory){
        return _name;
    }
    //Returns the symbol of the token. E.g. “HIX”.
    function symbol() public  view  returns (string memory){
             return _symbol;
    }

    function decimals() public pure returns (uint8){
        return 18;
    }

    function totalSupply() public view returns (uint256){
        return _totalsupply;
    }

    //Returns the account balance of another account with address _ow
    function balanceOf(address _owner) public view returns (uint256 balance){
        return balances[_owner];
    }
    //
    error insuffientFund();
    function transfer(address _to, uint256 _value) public returns (bool success) {
        
        if (_value > balances[msg.sender] ){
            revert insuffientFund();
        }
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer( msg.sender, _to , _value) ;
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
    {
        if (_value > balances[_from] ){
            revert insuffientFund();
        }
        balances[_from] -= _value;
        balances[_to] += _value;
        emit Transfer(_from, _to , _value) ;
        return true;
    }
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

      function approve(address _spender, uint256 _value) public returns (bool success) {
        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining){
        return allowances[_owner][_spender];
    }


    function mintNewToken (uint256 _value) internal {
    
        //     balances[msg.sender] -= _value;
        // balances[account] += _value;
         _totalsupply += _value;
        //emit Transfer( address(0), account ,_value) ;
           
        
    }

}