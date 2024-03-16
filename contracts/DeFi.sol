//SPDX-License-Identifier:MIT
pragma solidity >=0.8.0 <0.9.0;
import "interfaces/IWETH.sol";
import "interfaces/ILendingPoolAddressProvider.sol";
import "interfaces/ILendingPool.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DeFi {
    IWETH iWETHContract;
    ILendingPoolAddressProvider lendPoolAddressProvider;
    ILendingPool lendingPool;
    constructor(address _contractAddress, address _lendingPoolAdressProviderContract, string memory _defiTokenName, string memory _defiTokenSymbol) ERC20(_defiTokenName, _defiTokenSymbol) {
        iWETHContract = IWETH(_contractAddress);
        lendPoolAddressProvider = ILendingPoolAddressProvider(_lendingPoolAdressProviderContract);
        _mint(msg.sender, _tokenSupply);
        lendingPool = ILendingPool(_getPoolAddress());
        
    }
    //all amount user have deposited to protocol 
    mapping(address=> uint256) public addressToAmount;
    mapping(address=> bool) internal alreadyDeposited; 

    function checkAmountDeposited()public view returns (uint256){
        return addressToAmount[msg.sender];
    }

    function convertToWETH() public payable{
        iWETHContract.deposit{value: msg.value}();
        iWETHContract.transfer(msg.sender, msg.value);
        if(alreadyDeposited[msg.sender]){
            addressToAmount[msg.sender] += msg.value;
        }else{
            addressToAmount[msg.sender] = msg.value;
        }
    }

    function wETHBalance()public view returns(uint){
         return iWETHContract.balanceOf(msg.sender);
        
    }

    function _getPoolAddress() internal view returns(address){
        address pool = lendPoolAddressProvider.getPool();
        return pool;
    } 

    function addressPool()public view returns(address){
        return _getPoolAddress();
    }
}