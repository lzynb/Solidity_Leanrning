// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract OtherContract{
    uint private _x = 0;

    fallback() external payable{}

    function set_X(uint256 x) external payable{
        _x = x;
    }

    function get_X() external view returns(uint256 x){
        x = _x;
    }
}