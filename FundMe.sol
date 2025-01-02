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

    function fund() public payable {
        require(msg.value.getConvert() >= minimumUSD, "Didn't send enough ETH"); // 1e18 = 1*10**18;
        funders.push(msg.sender);
        addressToAmounFunded[msg.sender] =
            addressToAmounFunded[msg.sender] +
            msg.value;
    }

    function withdraw() public {
        for (uint256 i = 0; i < fundersAdd.lengt; i++) {
            address funder = fundersAdd[i];
            addressToAmounFunded[funder] = 0;
        }
        // Reset the array of funder 

        fundersAdd = new address[](0);

        /*
            withdraw ETH has three way :
            1. Transfer (2300 gas ,throws error)
            2. Send (2300 gas, return bool)
            3. Call(forward all gas or set gas, returns bool)
        */
        // 1: Transfer 
        payable(msg.sender).transfer(address(this).balance);
        // send
        payable(msg.sender).send(address(this).balance);

    }
}
