// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IERC165.sol";
import "./IERC721.sol";
import "./IERC721Receiver.sol";
import "./IERC721Metadata.sol";
import "./Address.sol";
import "./String.sol";

contract ERC721 is IERC721,IERC721Metadata{
    using Address for address;
    using Strings for uint256;

    string public override name;    // token名称

    string public override symbol;  // token符号

    mapping(uint=>address) private _owner; // 从 tokenID 到 拥有者 的转换

    mapping(address=>uint) private _balance; // 通过地址查看用户的余额

    mapping(uint=>address) private _tokenApprovals; // 从 tokenID 到 授权地址的转换（授权一个NFT给你）

    mapping(address=>mapping(address=>bool)) private _operatorApprovals; // owner地址 批量授权给 opetator 对象（所有NFT都给你）

    constructor(string memory _name,string memory _symbol){
        name = _name;
        symbol = _symbol;
    }

    // 实现IERC165接口，判断这个合约是否是IERC721,避免转入非法合约而损失
    function supportsInterface(bytes4 interfaceId)external pure override returns(bool){
        return 
            interfaceId == type(IERC721).interfaceId || 
            interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId;
    }

    // 查看余额
    function balanceOf(address owner) external view override returns(uint){
        require(owner != address(0),"owner is zero address");
        return _balance[owner];
    }


    // 查看某个tokenid所有者
    function ownerOf(uint tokenID) public view override returns(address owner){
        owner = _owner[tokenID];
        require(owner != address(0), "token doesn't exist");
    }

    // 查看 操作方 是否被授权
    function isApprovedForAll(address owner,address operater)
        external
        view
        override
        returns(bool)
    {
        return _operatorApprovals[owner][operater];
    }

    // 将所有的代币都授权给operator地址
    function setApprovalForAll(address operater,bool approved)external override{
        _operatorApprovals[msg.sender][operater] = approved;
        emit ApprovalForAll(msg.sender,operater,approved);
    }

    function getApproved(uint tokenID) external view override returns(address){
        require(_owner[tokenID] != address(0),"token  doesn't exist!");
        require(_tokenApprovals[tokenID] != address(0),"token doesn't approve");
        return _tokenApprovals[tokenID];
    }

    function _approve(address owner,address to,uint tokenID)private{
        _tokenApprovals[tokenID] = to;
        emit Approval(owner, to, tokenID);
    }

    function approve(address to,uint tokenID) external override{
        address owner = _owner[tokenID];
        require(msg.sender==owner || _operatorApprovals[owner][msg.sender],"not owner nor approved for all");
        _approve(owner, to, tokenID);        
    }

    function _transfer(address owner,address from,address to, uint tokenID)private{
       require(from == owner,"not owner");
       require(to != address(0),"transfer to the zero address");

        _approve(owner,address(0),tokenID);

        _balance[owner] -= 1;
        _balance[to] += 1;
        _owner[tokenID] = to;

        emit Transfer(from, to, tokenID);
    }

    function transferFrom(address from,address to,uint tokenID) external override{
        address owner = _owner[tokenID];
        require(_isApprovedOrOwner(owner,msg.sender,tokenID),"not owner or approved");
        _transfer(owner,from,to,tokenID);
    }

    // 判断调用方是否可以使用token
    function _isApprovedOrOwner(address owner,address spender,uint tokenID)private view returns(bool){
        return (spender == owner ||
            _tokenApprovals[tokenID] == spender ||
            _operatorApprovals[owner][spender] 
        );
    }


    function _safeTransfer(address owner,address from, address to,uint tokenID,bytes memory _data)private{
        _transfer(owner,from,to,tokenID);
        require(_checkOnERC721Received(from, to, tokenID,_data),"not ERC721Receiver");
    }

    function safeTransferFrom(address from,address to,uint tokenID,bytes memory _data)public override{
        address owner =  ownerOf(tokenID);
        require(_isApprovedOrOwner(owner,from,tokenID),"not owner or approved");
        _safeTransfer(owner,from,to,tokenID,_data);
    }

    
    function safeTransferFrom(address from,address to,uint tokenID) external override{
        safeTransferFrom(from,to,tokenID,"");
    }



    // _checkOnERC721Received：函数，用于在 to 为合约的时候调用IERC721Receiver-onERC721Received, 以防 tokenId 被不小心转入黑洞。
    function _checkOnERC721Received(
        address from,
        address to,
        uint tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            return
                IERC721Receiver(to).onERC721Received(
                    msg.sender,
                    from,
                    tokenId,
                    _data
                ) == IERC721Receiver.onERC721Received.selector;
        } else {
            return true;
        }
    }

    /**
     * 实现IERC721Metadata的tokenURI函数，查询metadata。
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_owner[tokenId] != address(0), "Token Not Exist");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    /**
     * 计算{tokenURI}的BaseURI，tokenURI就是把baseURI和tokenId拼接在一起，需要开发重写。
     * BAYC的baseURI为ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/ 
     */
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }
}