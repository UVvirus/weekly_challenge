pragma solidity 0.8.17;

import "./week4_token.sol";

interface IToken {
    function balanceOf(address account) external view returns (uint);
    function transferFrom(address from, address to, uint amount) external returns (uint);
    function transfer(address to, uint amount) external;
}

contract Staking {
    
    mapping(address => bool) TrackAddress;
    mapping(address => stakeinfo) TrackStaked;

    uint three_month_duration= 1000;
    uint _expiry=1000;
    uint interestRate=30;

    struct stakeinfo{
        uint startTime;
        uint endTime;
        uint stakedAmount;
        uint claimed;
    }

    event RewardsClaimed(address receipient, uint amount);
    IToken Token;

    constructor(IToken _tokenAddress){
         Token = IToken(_tokenAddress);
        uint expiry = block.timestamp + _expiry;
    }

    
    function stake(uint amount) external {

        require(amount > 0, "zero tokens cant be deposited");
        require(block.timestamp < _expiry, "Expired");
        require(TrackAddress[msg.sender] == false,"Already staked");
        require(Token.balanceOf(msg.sender) >= amount,"Insufficient tokens");

        Token.transferFrom(msg.sender,address(this),amount);

        TrackStaked[msg.sender]= stakeinfo({
            startTime: block.timestamp,
            endTime: block.timestamp + three_month_duration,
            stakedAmount: amount,
            claimed: 0
        });

        
    }

    function claimRewards() external {
        require(block.timestamp  > _expiry,"Not expired");
        uint rewardd = calculateReward();
        TrackStaked[msg.sender].claimed= rewardd;
        Token.transfer(msg.sender,rewardd);
        emit RewardsClaimed(msg.sender, rewardd);
    }

    function calculateReward() internal returns(uint){
        uint amountStaked = TrackStaked[msg.sender].stakedAmount;
        uint rewardTokens = amountStaked + (amountStaked * interestRate)/ 100;
        return rewardTokens;
    }

    receive() external payable{}

    fallback() external payable {}
    
}
