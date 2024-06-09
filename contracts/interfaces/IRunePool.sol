// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import {Pool, PoolInvestment} from "./IRStructs.sol";

interface IRunePool { 

    function getPoolIds() view external returns (uint256 [] memory _poolIds);

    function getPool(uint256 _id) view external returns (Pool memory _pool);

    function requestLoan(address _runeAddress, uint256 _runeId, address _loanErc20, uint256 _loanAmount) external returns (address loanContract);

    function getLoanContracts() view external returns (address[] memory _loanContracts);

    function createPool(address _erc20, uint256 _amount, uint256 _poolRate) external payable returns (Pool memory _pool);

    function getPoolInvestmentIds() view external returns (uint256 [] memory _poolInvestmentIds);

    function getPoolInvestment(uint256 _poolInvestmentId) view external returns (PoolInvestment memory _poolInvestment);

    function invest(uint256 _poolId, uint256 _amount) external payable returns (uint256 _poolInvestmentId);

}