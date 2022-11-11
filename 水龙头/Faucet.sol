// SPDX-License-Identifier: MIT
import "../ERC20/IERC20.sol";
pragma solidity ^0.8.4;

contract Faucet{
    uint256 public allowanceA = 100;
    address public tokenContract;
    mapping(address => bool) public requestAddress;
    
    event SendToken(address indexed Receiver, uint256 indexed Amount);

    constructor(address _tokenContract){
        tokenContract = _tokenContract;
    }

    function send() external{
        require( requestAddress[msg.sender] == false ,"The address has get!");
        IERC20 t = IERC20(tokenContract);
        require(t.balanceOf(address(this)) >= allowanceA,"Faucet Empty!");

        t.transfer(msg.sender,allowanceA);
        requestAddress[msg.sender] = true;

        emit SendToken(msg.sender,allowanceA);
    }
}