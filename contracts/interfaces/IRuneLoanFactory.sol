// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import {Loan} from "./IRStructs.sol";

interface IRuneLoanFactory { 

    function getLoan(Loan memory _loan) external returns (address _runeLoan);

}