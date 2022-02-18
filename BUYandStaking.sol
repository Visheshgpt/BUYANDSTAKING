// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// import "@chainlink/contracts/src/v0.6/interfaces/AggregatorInterface.sol";

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


library SafeMath {
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
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
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
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
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
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
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
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
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
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
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
        require(b != 0, errorMessage);
        return a % b;
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

     /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() internal virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function geUnlockTime() internal view returns (uint256) {
        return _lockTime;
    }

    //Locks the contract for owner for the amount of time provided
    function lock(uint256 time) internal virtual onlyOwner {
        _previousOwner = _owner;
        _owner = address(0);
        _lockTime = block.timestamp + time;
        emit OwnershipTransferred(_owner, address(0));
    }
    
    //Unlocks the contract for owner when _lockTime is exceeds
    function unlock() internal virtual {
        require(_previousOwner == msg.sender, "You don't have permission to unlock");
        require(block.timestamp > _lockTime , "Contract is locked until 7 days");
        emit OwnershipTransferred(_owner, _previousOwner);
        _owner = _previousOwner;
    }
}



contract SolExchange is Context, Ownable {

    IERC20 private token;

    event SolTokensPurchased(
        address account,
        address token,
        uint256 amount,
        uint256 rate
    ); 

    // uint public priceBNBUSD = 40000;        // 400 USD 
    // uint public tokenPrice  = 4000;           //   1 bnb = 4000 token    
     uint public priceBNBUSD = 40000000000;    // 400 USD 
     uint public tokenPrice  = 10;             //0.1  USD    and   ( 0.01 USD = 1 ) 


    uint256 precisonFactor = 100;

    mapping(uint256 => uint256) public stakingPeriodsAPY;
   
    uint256 public totalPurchases;

    struct Purchase {
       address User;
       uint256 investedamount;
       uint256 purchasingTime;
       uint256 lockingPeriod;
       uint256 claimAmount;
       uint256 releaseTime;
       bool staus;
    }

    Purchase[] public purchases;
  
    mapping(address => uint256[]) userPurchases;
    // mapping(uint256 => address) public trackUserwithID;
    // mapping(uint256 => Purchase) public PurchaseDetails;

    constructor(IERC20 _solToken) {
               
        token = _solToken;
                                            
        // priceFeed = AggregatorInterface(0x2514895c72f50D8bd4B4F9b1110F0D6bD2c97526);
                                
        stakingPeriodsAPY[12] = 1000 ;
        stakingPeriodsAPY[18] = 1500 ;
        stakingPeriodsAPY[24] = 2000 ;
        stakingPeriodsAPY[36] = 2750 ;
        stakingPeriodsAPY[48] = 3500;
    }

     
    function BuyandStake(uint256 _lockingTimeinMonths) external payable {

      require (msg.value > getOneTokenPriceinWei(), "PLease But atleast one Token");  
 
      require( _lockingTimeinMonths == 12 || _lockingTimeinMonths == 18 || _lockingTimeinMonths == 24 || _lockingTimeinMonths == 36 || _lockingTimeinMonths >= 48, "Incorrect locking Period" );
 
      uint _amnt = msg.value;
       
      (uint userAllocation) = calculateAmount(_amnt);
       
      uint unstakeTime;
 
      if ( _lockingTimeinMonths == 12 ) {
          unstakeTime = block.timestamp + 365 days; 
      }           
      else if ( _lockingTimeinMonths == 18 ) {
          unstakeTime = block.timestamp + 548 days; 
      }         
      else if ( _lockingTimeinMonths == 24 ) {
          unstakeTime = block.timestamp + 731 days; 
      }  
      else if ( _lockingTimeinMonths == 36 ) {
          unstakeTime = block.timestamp + 1096 days; 
      } 
      else if ( _lockingTimeinMonths >= 48 ) {
          unstakeTime = block.timestamp + 1461 days; 
      }   
      else {
          revert();
      }
     
       uint aprAmount = userAllocation * stakingPeriodsAPY[_lockingTimeinMonths] / 10000;
       uint claimAmount = userAllocation + aprAmount;
                
       Purchase memory userpurchase = Purchase({
          User: msg.sender,
          investedamount: _amnt,
          purchasingTime: block.timestamp,
          lockingPeriod: _lockingTimeinMonths,
          claimAmount: claimAmount,
          releaseTime: unstakeTime,
          staus: false
       });
      
      purchases.push(userpurchase);
      userPurchases[msg.sender].push(totalPurchases);
    //   trackUserwithID[totalPurchases] = msg.sender;
    //   PurchaseDetails[totalPurchases] = userpurchase;
     
      totalPurchases++;
    } 

    
    function trackUserWithID(uint256 _id) public view returns(address) {
        require (_id < totalPurchases, "Invalid Purchase Id");

        Purchase memory pd = purchases[_id];
        return pd.User;
    }

    function getPurchaseDetail(uint256 _id) public view returns(Purchase memory) 
    {
        require (_id < totalPurchases, "Invalid Purchase Id");
        Purchase memory pd = purchases[_id];
        // return (pd.User, pd.investedamount,pd.purchasingTime,pd.lockingPeriod,pd.claimAmount,pd.releaseTime,pd.staus);
        return pd;
    }

    
    function getUserPurchase(address _user) public view returns(uint[] memory) {
       return userPurchases[_user];
    }

    function claim(uint _id) external {
        require (_id < totalPurchases, "Invalid Purchase Id");

        Purchase storage pd = purchases[_id]; 
        require (pd.User == msg.sender, "Caller is not the owner");
        require (pd.staus == false, "Already claim");
        require (pd.releaseTime  < block.timestamp, "Claim time not reached");
        
        require(pd.claimAmount <= token.balanceOf(address(this)), "Insufficient balance in Contract" );

        token.transfer(msg.sender, pd.claimAmount);   
        pd.staus = true;
    }

     


   ////////////////////////////////////////
   //////////////////////     helper Functions
   ////////////////////////////////////////

    function getOneCentsinWei() public view returns(uint256) {
        return (1 ether / priceBNBUSD);
    }

    function convertTokenPricetoCents() public view returns(uint256) {
        return ((tokenPrice * 10 ** 8)/ 100);
    }

    function getOneTokenPriceinWei() public view returns(uint256) {
        return (convertTokenPricetoCents() * getOneCentsinWei());
    }

    function calculateAmount(uint _buyamount) public view returns(uint256) {
             return  (_buyamount * 1 ether)/ getOneTokenPriceinWei() ;
    }

    function changeTokenPrice(uint256 _tp) public {
        tokenPrice = _tp;
    }
 

    function changeBNBUSDPrice(uint256 _newprice) public {
        priceBNBUSD = _newprice * 100000000;
    } 


    function withdrawFunds(uint256 amount) external onlyOwner {
        // This forwards all available gas. Be sure to check the return value!
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed.");
    }


    // function getLatestPriceOfBNBUSD() public view returns (uint256) {
    //     return priceFeed.latestAnswer();
    // }
}

