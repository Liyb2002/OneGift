pragma solidity >=0.5.0 <0.7.0;

import './IDRegistration.sol';
contract MarketPlace is IDRegistration{
    Item []  public ItemList;
    struct Item{
        string name;
        uint price;
        bool available;
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    
    modifier CheckAvailability(uint id){
        require( ItemList[id].available == true);
        _;
    }
    function AddItem(string memory name, uint  price) onlyOwner public {
        ItemList.push(Item(name,price, true));
        emit AddItemEvent(name, price, ItemList.length);
        
    }
    
    function Purchase(uint ItemID) CheckAvailability (ItemID)public payable{
        require(msg.value == ItemList[ItemID].price, "Not the right price");
        ItemList[ItemID].available=false;
        emit PurchaseEvent(ItemList[ItemID].name, ItemList[ItemID].price, ItemID);
        
    }
    
    function retrieve ()onlyOwner public payable{
        owner.transfer(address(this).balance);
    }
    
    event AddItemEvent(string name, uint price, uint id);
    event PurchaseEvent(string name, uint price, uint id);



    
}