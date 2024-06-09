
// File: contracts/interfaces/IRVersion.sol



pragma solidity >=0.8.2 <0.9.0;


interface IRVersion  {

    function getVersion() view external returns (uint256 _version);

    function getName() view external returns (string memory _name);

}
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
// File: contracts/interfaces/IRuneLoanFactory.sol



pragma solidity >=0.8.2 <0.9.0;

interface IRuneLoanFactory { 

    function getLoan(Loan memory _loan) external returns (address _runeLoan);

}
// File: contracts/interfaces/IRegister.sol



pragma solidity >=0.8.2 <0.9.0;

interface IRegister {
    
    function getAddress(string memory _name) view external returns (address _address);
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

// File: contracts/core/RuneLoan.sol



pragma solidity >=0.8.2 <0.9.0;

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
// File: contracts/core/RuneLoanFactory.sol



pragma solidity >=0.8.2 <0.9.0;

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