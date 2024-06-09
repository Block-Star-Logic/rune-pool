// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import {Investment, Repayment, DrawDown, Loan} from "./IRStructs.sol";

interface IRuneLoan {

    function getLoan() view external returns (Loan memory _loan);

    function getInvestmentIds() view external returns (uint256 [] memory _investmentIds); 

    function getRepaymentIds() view external returns (uint256 [] memory repaymentIds);

    function getDrawDownIds() view external returns (uint256 [] memory _drawdownIds);
    
    function secureCollateral() external returns (bool _secured);
    
    function getInvestment(uint256 _investmentId) view external returns (Investment memory _investment);

    function getRepayment(uint256 _repaymentId) view external returns (Repayment memory _repayment);

    function getDrawDown(uint256 _drawdownId) view external returns (DrawDown memory _drawDown);


    function invest(uint256 _amount) external payable returns (uint256 _investmentId);

    function repay(uint256 _amount) external payable returns (uint256 _repaymentId);

    function drawDown(uint256 _amount) external returns (uint256 _drawDownId);

}