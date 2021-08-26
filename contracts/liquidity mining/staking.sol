// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.6.10;

import "./TokenPool.sol";
import "./Ownable.sol";
import "../interfaces/IERC20.sol";
import "../SafeMath.sol";

contract statking{
      using SafeMath for uint256;

    TokenPool public stakingPool;
    TokenPool public unlockedPool;
    mapping (address => UserDetail) UserInfo;
    uint256 private _totalTimeAmount=0;
    uint256 private _lastTimeStamp=0;

    //When to stop producing new tokens
    uint256 private _Initime;
    uint256 private _duration = 60 days;
    uint256 private _distributionAmount;


    struct UserDetail{
        uint256 stakingAmount;
        uint256 LastTime;
        uint256 UsertimeAmount;
    }
    
    uint256 public totalStakedAmount;

    constructor (IERC20 stakingToken, IERC20 MinningToken, 
        uint256 distributionAmount) public{
        stakingPool = new TokenPool(stakingToken);
        unlockedPool=new TokenPool(MinningToken);
        _Initime=now;
        _distributionAmount=distributionAmount;

    }
    
    //View functions
    function totalStaked() public view returns(uint256){
        return (totalStakedAmount);
    }

    function myStakings() public view returns(uint256){
        return (_viewUserStaking(msg.sender));
    }

    function myRewards() public view returns(uint256){
        return (_rewardsCalculation(msg.sender));
    }

    //External functions called by user
    function stake(uint256 amount)external{
        _stake(msg.sender, amount);
    }

    function claim()external{
        _claim(msg.sender);
    }

    function claimAndUnstake()external{
        _claim(msg.sender);
        _unstake(msg.sender);
    }
    
    //Private functions
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
        _totalTimeAmount= _totalTimeAmount.add((now.sub(_lastTimeStamp)).mul(totalStakedAmount));
        _lastTimeStamp=now;
        if(isAdd){
         totalStakedAmount = totalStakedAmount.add(amount);
        }
        else{
         totalStakedAmount = totalStakedAmount.sub(amount);

        }

    }

    function _rewardsCalculation (address user)view private returns(uint256){
        uint256 _totalAvalAmount = (now.sub(_Initime)).div(_duration).mul(_distributionAmount);
        return (UserInfo[user].UsertimeAmount).div(totalStakedAmount).mul(_totalAvalAmount);

    }

    function _claim(address user)private {
        _updateUserReward(user);
        uint256 reward = _rewardsCalculation(user);
        UserInfo[user].UsertimeAmount=0;
        UserInfo[user].LastTime=now;
        unlockedPool.transfer(user, reward);
    }

    function _unstake(address user) private {
        uint256 temptAmount = UserInfo[user].stakingAmount;
        UserInfo[user].stakingAmount=0;
        totalStakedAmount = totalStakedAmount.sub(temptAmount);
        stakingPool.transfer(user, temptAmount);

    }

    function _viewUserStaking(address user)view 
    private returns(uint256){
        return (UserInfo[user].stakingAmount);
    }




}