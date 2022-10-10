// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";
// import "@openzeppelin/contracts/math/SafeMath.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;

  uint256 public deadline = block.timestamp + 72 hours;
  uint256 public constant threshold = 1 ether;
  
  bool private withdrawPermission = false; 

  event Stake(address, uint256);
  event Withdraw(address, uint256);
  event Receive(address, uint256);
  event Fallback(address, uint256);

  mapping(address => uint256) public balances;

  constructor(address payable exampleExternalContractAddress) {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  //receive function: just emit Receive event
  receive() external payable {
    emit Receive(msg.sender, msg.value);
    console.log("receive function of contract staker was called");
  }

  //fallback function: just emit Fallback event
  fallback() external payable {
    emit Fallback(msg.sender,msg.value);
    console.log("fallback function of contract staker was called");
  }

  //printInfo checking function
  function printInfo() private view {
    console.log("current msg.sender %s and msg.value %d", msg.sender, msg.value);
  }

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  // ( Make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
  function stake() public payable {
      console.log("msg sender's balance: %d and msgvalue: %d", address(msg.sender).balance, msg.value);
      
      
      require(address(msg.sender).balance >= msg.value, "Sender doesn't deposit enough ethers to transfer");
      payable(address(this)).transfer(msg.value);
      console.log("%s transfers %d wei to contract %s", msg.sender, msg.value, address(this));
      balances[msg.sender] += msg.value;
      console.log("Contract %s increments the balance of %s with %d ethers", address(this), msg.sender, msg.value);
      emit Stake(msg.sender, msg.value);

      //test: etherValue function
      // console.log("etherValue: %d", etherValue(msg.sender));
  }

  // After some `deadline` allow anyone to call an `execute()` function
  // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(exampleExternalContract).balance}()`
  // If the `threshold` was not met, allow everyone to call a `withdraw()` function to withdraw their balance
  function execute() public payable{
      require(block.timestamp >= deadline, "you haven't reached the deadline yet!");
      console.log("anyone can call this execute function after deadline");
      console.log("complete or not: %s\n deposit: %d\n threshold: %d",
        address(this).balance >= threshold ? true : false,
        address(this).balance,
        threshold
      );
      if (address(this).balance >= threshold) {
        // //test: if msg was changed before and after complete function below
        // console.log("current msg.sender %s and msg.value %d", msg.sender, msg.value);
        
        exampleExternalContract.complete{value: uint(address(this).balance)}();
        console.log("successful");
      } else {
        withdrawPermission = true;
        console.log("current withdraw permission is %s", withdrawPermission);
        withdraw();
      }
  }

  function withdraw() public payable {
      require(withdrawPermission == true, "withdrawPermission is false!");

      uint tempDeposit = uint(balances[msg.sender]);

      balances[msg.sender] = 0;
      // console.log("%d temporal deposit is being withdrawn", tempDeposit);
      // printInfo();
      payable(msg.sender).transfer(tempDeposit);
      console.log("%s withdraws %d wei out of contract %s", msg.sender, tempDeposit, address(this));
      emit Withdraw(msg.sender, tempDeposit);
  }
  

  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
  function timeLeft() public view returns (uint256){
      return deadline >= block.timestamp ? deadline - block.timestamp : 0;
  }

  // // Add the `receive()` special function that receives eth and calls stake()
  
}
