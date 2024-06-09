// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "../interfaces/IRunePool.sol";
import "../interfaces/IRVersion.sol";
import "../interfaces/IRegister.sol";
import "../interfaces/IRuneLoanFactory.sol";
import "../interfaces/IRuneLoan.sol";

import {Loan, Collateral} from "../interfaces/IRStructs.sol";

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";


contract RunePool is IRunePool, IRVersion  {

    string constant name = "RESERVED_RUNE_POOL";
    uint256 constant version = 1; 
    address constant NATIVE = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE; 
    string constant RUNE_LOAN_FACTORY_CA = "RESERVED_RUNE_LOAN_FACTORY";

    address immutable self; 

    uint256 Standard_Rate = 10; // 10%
    uint256 Standard_Duration = 60*60*24*30; // 30 days

    IRegister register; 

    uint256 [] poolIds; 
    mapping(uint256=>bool) knownPoolId; 
    mapping(uint256=>Pool) poolById; 
    mapping(address=>uint256) poolIdByErc20;
    mapping(address=>bool) hasPool;

    uint256 [] investmentIds; 
    mapping(address=>uint256[]) investmentIdsByOwner; 
    mapping(uint256=>PoolInvestment) poolInvestmentById; 

    address [] loanContracts; 

    constructor(address _register) {
        register = IRegister(_register);
        self = address(this);
    }
    
    function getVersion() pure external returns (uint256 _version){
        return version; 
    }

    function getName() pure external returns (string memory _name){
        return name; 
    }

    function getPoolIds() view external returns (uint256 [] memory _poolIds){
        return poolIds; 
    }

    function getPool(uint256 _id) view external returns (Pool memory _pool){
        return poolById[_id];
    }   

    function requestLoan(address _runeAddress, uint256 _runeId, address _loanErc20, uint256 _loanAmount) external returns (address _loanContract){
        require(hasPool[_loanErc20], "no pool available for token");
        transferRuneIn(_runeAddress, _runeId);
        Loan memory loan_ = Loan({
                                    id : getIndex(),
                                    borrower : msg.sender, 
                                    outstanding : 0,
                                    available : 0,
                                    requirement : _loanAmount,
                                    contributed : 0,
                                    maxPayback : calculateMaxPayback(Standard_Rate, _loanAmount),
                                    paidBack : 0,
                                    interestRate : Standard_Rate,
                                    erc20 : _loanErc20,
                                    startDate : block.timestamp,
                                    completionDate : block.timestamp + Standard_Duration,
                                    collateral : Collateral({
                                                                rune : _runeAddress,
                                                                id : _runeId
                                                            }) 
                                });
        _loanContract = IRuneLoanFactory(register.getAddress(RUNE_LOAN_FACTORY_CA)).getLoan(loan_);
        IERC721(_runeAddress).approve(_loanContract, _runeId);
        IRuneLoan rLoan_ = IRuneLoan(_loanContract);
        rLoan_.secureCollateral(); 

        loanContracts.push(_loanContract);
        uint256 poolId_ = poolIdByErc20[_loanErc20] ; 
        if(poolById[poolId_].balance > 0){
            lend(poolId_, _loanContract);
        }

        return _loanContract; 

    }

    function lend(uint256 poolId_, address _loanContract) internal returns (bool _success) {
        IRuneLoan rLoan_ = IRuneLoan(_loanContract);
        Loan memory loan_ = rLoan_.getLoan(); 
        uint256 lending_ = SafeMath.div(loan_.requirement, 2); 
        int256 trialBalance_ = int256(poolById[poolId_].balance) - int256(lending_);
        uint256 toLend_ = 0; 
        if(trialBalance_ < 0) {
            toLend_ = poolById[poolId_].balance;
            poolById[poolId_].balance = 0; 
        }
        else {
            toLend_ = lending_; 
        }
        rLoan_.invest(toLend_);
        return true; 
    }



    function getLoanContracts() view external returns (address[] memory _loanContracts){
        return loanContracts; 
    }

    function createPool(address _erc20, uint256 _amount, uint256 _poolRate ) external payable returns (Pool memory _pool){
        require(!hasPool[_erc20], "pool already created");
        uint256 poolId_ = getIndex(); 
        transferIn(_erc20, _amount);
        poolById[poolId_] = Pool({
                                    id : poolId_,
                                    erc20 : _erc20,
                                    balance : _amount,
                                    rate : _poolRate
                                 });
        _pool = poolById[poolId_];
        poolIdByErc20[_erc20] = poolId_; 
        return poolById[poolId_];
    }

    function getPoolInvestmentIds() view external returns (uint256 [] memory _poolInvestmentIds){
        return investmentIds; 
    }

    function getPoolInvestment(uint256 _poolInvestmentId) view external returns (PoolInvestment memory _poolInvestment){
        return poolInvestmentById[_poolInvestmentId];
    }


    function invest(uint256 _poolId, uint256 _amount) external payable returns (uint256 _poolInvestmentId){
        require(knownPoolId[_poolId], "unknown pool id");
        transferIn( poolById[_poolId].erc20, _amount);
        poolById[_poolId].balance += _amount; 
        _poolInvestmentId = getIndex(); 

        poolInvestmentById[_poolInvestmentId] = PoolInvestment({
                                                                    id : _poolInvestmentId, 
                                                                    amount : _amount, 
                                                                    erc20 : poolById[_poolId].erc20,
                                                                    poolId : _poolId, 
                                                                    outstanding : calculateReturn(poolById[_poolId].rate,_amount),
                                                                    investor : msg.sender, 
                                                                    date : block.timestamp
                                                                });
        return _poolInvestmentId; 
    }

    //=============================================== INVESTMENT ===========================================================
    uint256 index; 

    function getIndex() internal returns (uint256 _index)  {
        _index = index++; 
        return _index; 
    }

    function transferRuneIn(address _rune, uint256 _id) internal returns (bool _success) {
        IERC721(_rune).transferFrom(msg.sender, self, _id);
        return true; 
    }

    function transferOut(address _to, address _erc20, uint256 _amount)  internal returns (bool _success){
        if(NATIVE == _erc20){
            payable(_to).transfer(_amount);
        }
        else {
            IERC20(_erc20).transfer(_to, _amount);
        }
        return true; 
    }

    function transferIn(address _erc20, uint256 _amount) internal returns (bool _success) {
        if(NATIVE == _erc20){
            require(msg.value >= _amount, "insufficient funds transmitted");
        }
        else {
            IERC20(_erc20).transferFrom(msg.sender, self, _amount);
        }
        return true; 
    }

    function calculateMaxPayback(uint256 _rate, uint256 _amount) pure internal returns (uint256 _payback) {
         _payback  =  SafeMath.div(SafeMath.mul(_amount, (_rate + 100)),100 );
        return _payback; 
    }

    function calculateReturn(uint256 _poolRate, uint256 _amount) pure internal returns (uint256 _return) {
        _return  =  SafeMath.div(SafeMath.mul(_amount, (_poolRate + 100)),100 );
        return _return; 
    }
}