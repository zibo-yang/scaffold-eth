// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading

import "hardhat/console.sol";


contract ExampleExternalContract {

  bool public completed = false;

  event Receive(address, uint256);
  event Fallback(address, uint256);


  //receive function: just emit Receive event
  receive() external payable {
    emit Receive(msg.sender, msg.value);
    console.log("receive function of contract ExampleExternalContract was called");
  }

  //fallback function: just emit Fallback event
  fallback() external payable {
    emit Fallback(msg.sender,msg.value);
    console.log("fallback function of contract ExampleExternalContract was called");
  }

  function complete() public payable {
    completed = true;
    
    //test:print msg.value to see if it is changed already
    console.log("complete function: current msg.sender %s and msg.value %d", msg.sender, msg.value);

    console.log("deposit collection has been completed");
  }

}
