// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "../interfaces/IRVersion.sol";
import "../interfaces/IRuneLoanFactory.sol";

import "../interfaces/IRegister.sol";

import "./RuneLoan.sol";

contract RuneLoanFactory is IRuneLoanFactory, IRVersion {

    modifier runePoolOnly() {
        require(msg.sender == register.getAddress(RUNE_POOL_CA), "rune pool only");
        _;
    }

    modifier adminOnly() {
        require(msg.sender == register.getAddress(RUNE_ADMIN), "admin only");
        _;
    }

    string constant name = "RESERVED_RUNE_LOAN_FACTORY";
    uint256 constant version = 1; 

    string constant RUNE_POOL_CA = "RESERVED_RUNE_POOL";
    string constant RUNE_ADMIN = "RESERVED_RUNE_ADMIN";

    IRegister register;

    address [] runeLoans; 
    mapping(address=>bool) knownRuneLoan; 


    constructor(address _register) {
        register = IRegister(_register);
    }   

    function getVersion() pure external returns (uint256 _version){
        return version; 
    }

    function getName() pure external returns (string memory _name){
        return name; 
    }

    function getLoan(Loan memory _loan) external runePoolOnly returns (address _runeLoan){
        _runeLoan = address(new RuneLoan(_loan, address(register)));
        runeLoans.push(_runeLoan);
        knownRuneLoan[_runeLoan] = true; 
        return _runeLoan; 
    }
 
    function getRuneLoans() view external adminOnly returns (address [] memory _runeLoans){
        return runeLoans; 
    }

    function isKnownRuneLoan(address _runeLoan) view external returns (bool _isKnown) {
        return knownRuneLoan[_runeLoan];
    }

}