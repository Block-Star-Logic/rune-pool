
// File: contracts/interfaces/IRStructs.sol



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
// File: contracts/interfaces/IRunePool.sol



pragma solidity >=0.8.2 <0.9.0;

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
// File: contracts/interfaces/IRVersion.sol



pragma solidity >=0.8.2 <0.9.0;


interface IRVersion  {

    function getVersion() view external returns (uint256 _version);

    function getName() view external returns (string memory _name);

}
// File: contracts/interfaces/IRegister.sol



pragma solidity >=0.8.2 <0.9.0;

interface IRegister {
    
    function getAddress(string memory _name) view external returns (address _address);
}
// File: contracts/interfaces/IRuneLoanFactory.sol



pragma solidity >=0.8.2 <0.9.0;

interface IRuneLoanFactory { 

    function getLoan(Loan memory _loan) external returns (address _runeLoan);

}
// File: contracts/interfaces/IRuneLoan.sol



pragma solidity >=0.8.2 <0.9.0;

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
// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.20;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// File: @openzeppelin/contracts/interfaces/IERC20.sol


// OpenZeppelin Contracts (last updated v5.0.0) (interfaces/IERC20.sol)

pragma solidity ^0.8.20;


// File: @openzeppelin/contracts/utils/introspection/IERC165.sol


// OpenZeppelin Contracts (last updated v5.0.0) (utils/introspection/IERC165.sol)

pragma solidity ^0.8.20;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: @openzeppelin/contracts/token/ERC721/IERC721.sol


// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.20;


/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon
     *   a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or
     *   {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon
     *   a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the address zero.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

// File: @openzeppelin/contracts/interfaces/IERC721.sol


// OpenZeppelin Contracts (last updated v5.0.0) (interfaces/IERC721.sol)

pragma solidity ^0.8.20;


// File: @openzeppelin/contracts/utils/math/SafeMath.sol


// OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)

pragma solidity ^0.8.0;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

// File: contracts/core/RunePool.sol



pragma solidity >=0.8.2 <0.9.0;


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