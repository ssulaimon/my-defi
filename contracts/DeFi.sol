//SPDX-License-Identifier:MIT
pragma solidity >=0.8.0 <0.9.0;
import "interfaces/IWETH.sol";
import "interfaces/ILendingPoolAddressProvider.sol";
import "interfaces/ILendingPool.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "interfaces/AggregatorV3Interface.sol";

contract DeFi {
    IWETH iWETHContract;
    ILendingPoolAddressProvider lendPoolAddressProvider;
    ILendingPool lendingPool;
    address WETH; 
    AggregatorV3Interface aggregatorV3;
    constructor(address _contractAddress, address _lendingPoolAdressProviderContract, address _aggregatorV3InterfaceContract)  {

        //Connecting to Wrapped Ethereum contract
        iWETHContract = IWETH(_contractAddress);

        //Getting the lending Pool Address
        lendPoolAddressProvider = ILendingPoolAddressProvider(_lendingPoolAdressProviderContract);

        //Chainlink price feed contract connecting  
        aggregatorV3 = AggregatorV3Interface(_aggregatorV3InterfaceContract);
        
        // Connecting to lending pool contract
        lendingPool = ILendingPool(_getPoolAddress());

        //setting the contract address of wrapped ethereum
        WETH = _contractAddress;
        
    }
    //all amount user have deposited to protocol 
    mapping(address=> uint256) public addressToAmount;

    // checking if user have already interacted with the contract previously
    mapping(address=> bool) internal alreadyDeposited; 

    //checking the amount of ether user have deposited through contract

    function checkAmountDeposited()public view returns (uint256){
        return addressToAmount[msg.sender];
    }

    // converting ether to wrapped ethereum
    function convertToWETH() public payable{
        iWETHContract.deposit{value: msg.value}();
        iWETHContract.transfer(msg.sender, msg.value);
        if(alreadyDeposited[msg.sender]){
            addressToAmount[msg.sender] += msg.value;
        }else{
            addressToAmount[msg.sender] = msg.value;
        }
    }

// check user wrapped ethereum balance 
    function wETHBalance()public view returns(uint){
         return iWETHContract.balanceOf(msg.sender);
        
    }
// Get latest pool address 
    function _getPoolAddress() internal view returns(address){
        address pool = lendPoolAddressProvider.getPool();
        return pool;
    } 

    function addressPool()public view returns(address){
        return _getPoolAddress();
    }

    modifier tokenSpendApprove(uint256 amount){
        require(amount <= wETHBalance(), "You cannot Approve token amount greater than your balance");
        _;
    }

    //deposit wrapped ethereum 
    function depositToken()public payable tokenSpendApprove(msg.value){
        address avaeePool = _getPoolAddress();

        //approve spending of wrapped etherem token by avaee protocol 
        iWETHContract.approve(avaeePool, msg.value);
        //address asset, uint256 amount, address onBehalfOf, uint16 referralCode
        lendingPool.supply(WETH, msg.value, msg.sender, 0);

    }

    function latestEthereumPrice()public returns(uint256){
        (,int256 answer,,,) = aggregatorV3.latestRoundData();
        uint256 price = uint256(answer)*10**10;
        return price;
       
}
}