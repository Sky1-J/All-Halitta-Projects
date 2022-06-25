//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract SimpleAuction{

address payable public vendor;

uint public auctionEndTime;
address public highestBidder;
uint public highestBid;
mapping(address=>uint) public pendingReturns;

uint public withdrawn;
bool public started;
bool public ended;



event HighestBidIncrease(address bidder, uint amount);
event AuctionEnded(address winner, uint amount);

    function start(address payable _vendor) public  {
        require (!started, "started");
        vendor = _vendor;
        started = true;
        ended = false;
        auctionEndTime = block.timestamp + 180;
}
   
   
function bid() public payable{
    require(started, "not started");
    require(msg.sender != vendor, "vendor cannot bid" );
    if(block.timestamp > auctionEndTime){
        revert("The auction had already ended");}
    if(msg.value <= highestBid){
        revert("There is a higher or equal bid");}
    if (highestBid !=0){
        pendingReturns[highestBidder] +=highestBid;}
    highestBidder = msg.sender;
    highestBid = msg.value;
    emit HighestBidIncrease(msg.sender, msg.value);
}
function withdraw() public returns (bool) {
    
    uint amount = pendingReturns[msg.sender];
    if(amount > 0){
        pendingReturns[msg.sender] = 0;}
    
    if  (!payable(msg.sender).send(amount)){
          pendingReturns[msg.sender] = amount;
         return false; }
         return true;
}


function auctionEnd() public {
    if (block.timestamp < auctionEndTime){
        revert ("The auction has not ended yet");}
        if(ended){
            revert("The auctionEnd has already been called");
        }
    ended = true;
    started = false;
    emit AuctionEnded(highestBidder, highestBid);
    vendor.transfer(highestBid);
    highestBid=0;
     delete highestBidder; 
    }
    

function getBalance() public view returns (uint){
      return address(this).balance;}
}


