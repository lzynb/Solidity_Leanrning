// SPDX-License-Identifier: MIT
import '../create/create.sol';
pragma solidity ^0.8.4;  

import './IERC20.sol';
contract ERC20 is IERC20{

    mapping(address => uint256) public override balanceOf; // 账户的余额
    mapping(address => mapping(address => uint256)) public override allowance;

    uint256 public override totalSupply;     // 总供应量

    string public name;  // 名称
    string public symbol; // 符号

    uint8 public decimals = 18; // 小数点的位数

    constructor(string memory name,string memory symbol){
        name = name;
        symbol = symbol;
    }

    // 发起方向recipient转账
    function transfer(address recipient,uint256 amount) external override returns(bool){
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender,recipient,amount);
        return true;
    }

    // 发起方向spender进行授权
    function approve(address spender,uint amount) external override returns(bool){
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender,spender,amount);
        return true;
    }

    // 代币授权转账
    // 像uniswap，我们是先将自己的币授权给uni，然后由uni进行操作
    function transferFrom(address sender,address recipient,uint amount) external override returns(bool){
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender,recipient,amount);
        return true;
    }

    function mint(uint amount) external{
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) external{
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender,address(0),amount);
    }
}