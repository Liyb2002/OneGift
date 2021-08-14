pragma solidity 0.6.10;

import './libraries/ERC20.sol';

contract techX is ERC20 {

    string public constant name = "OGift";
    uint8 public constant decimals = 18;
    string public constant symbol = "OGift";
    uint public constant supply = 1 * 10**8 * 10**uint(decimals); // 100 million


    constructor() public {
        _balances[msg.sender] = supply;
        _totalSupply = supply;
    }
    
}