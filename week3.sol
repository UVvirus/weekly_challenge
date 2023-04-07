pragma solidity 0.8.17;

contract Multisig {

    mapping(address => bool) whitelisted;

    constructor{
        address user1= address(0x1)
        address user2= address(0x2)

        whitelisted[msg.sender]= true;
        whitelisted[user2]= true;
    }

    function deposit() payable external{

        require(msg.value > 0,"zero cant be deposited");
        
    }

    modifier onlyWhitelisted() {
        require(whitelisted[msg.sender] == true,"Not whitelisted");
        _;
    }

    function withdraw(uint amount) external onlyWhitelisted{
        require(address(this.balance) > 0,"wallet is empty");
        require(amount > 0,"zero cant be withdrawn");
        
        (bool success,) = msg.sender.send(amount);
        require(success,"Transaction failed");
        
    }

    receive() payable {}
    
}