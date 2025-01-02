// Get fund from the user
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {PriceConverter} from "PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimumUSD = 5e18;
    address[] public fundersAdd;
    mapping(address => uint256) public addressToAmounFunded;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConvert() >= minimumUSD, "Didn't send enough ETH"); // 1e18 = 1*10**18;
        fundersAdd.push(msg.sender);
        addressToAmounFunded[msg.sender] =
            addressToAmounFunded[msg.sender] +
            msg.value;
    }

    function withdraw() public onlyOwner {
        require(msg.sender == owner, "Must be owner");
        for (uint256 i = 0; i < fundersAdd.length; i++) {
            address funder = fundersAdd[i];
            addressToAmounFunded[funder] = 0;
        }
        fundersAdd = new address[](0);

        /*
            withdraw ETH has three way :
            1. Transfer (2300 gas ,throws error)
                    payable(msg.sender).transfer(address(this).balance);
            2. Send (2300 gas, return bool)
                    bool sendSuccess=payable(msg.sender).send(address(this).balance);
                    require(sendSuccess,"Send failed");
            3. Call(forward all gas or set gas, returns bool) use 
        */

        
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call Failed");
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Must be owner");
        _;
    }
}
