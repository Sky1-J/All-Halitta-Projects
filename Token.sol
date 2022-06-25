//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract myToken{


       uint public totalSupply;
   
        mapping(address => uint) public balanceOf;
        mapping(address =>mapping(address =>uint)) public allowance;
        string public name = "Jennifer";
        string public symbol = "PJN";
        uint8 public decimals = 18;

        function jen(uint _initialSupply)public {
            balanceOf[msg.sender] = _initialSupply;
            totalSupply = _initialSupply;
        }
       

        function transfer(address recepient, uint amount)external returns (bool) {
            balanceOf[msg.sender] -= amount;
            balanceOf[recepient] += amount;
            emit Transfer(msg.sender, recepient, amount);
            return (true);
        }

       function approve(address spender ,uint amount)external returns (bool) {
           allowance[msg.sender][spender] = amount;
           emit Approval(msg.sender, spender, amount);
           return true;

       }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool){
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -=amount;
        balanceOf[recipient] +=amount;
        emit Transfer(sender,recipient, amount);
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint amoount);
    event Approval(address indexed owner, address indexed spender, uint amount);

   

function mint(uint amount, address admin)external {
   
    require (msg.sender ==admin, 'only admin');

        balanceOf[msg.sender] += amount;
        totalSupply += amount;
       
}
   

    function burn(uint amount) external {

        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
       
    }

    }

   




