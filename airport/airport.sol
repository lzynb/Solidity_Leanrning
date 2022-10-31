// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;  

import "../ERC20/IERC20.sol";
import "../ERC20/ERC20.sol";
contract airport{
    function getSum(uint256[] calldata arr) public pure returns(uint256 sum){
        for(uint i=0;i<arr.length;i++)
            sum = sum+arr[i];
    }

    function multiTransferToken(
        address _token,
        address[] calldata _addresses,
        uint256[] calldata _amounts
        ) external{
        require(_addresses.length == _amounts.length,"the length need sanme");
        IERC20 token = IERC20(_token);
        uint256 sum = getSum(_amounts);
        require(token.allowance(msg.sender,address(this))>sum,"Not enough token allowed");

        for(uint i=0;i<_addresses.length;i++)
            token.transferFrom(msg.sender,_addresses[i],_amounts[i]);
    }
}