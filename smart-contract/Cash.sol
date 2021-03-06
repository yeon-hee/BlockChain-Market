// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.7.0;

import "./SafeMath.sol";

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/** 
 * @author doey
 * @title Cash
 * @notice Cash follows the erc20 standard and is used in the ecommerce service.
 */
contract Cash is IERC20{
    
    using SafeMath for uint256;
    
    string public constant _name = "Cash";		
    string public constant _symbol = "C";			
    uint8 public constant _decimals = 0;	
    
    address payable public minter;
    mapping (address => uint256) private balances;
    mapping (address => mapping(address => uint256)) private allowed;  
    uint256 public _totalSupply;

    /**
     * @notice constructor
     * totalSupply(inital supply), minter(owner)
     */
    constructor() public {
        _totalSupply = 10 ** 7; // initial supply
        minter = msg.sender;
        balances[minter] = _totalSupply;
    }
    
    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }
    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    /**
    * @dev Total number of tokens in existence
    */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    
    /**
     * @notice mint
     * @param _receiver the receiver's address
     * @param _amount the amount of tokens
     */
    function mint(address _receiver, uint256 _amount) external {
        require(msg.sender == minter);
        require(_amount < 1e60);
        balances[_receiver] = balances[_receiver].add(_amount);
        _totalSupply = _totalSupply.add(_amount);
    }
    
    /**
     * @notice retrieves the balance that the account has
     * @param _account address
     * @return balance 
     */
    function balanceOf(address _account) external view returns (uint)		
    {
         return balances[_account];
    }
    
    /**
     * @notice transfers the amount of token to the recipient
     * @param _recipient the receiver's address
     * @param _amount the amount of tokens
     * @return success or failure
     */
    function transfer(address _recipient, uint _amount) external returns (bool)
    {
        require(_amount > 0 && balances[msg.sender] >=_amount, "Insufficient balance.");
        balances[msg.sender] = balances[msg.sender].sub(_amount);		 
        balances[_recipient] = balances[_recipient].add(_amount);	
        emit Transfer(msg.sender, _recipient, _amount);	  
        return true;
    }

    /**
     * @notice retrieves the delegated balance 
     * @param _owner the onwer's address
     * @param _spender the delegator's address
     * @return the amount of allownace
     */
    function allowance(address _owner, address _spender) external view returns (uint)
    {
        return allowed[_owner][_spender];	
    }  

    /**
     * @notice delegate the transfer
     * @param _spender the delegator's address
     * @param _amount the allowed amount of tokens
     * @return success or failure
     */    
    function approve(address _spender, uint _amount) external returns (bool)
    {
        require(_amount > 0 && balances[msg.sender] >=_amount, "Insufficient balance.");
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_amount);				
        emit Approval(msg.sender, _spender, _amount);			
        return true;
    }
    
    /**
     * @notice transfers the amount of token on behalf of the owner
     * @param _sender the sender's address
     * @param _recipient the receiver's address
     * @param _amount the amount of tokens
     * @return success of failure
     */     
    function transferFrom(address _sender, address _recipient, uint _amount) external returns (bool)
    {
        require(_amount > 0, "Wrong amount of cash.");
        require(balances[_sender] >=_amount, "Insufficient balance.");
        require(allowed[_sender][msg.sender] >= _amount, "Insufficient allowance");
        
        allowed[_sender][msg.sender] = allowed[_sender][msg.sender].sub(_amount);			    
        balances[_sender] = balances[_sender].sub(_amount);					                    
        balances[_recipient] = balances[_recipient].add(_amount);				                            
        emit Transfer(msg.sender, _recipient, _amount);					
        return true;
    }

    /**
     * @notice buy tokens
     * msg.value should be greater than or equal to 0.1 ether
     * 1 eth = 100,000 cash
     * @return success or failure
     */      
    function buy() public payable returns(bool){
        require(msg.sender != minter);
        require(msg.value >= 0.1 ether, "greater than or equal to 0.1 ether");
 
        uint _amount = (msg.value * 100000)/(10 ** 18);	
        
        require(balances[minter] >= _amount, "Insufficient balance");
        
        minter.transfer(msg.value);
        balances[minter] = balances[minter].sub(_amount);	
        balances[msg.sender] = balances[msg.sender].add(_amount);
        emit Transfer(minter, msg.sender, _amount);
        
        return true;
    }
    
}