//SPDX-License-Identifier:MIT
pragma solidity >=0.8.0 <0.9.0;

interface IWETH{
    function deposit()external payable ;

    function balanceOf(address owner) external view returns(uint);

    function transfer(address dst, uint wad) external returns(bool);
    
    function approve(address guy, uint wad) external returns (bool);
}