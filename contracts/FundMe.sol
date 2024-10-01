// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

import "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 0.001 * 1e18;

    address[] public funders;
    mapping (address => uint256) public addressToAmountFunded;

    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }
    

    function fund() public payable{
         
        //set a minumum value that can be sent
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough"); // 1e18 wei === 1 eth
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }


    function withdraw() public onlyOwner {
        //require(msg.sender == owner, "Sender is not the owner!"); -> 
        // use modified instead

        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);

        // 3 different ways to withdraw funds from the contract:
        // 1. transfer
        // msg.sender = address
        // payable(msg.sender) = payable address
        // only payable address can send funds
        payable(msg.sender).transfer(address(this).balance);
         
        // problem with transfer - has limit is 2300
        // if limit exceeded - an error is thrown
        
        // 2. send
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send failed");
        // problem with send - it's more manual and still limited at 2300 gas
        // however, send returns a boolean after success or fail
        // and will revert the transaction only if require is stated explictly

        // 3. call - recommended
        //(bool callSuccess, bytes memory dataReturned) = payable(msg.sender).call{value: address(this).balance}("");
        // if you don't need dataReturned, do this: 
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner {
        //require(msg.sender == i_owner, "Sender is not owner!");
        if(msg.sender != i_owner) { revert NotOwner(); }
        _;
    }

    receive() external payable {
        // If someone sends money directly to the contract address
        // this function will be triggered
        // and still be redirected to fund()
        fund(); 
     }

}