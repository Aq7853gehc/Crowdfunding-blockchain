// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice() internal view returns (uint256) {
        // Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        (, int256 price, , , ) = priceFeed.latestRoundData();
        // Price of Eth in term of USD
        return uint256(price * 1e10);
    }

    function getConvert(uint256 ethAmount) internal view returns (uint256) {
        uint256 ethprice = getPrice();
        uint256 ethAmUSD = (ethprice * ethAmount) / 1e18;
        return ethAmUSD;
    }
}