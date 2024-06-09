// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "../interfaces/IRunePool.sol";
import "../interfaces/IRVersion.sol";

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";


contract RunePool is IRunePool, IRVersion  {

    string constant name = "RESERVED_RUNE_POOL";
    uint256 constant version = 1; 
    address constant NATIVE = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE; 

    address immutable self; 

    address administrator; 

    uint256 [] poolIds; 
    mapping(uint256=>bool) knownPoolId; 
    mapping(uint256=>Pool) poolById; 

    uint256 [] investmentIds; 
    mapping(address=>uint256[]) investmentIdsByOwner; 
    mapping(uint256=>PoolInvestment) poolInvestmentById; 

    address [] loanContracts; 

    constructor(address _admin) {
        administrator = _admin; 
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

    function requestLoan(address _runeAddress, uint256 _runeId, address _loanErc20, uint256 _loanAmount) external returns (address loanContract){
        
    }

    function getLoanContracts() view external returns (address[] memory _loanContracts){
        return loanContracts; 
    }

    function createPool(address _erc20, uint256 _amount, uint256 _poolRate ) external payable returns (Pool memory _pool){
        uint256 poolId_ = getIndex(); 
        transferIn(_erc20, _amount);
        poolById[poolId_] = Pool({
                                    id : poolId_,
                                    erc20 : _erc20,
                                    balance : _amount,
                                    rate : _poolRate
                                 });
        _pool = poolById[poolId_];

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

    function calculateReturn(uint256 _poolRate, uint256 _amount) pure internal returns (uint256 _return) {
        _return  =  SafeMath.div(SafeMath.mul(_amount, (_poolRate + 100)),100 );
        return _return; 
    }
}