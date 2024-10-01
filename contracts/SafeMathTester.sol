// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;
contract SafeMathTester{

    uint8 public bigNumber = 255; // unchecked

    function add() public{
        bigNumber = bigNumber + 1;
        //bigNumber goes to 0. 255 is max; adding 1 turns it to 0;

        // in 0.8, to make it unchecked, do this:
        // (It makes it more gas efficient)
        unchecked {bigNumber = bigNumber + 1;}
    }
    // In version 0.8 this results in an error
}