pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Multisig{

    error Unauthorized();
    error InvalidInput();

    address private admin;
    IERC20 public iERC;

    uint256 counter;
    
    struct Transaction{
        address token;
        uint amount;
        address sender;
        address approver;
        address receiver;
        bool txComplete;
    }
    //uint => transaction id
    //Transaction => struct
    mapping(uint => Transaction) transactionDetails;
    mapping(address => bool) owners;
    mapping(address => bool) acceptedTokens;

    event TransactionInititated(address tokenAddress,address from, address to, uint256 amount);
    constructor(address _owner2){
        admin= msg.sender;
        owners[admin]= true;
        owners[_owner2]= true;
    }

    modifier whitelisted{
        if(owners[msg.sender] != true){
            revert Unauthorized();
            _;
        }
    }

    function setTokens(address tokenAddress) external whitelisted {
        if(tokenAddress==address(0)){
            revert InvalidInput();
        }
        acceptedTokens[tokenAddress]=true;
        iERC=IERC20(tokenAddress);

        
    }

    function deposit(uint amount) external {
        if(amount ==0){
            revert InvalidInput();
        }
        require(iERC.balanceOf(msg.sender) > 0,"Zero tokens cant be depositted");
        iERC.transferFrom(msg.sender,address(this),amount);
    }

    function InitiateWithdraw(address tokenAddress,address _to, uint _amount) external whitelisted {
        require(acceptedTokens[tokenAddress],"Not an accepted token");
        uint _id = ++counter;
        Transaction storage txinit = transactionDetails[_id];
        txinit.token =  tokenAddress;
        txinit.amount =   _amount;
        txinit.sender = msg.sender;
        txinit.receiver = _to;

        emit TransactionInititated(tokenAddress,msg.sender, _to, _amount);

    }

    function completeWithdraw(uint _id) external whitelisted{
        require(_id > 0,"Invalid id");

        Transaction storage txcompletion = transactionDetails[_id];
        address treceiver = txcompletion.receiver;
        uint amont = txcompletion.amount;

        iERC.transfer(treceiver,amont);
        txcompletion.txComplete=true;
    }
}

