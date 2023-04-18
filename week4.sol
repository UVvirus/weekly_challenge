pragma solidity 0.8.17;

import "./week4_token.sol";

interface IToken {
    function balanceOf(address account) external view returns(uint);
    function transferFrom(address from, address to, uint amount) external retruns(uint);
}

contract Staking {
    
    mapping(address => bool) TrackAddress;
    mapping(address => stakeinfo) TrackStaked;

    uint three_month_duration= 1000;
    uint _expiry;
    uint interestRate=30;

    struct stakeinfo{
        uint startTime;
        uint endTime;
        uint stakedAmount;
        uint claimed;
    }

    constructor(address _tokenAddress){
        IToken token = IToken(_tokenAddress);
        uint expiry = block.timestamp + _expiry;
    }

    
    function stake(uint amount) external {

        require(amount > 0, "zero tokens cant be deposited");
        require(block.timestamp < expiry, "Expired");
        require(TrackAddress[msg.sender] == false,"Already staked");
        require(token.balanceOf(msg.sender) >= amount,"Insufficient tokens");

        token.transferFrom(msg.sender,address(this),amount);

        TrackStaked[msg.sender]= stakeinfo({
            startTime: block.timestamp,
            endTime: block.timestamp + three_month_duration,
            stakedAmount: amount,
            claimed: 0
        });

        
    }

    function claimRewards() external {
        require(block.timestamp  > expiry,"Not expired");

    }

    function calculateReward() {
        uint amountStaked = TrackStaked[msg.sender].stakedAmount;
        uint rewardTokens = amountStaked + (amountStaked * interestRate)/ 100;
    }
    
}