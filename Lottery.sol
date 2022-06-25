//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;


contract Raffledraw{

address public admin;
address payable[] public players;
uint public playerNumbers;
uint public ticketPrice;
uint public endOfLottery;





constructor( uint _lotteryTime) {
    admin = msg.sender;
    endOfLottery = block.timestamp + _lotteryTime;
   
    ticketPrice = 1 ether;
}

modifier onlyAdmin(){
    require(msg.sender==admin, "Access Denied!");
    _;
}

    modifier notAdmin(){
        require(msg.sender!=admin, "Access Denied!");
        _;
    }

    function random() public view returns(uint){
    return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players,block.number)));
    }



function enter()public payable notAdmin {
require(msg.value== 1 ether);
if(block.timestamp < endOfLottery){
 players.push(payable(msg.sender));
playerNumbers++;

}

else if (block.timestamp >= endOfLottery){
     uint win = random() % players.length;
    players[win].transfer(address(this).balance);

}
}
function pickWinner() public onlyAdmin {
    if(block.timestamp < endOfLottery){
        revert("The lottery has not ended yet");
    }
    uint win = random() % players.length;
    players[win].transfer(address(this).balance);

   
}

function getBalance() public view returns (uint){
      return address(this).balance;

    }
}


