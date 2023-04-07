pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/utils/Context.sol";
contract Week2 is IERC20,IERC20Metadata, Context {

    mapping(address => uint) balances;
    mapping(address=>mapping(address=> uint)) _allowances;
    address [] whitelisted;
    address private feeCollector;
    string name;
    string symbol;

    uint _totalsupply;

    address private owner;

    error InvalidInput();

    uint public fee = 5;

    modifier onlyOwner(){
        require(msg.sender==owner);
        _;
    }

    constructor(string memory _name, string memory _symbol) {
        _name= name;
        _symbol=symbol;
    }

    function totalSupply() public view returns (uint) {
        return _totalsupply;
        
    }
    function balanceOf(address account) public view override returns (uint){
        return balances[account];
    }

    function setCollector(address collector) external onlyOwner{
        if(collector==address(0)) revert InvalidInput();
        feeCollector=collector;
    }
    
    function setFee(uint amt) public view returns (uint) {
        return amt * fee/100;
    }
    function transfer(address to, uint amount) public override returns(bool){
        address from = msg.sender;
       //_transfer(to, amount); 
       return true;
        
    }

    function allowList(address users) external {
        whitelisted.push(users);
    }

    function mintMore(uint amount) external {
        mapping(address=> bool) white;

        if(white[msg.sender]){
            uint max= 700;
            uint newmax = totalSupply+ max;

            if(newmax> max){
                revert ;
            }
            _mint(msg.sender,amount);
        }
    }
}