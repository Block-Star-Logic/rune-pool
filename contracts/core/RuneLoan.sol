// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "../interfaces/IRuneLoan.sol";
import "../interfaces/IRVersion.sol";
import "../interfaces/IRegister.sol";

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract RuneLoan is IRuneLoan, IRVersion { 

    modifier onlyBorrower() {
        require(msg.sender == loan.borrower, "only borrower");
        _;
    }

    modifier onlyRunePool() { 
        require(msg.sender == register.getAddress(RUNE_POOL_CA), "only rune pool");
        _;
    }

    uint256 constant version = 2; 
    string constant name = "RUNE_LOAN"; 

    string constant RUNE_POOL_CA = "RESERVED_RUNE_POOL"; 

    IRegister register; 

    address immutable self; 
    bool NATIVE; 
    bool closed; 
    bool open; 

    Loan loan; 
    uint256 [] investmentIds;
    uint256 [] repaymentIds;
    uint256 [] drawdownIds; 
    mapping(uint256=>Investment) investmentById;
    mapping(uint256=>Repayment) repaymentById; 
    mapping(uint256=>DrawDown) drawdownById; 

    constructor(Loan memory _loan, address _register) { 
        register = IRegister(_register);
        loan = _loan; 
        self = address(this);
        if(loan.erc20 == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE ) {
            NATIVE = true;
        }
        else {
            NATIVE = false; 
        }
    }

    function getVersion() pure external returns (uint256 _version){
        return version; 
    }

    function getName() pure external returns (string memory _name){
        return name; 
    }

    function getLoan() view external returns (Loan memory _loan){
        return loan; 
    }   

    function getInvestmentIds() view external returns (uint256 [] memory _investmentIds){
        return investmentIds; 
    }

    function getRepaymentIds() view external returns (uint256 [] memory _repaymentIds){
        return repaymentIds;
    }

    function getDrawDownIds() view external returns (uint256 [] memory _drawdownIds) {
        return drawdownIds;
    }
    
    function getInvestment(uint256 _investmentId) view external returns (Investment memory _investment){
        return investmentById[_investmentId];
    }

    function getRepayment(uint256 _repaymentId) view external returns (Repayment memory _repayment){
        return repaymentById[_repaymentId];
    }

    function getDrawDown(uint256 _drawdownId) view external returns (DrawDown memory _drawDown){
        return drawdownById[_drawdownId]; 
    }

    function secureCollateral() external onlyRunePool returns (bool _secured) {
        IERC721(loan.collateral.rune).transferFrom(msg.sender, self, loan.collateral.id);
        open = true;
        return true; 
    }

    function invest(uint256 _amount) external payable returns (uint256 _investmentId){
        require(!closed && open, "loan closed");
        require(loan.contributed + _amount <= loan.requirement, "over contribution");
        loan.contributed += _amount; 
        loan.available += _amount;
        
        transferIn(_amount);

        _investmentId = getIndex(); 
        uint256 maxPayout_ = calculateMaxPayout(_amount);
        investmentById[_investmentId] = Investment({
                                                    id : _investmentId, 
                                                    amount : _amount, 
                                                    erc20 : loan.erc20,
                                                    investor : msg.sender,
                                                    maxPayout : maxPayout_,
                                                    outstanding : maxPayout_
                                                    });
        return _investmentId; 
    }   

    function repay(uint256 _amount) external payable returns (uint256 _repaymentId){
        require(!closed && open, "loan closed" );
        transferIn(_amount);
        _repaymentId = getIndex();
        int256 trialBalance_ = int256(loan.outstanding) - int256(_amount); 
        if(trialBalance_ < 0) {
            closeLoan(); 
            uint256 remainder_ = _amount - loan.outstanding; 
            loan.paidBack += loan.outstanding; 
            loan.outstanding = 0; 
            transferOut(msg.sender, remainder_);
            releaseCollateralInternal(); 
            
        }
        else {
            loan.outstanding -= _amount; 
            loan.paidBack += _amount; 
        }

    }

    function drawDown(uint256 _amount) external onlyBorrower returns (uint256 _drawDownId){
        require(!closed, "loan closed");
        require(loan.available >= _amount, "insufficient funds");
        loan.available -= _amount; 
        loan.outstanding += _amount; 
        _drawDownId = getIndex(); 
        drawdownById[_drawDownId] = DrawDown({
                                                id : _drawDownId,
                                                amount : _amount,  
                                                erc20 : loan.erc20,
                                                date : block.timestamp
                                            });
        transferOut(loan.borrower, _amount);
        return _drawDownId;
    }

    //=================================================== INTERNAL================================================

    uint256 index; 

    function getIndex() internal returns (uint256 _index) {
        _index = index++;
        return _index; 
    }

    function calculateMaxPayout(uint256 _amount) view internal returns (uint256 _maxPayout) {
       _maxPayout  =  SafeMath.div(SafeMath.mul(_amount, (loan.interestRate + 100)),100 );
        return _maxPayout;
    }

    function transferOut(address _to, uint256 _amount)  internal returns (bool _success){
        if(NATIVE){
            payable(_to).transfer(_amount);
        }
        else {
            IERC20(loan.erc20).transfer(_to, _amount);
        }
        return true; 
    }

    function transferIn(uint256 _amount) internal returns (bool _success) {
        if(NATIVE){
            require(msg.value >= _amount, "insufficient funds transmitted");
        }
        else {
            IERC20(loan.erc20).transferFrom(msg.sender, self, _amount);
        }
        return true; 
    }

    function closeLoan() internal returns (bool _closed){
        closed = true; 
        return closed; 
    }

    function releaseCollateralInternal() internal returns (bool _released) {
        IERC721(loan.collateral.rune).transferFrom(self, loan.borrower, loan.collateral.id);
        return true; 
    }
}