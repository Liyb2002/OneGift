pragma solidity 0.6.10;

import "./TokenPool.sol";
import "./Ownable.sol";
import "../interfaces/IERC20.sol";
import "../SafeMath.sol";

contract statking{
    TokenPool public stakingPool;
    TokenPool public lockedPool;
    TokenPool public unlockedPool;
    
    uint256 public totalStakedAmount

    constructor public(IERC20 stakingToken, IERC20 MinningToken, address admin) Ownable(admin){
        stakingPool = new TokenPool(stakingToken);
        lockedPool=new TokenPool(MinningToken);
        unlockedPool=new TokenPool(MinningToken);
    }
    
    function totalStaked() public view{
        return totalStakedAmount;
    }
    
    function _stake(address from, uint256 amount)private{
        
    }

}