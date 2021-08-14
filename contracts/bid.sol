pragma solidity >=0.5.0 <0.7.0;
import './MarketPlace.sol';

contract bid is MarketPlace{
    //Who will receive the money selling the product
    uint public auctionEndTime;
    uint _biddingTime;
    bool alreadyEnded;
    bool alreadyBided;
    mapping(address => uint) pendingReturns;
    address [] Bidders;

    address public highestBidder;
    uint public highestBid;
    
    constructor(uint timeINMin) public {

        auctionEndTime = now + timeINMin * 1 minutes;
    }
    
    function bidAction()public payable{
        require(msg.value>highestBid, "You must bid higher than highestBid");
        require(now<auctionEndTime, "Bid ended");
        
        //If there's already a bid
        if(alreadyBided){
            //Save the last bid's value into pendingReturns
            pendingReturns[highestBidder]+=highestBid;
            //save last bidder infomation 
            Bidders.push(highestBidder);
            
            highestBidder=msg.sender;
            highestBid=msg.value;
        }
        
        //If no one bid before 
        else{
        highestBidder=msg.sender;
        highestBid=msg.value;
        alreadyBided=true;
        }
    }
    

    
    //If someone lose the bid, they can withDraw what they prviously put
    function withdraw() public returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;

            if (!msg.sender.send(amount)) {
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }
    
    //Only owner can end the bid
    function endAutction()public{
        require(msg.sender==owner, "Only owner can end the Bid");
        require(now>=auctionEndTime, "Bid has not ended");
        require(alreadyEnded==false, "Bid has been ended");
        //Check if function called before 
        alreadyEnded=true;
        owner.transfer(highestBid);
        _retreiveAll();
    }
    
    //Take all money that is not withDraw before the bid ends
    function _retreiveAll ()private{
        for (uint i=0; i<Bidders.length; i++){
            if (pendingReturns[Bidders[i]]!=0){
                //Take the money
                 owner.transfer(pendingReturns[Bidders[i]]);
                 pendingReturns[Bidders[i]]=0;
            }
        }
        
    }
    
    //Return howlong until the bid ends
    function timeTillEnd()public view returns (uint currentTime, uint endTime){
        currentTime=now;
        endTime=auctionEndTime;
    }
    
}