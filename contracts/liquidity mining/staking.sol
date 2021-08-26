// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.6.10;

import "./TokenPool.sol";
import "./Ownable.sol";
import "../interfaces/IERC20.sol";
import "../SafeMath.sol";

contract statking{
    TokenPool public stakingPool;
    TokenPool public lockedPool;
    TokenPool public unlockedPool;
    mapping (address => UserDetail) UserInfo;


    struct UserDetail{
        uint256 stakingAmount;
        uint256 LastTime;
        uint256 rewards;
    }
    
    uint256 public totalStakedAmount

    constructor (IERC20 stakingToken, IERC20 MinningToken, address admin) public Ownable(admin){
        stakingPool = new TokenPool(stakingToken);
        lockedPool=new TokenPool(MinningToken);
        unlockedPool=new TokenPool(MinningToken);
    }
    
    function totalStaked() public view returns(uint256){
        return totalStakedAmount;
    }
    
    function _stake(address from, uint256 amount)private{
        require(stakingPool.token().transferFrom(from, amount), 
        "You are not staking the right amount");
        
        UserStaking[from]=UserStaking[from].add(amount);
    }
    
    function _updateUserStaking(uint256 amount, address user){
        //Update staked amount
        temptUser = UserInfo[user];
        temptUser.stakingAmount=temptUser.stakingAmount.add(amount);
        
    }

    function _updateUserReward(address user){
        
    }

}