pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Multisig{

    error Unauthorized();
    error InvalidInput();

    address private admin;
    IERC20 public iERC;
    
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
    constructor(address _owner2){
        admin= msg.sender;
        owners[admin]= true;
        owners[_owner2]= true;
    }

    modifier whitelisted{
        if(owners[msg.sender] != true){
            revert Unauthorized();
        }
    }

    function setTokens(address tokenAddress) external whitelisted {
        if(tokenAddress==address(0)){
            revert InvalidInput();
        }
        acceptedTokens[tokenAddress]=true;
        iERC=IERC20(tokenAddress);

        
    }
}
