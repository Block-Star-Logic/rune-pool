// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

struct Collateral { 
    address rune; 
    uint256 id; 
}

struct Loan {
    uint256 id; 
    address borrower; 
    uint256 outstanding; 
    uint256 available; 
    uint256 requirement; 
    uint256 contributed;
    uint256 maxPayback; 
    uint256 paidBack;
    uint256 interestRate; 
    address erc20; 
    uint256 startDate; 
    uint256 completionDate; 
    Collateral collateral; 
}

struct Investment { 
    uint256 id; 
    uint256 amount; 
    address erc20; 
    address investor; 
    uint256 maxPayout; 
    uint256 outstanding; 
}

struct Repayment { 
    uint256 id; 
    uint256 amount; 
    address erc20; 
    uint256 date; 

}

struct DrawDown { 
    uint256 id; 
    uint256 amount; 
    address erc20; 
    uint256 date; 
}


struct Pool { 

    uint256 id; 
    address erc20;
    uint256 balance; 
    uint256 rate; 
}

struct PoolInvestment {
    uint256 id; 
    uint256 amount; 
    address erc20; 
    uint256 poolId; 
    uint256 outstanding; 
    address investor; 
    uint256 date; 
}