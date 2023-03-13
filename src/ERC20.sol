// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC20{
    // ERC20 State Variables
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;
    uint256 private _totalSupply;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        _name = "DREAM";
        _symbol = "DRM";
        _decimals = 18;
        _mint(msg.sender, 100 ether);
    }
    
    // ERC20 View area
    function name() public view returns(string memory){
        return _name;
    }
    function symbol() public view returns(string memory){
        return _symbol;
    }
    function decimals() public view returns(uint8){
        return _decimals;
    }
    function totalSupply() public view returns(uint256){
        return _totalSupply;
    }
    function balanceOf(address _owner) public view returns(uint256){
        return balances[_owner];
    }

    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowances[_owner][_spender];
    }

    // ERC20 main
    function transfer(address _to, uint256 _value) external returns (bool succes) {
        require(_to != address(0), "Invalid address");  // zer0 address check
        require(balances[msg.sender] >= _value, "Insufficient balance");    // balance check

        unchecked {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
        }

        emit Transfer(msg.sender, _to, _value);
    }

    function approve(address _spender, uint256 _value) external returns (bool succes) {
        require(_spender != address(0), "Invalid address");  // zer0 address check

        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool succes) {
        require(_from != address(0), "Invalid address");  // zer0 address check
        require(_to != address(0), "Invalid address");  // zer0 address check
        require(balances[_from] >= _value, "Insufficient balance");    // balance check
        require(allowances[_from][msg.sender] >= _value, "Insufficient allowance");    // allowance check

        unchecked {
            balances[_from] -= _value;
            balances[_to] += _value;
            allowances[_from][msg.sender] -= _value;
        }
        emit Transfer(_from, _to, _value);

    }

    function _mint(address _to, uint256 _value) internal {
        require(_to != address(0), "[+] Invalid address");  // zer0 address check
        require(_totalSupply + _value >= _totalSupply, "[+] Mint Overflow Check");    // overflow check

        unchecked {
            balances[_to] += _value;
            _totalSupply += _value;
        }

        emit Transfer(address(0), _to, _value);
    }

    function _burn (address _from, uint256 _value) internal {
        require(_from != address(0), "Invalid address");  // zer0 address check
        require(balances[_from] >= _value, "Insufficient balance");    // balance check
        

        unchecked {
            balances[_from] -= _value;
            _totalSupply -= _value;
        }

        emit Transfer(_from, address(0), _value);
    }

}
