// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract Call{
    event Response(bool success,bytes data);

    fallback()  external payable{}

    function callSetX(address payable _addr,uint256 x) public payable{
        (bool success,bytes memory data) = _addr.call{value:msg.value}(
            abi.encodeWithSignature("set_X(uint256)",x)
        );

        emit Response(success,data);
    }

    function callGetX(address _addr) external returns(uint256){
        (bool success,bytes memory data) = _addr.call(
            abi.encodeWithSignature("get_X()")
        );
        
        emit Response(success,data);
        return abi.decode(data,(uint256));
    }


    function callNone(address _addr) external{
        (bool success,bytes memory data) = _addr.call(
            abi.encodeWithSignature("FOO()")
        );

        emit Response(success,data);
    }
}