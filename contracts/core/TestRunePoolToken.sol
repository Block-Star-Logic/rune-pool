// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract TestRunePoolToken is ERC20,  Ownable{
    constructor(address initialOwner)
        ERC20("TestRunePool", "tRPT")
        Ownable(initialOwner)
    
    {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

}
