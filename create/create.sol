// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract Pair{
    address public factory;
    address public token1;
    address public token2;

    constructor() payable{
        factory = msg.sender;
    }

    function initialize(address _token1,address _token2) external{
        require(msg.sender == factory);
        token1 = _token1;
        token2 = _token2;
    }

}

contract PairFactory{
    mapping(address => mapping(address => address)) public getPair;
    address[] allPairs;


    function createPair(address token1,address token2) external returns(address pairAddr){
        // 创建新合约
        Pair pair = new Pair();
        // 初始化合约
        pair.initialize(token1,token2);
        // 更新合约地址
        pairAddr = address(pair);
        allPairs.push(pairAddr);
        getPair[token1][token2] = pairAddr;
        getPair[token2][token1] = pairAddr;
    }
}