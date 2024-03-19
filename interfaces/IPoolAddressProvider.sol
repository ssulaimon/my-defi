//SPDX-License-Identifier:MIT
pragma solidity >=0.8.0 <0.9.0;

interface IPoolAddressProvider{
     function getPool() external view returns (address);
}