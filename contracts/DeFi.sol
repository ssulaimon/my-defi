//SPDX-License-Identifier:MIT
pragma solidity >=0.8.0 <0.9.0;
import "interfaces/IWrappedEther.sol";
import "interfaces/IPoolAddressProvider.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "interfaces/AggregatorV3Interface.sol";

contract DeFi{
    IWrappedEther wrappedEthereum;
    IPoolAddressProvider poolAddressProvider;
    AggregatorV3Interface aggregatorV3Interface;
    uint256 setMinimumFee;
    uint256 public fee;
    address owner;
    
    constructor(address _wrappedEthereumContract, address _poolAddressProviderContract, address _aggregatorV3Contract, uint256 _minimumFee){
        wrappedEthereum = IWrappedEther(_wrappedEthereumContract);
        poolAddressProvider = IPoolAddressProvider(_poolAddressProviderContract);
        aggregatorV3Interface = AggregatorV3Interface(_aggregatorV3Contract);
        setMinimumFee = _minimumFee *(10**18);
        owner = msg.sender;

    }

    mapping (address=> uint256) amountTraded;
    mapping(address=> bool) isUserNew;
    function getWrappedEther()public payable{
        require(msg.value >= fee, "Amount is not up to minimum fee");
        wrappedEthereum.deposit{value: msg.value}();
        wrappedEthereum.transfer(msg.sender, msg.value);
        if(isUserNew[msg.sender]){
            amountTraded[msg.sender] = msg.value;
        }else{
            amountTraded[msg.sender] += msg.value;
        }

    }

     function checkAllowance()public view returns(uint256){
       return wrappedEthereum.allowance(msg.sender, getPoolAddress());
    }

    function checkBalance()public view returns(uint256){
        return wrappedEthereum.balanceOf(msg.sender);
    }

    function getPoolAddress()public view returns(address){
        return poolAddressProvider.getPool();
    }

    function isAllowed(uint256 _amount)public view  returns(bool){
        require(_amount <= checkBalance(), "Insufficient funds");
        require(_amount <= checkAllowance(), "Insufficient Allowance");
        return  true;
    }

    function latestEthereumPrice()public returns(uint256){
        (,int256 answer,,, ) = aggregatorV3Interface.latestRoundData();
        uint256 etherPrice = uint256(answer)* 10**10;
        return  etherPrice;
    }

    function minimunFee()public onlyOwner{
        uint256 etherPrice = latestEthereumPrice();
         fee = (setMinimumFee *10**18 ) / etherPrice;
       
    }

    modifier onlyOwner{
        require(msg.sender == owner, "Only Owner Can Call this function");
        _;
    }

    function changeMinimumFee(uint256 _amount) public onlyOwner{
        setMinimumFee = _amount * 10**18;
        minimunFee();
    }
   
}