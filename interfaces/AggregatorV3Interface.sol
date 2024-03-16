//SPDX-License-Identifier:MIT
pragma solidity >=0.0.0 <0.9.0;

interface AggregatorV3Interface{

    function latestRoundData()external returns(  uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound);
    function decimals()external view returns (uint8);
}