// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.6.10;

import "./TokenPool.sol";
import "./Ownable.sol";
import "../interfaces/IERC20.sol";
import "../SafeMath.sol";

contract statking{
      using SafeMath for uint256;

    TokenPool public stakingPool;
    TokenPool public lockedPool;
    TokenPool public unlockedPool;
    mapping (address => UserDetail) UserInfo;
    uint256 private totalTimeAmount;
    uint256 private lastTimeStamp;


    struct UserDetail{
        uint256 stakingAmount;
        uint256 LastTime;
        uint256 UsertimeAmount;
    }
    
    uint256 public totalStakedAmount;

    constructor (IERC20 stakingToken, IERC20 MinningToken) public{
        stakingPool = new TokenPool(stakingToken);
        lockedPool=new TokenPool(MinningToken);
        unlockedPool=new TokenPool(MinningToken);
        totalStakedAmount=0;
        totalTimeAmount=0;
    }
    
    function totalStaked() public view returns(uint256){
        return totalStakedAmount;
    }

    function stake(uint256 amount)external{
        _stake(msg.sender, amount);
    }
    
    function _stake(address from, uint256 amount)private{
        require(stakingPool.token().transferFrom(from, address(stakingPool),amount), 
        "You are not staking the right amount");
        totalStakedAmount = totalStakedAmount.add(amount);
        _updateUserReward(from);
        _updateUserStaking(amount, from);
        _updateTotalTimeAmount(amount, true);

    }
    
    function _updateUserStaking(uint256 amount, address user) private{
        //Update staked amount
        UserInfo[user].stakingAmount=UserInfo[user].stakingAmount.add(amount);
        
    }

    function _updateUserReward(address user) private{
        //Update reward
        UserInfo[user].UsertimeAmount=UserInfo[user].UsertimeAmount.add(
            (now-UserInfo[user].LastTime).mul(UserInfo[user].stakingAmount));
            
        //Update time
        UserInfo[user].LastTime=now;

    }

    function _updateTotalTimeAmount(uint256 amount, bool isAdd)private{
        totalTimeAmount= totalTimeAmount.add((now.sub(lastTimeStamp)).mul(totalStakedAmount));
        lastTimeStamp=now;
        if(isAdd){
         totalStakedAmount = totalStakedAmount.add(amount);
        }
        else{
         totalStakedAmount = totalStakedAmount.sub(amount);

        }

    }

}