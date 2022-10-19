// SPDX-License-Identifier: MIT
import '../create/create.sol';
pragma solidity ^0.8.4;  
contract createFactory2{
    mapping(address=>mapping(address=>address)) public getPair;
    

    function create2(address _token1,address _token2) external returns(address pairAddr){
        (address tokenA,address tokenB) = _token1>_token2 ? (_token2,_token1) : (_token1,_token2);
        bytes32 salt = keccak256(abi.encodePacked(tokenA,tokenB));

        Pair pair = new Pair{salt:salt}();

        pair.initialize(tokenA,tokenB);

        pairAddr = address(pair);

        getPair[tokenA][tokenB] = pairAddr;
        getPair[tokenB][tokenA] = pairAddr;
    }
}


