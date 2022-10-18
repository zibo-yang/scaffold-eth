pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; 
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract YourContract is Ownable{

  uint8 public count = 1;

  // address public owner;
  mapping(address => uint256) public balance;

  event Deposit(address sender, uint value);
  event Withdraw(address sender, uint value);
  event Transfer(address indexed from, address indexed to, uint256 value);

  string public purpose = "Building Unstoppable Apps!!!";

  event SetPurpose(address sender, string purpose);


  constructor() payable {
    // what should we do on deploy?
    balance[msg.sender] = msg.value;
  }

  function deposit() public payable{
    balance[msg.sender] += msg.value;
    emit Deposit(msg.sender, msg.value);
    console.log("%s is depositing %d ether to its account", msg.sender, msg.value);
  }

  function withdraw() public payable{
    require(balance[msg.sender] >= msg.value, "lack of enough deposit to withdraw");
    balance[msg.sender] -= msg.value;
    emit Withdraw(msg.sender, msg.value);
    console.log("%s is withdrawing %d ether from its account", msg.sender, msg.value);
  }
  
  //receive ether as onwer
  function receiveEther(address to, uint value) public payable {
    payable(to).transfer(value);
    emit Transfer(msg.sender, to, value);
    console.log("The owner %s received %d wei to %s", to, value, msg.sender);
  }

  function dev() public payable onlyOwner{
    count++;
    console.log("count:", count);
  }

  function setPurpose(string memory newPurpose) public {
      purpose = newPurpose;
      console.log(msg.sender,"set purpose to",purpose);
      emit SetPurpose(msg.sender, purpose);
  }

  // to support receiving ETH by default
  receive() external payable {}
  fallback() external payable {}
}
