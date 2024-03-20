from brownie import DeFi, interface
from scripts.modules import (
    getWallet,
    wETHContract,
    aggregatorV3,
    poolAddressProvider,
    checkTokenSpendApproval,
    amount,
    tokenApprove,
    getUserData,
)
from brownie.exceptions import VirtualMachineError


def deployContract():
    senderAddress = getWallet()
    wrappedEtherContract = wETHContract()
    chainLinkPriceFeedContract = aggregatorV3()
    aavePoolAddress = poolAddressProvider()
    # address _wrappedEthereumContract, address _poolAddressProviderContract, address _aggregatorV3Contract, uint256 _minimumFee
    contract = DeFi.deploy(
        wrappedEtherContract,
        aavePoolAddress,
        chainLinkPriceFeedContract,
        10,
        {
            "from": senderAddress,
        },
    )

    # Contract Address Sepolia: 0xD8ae326d1e6094E8aa6270A6d56758FF4d4B6402


def supplyEtherToAave(value: int):
    address = getWallet()
    wrappedEther = wETHContract()
    contract = DeFi[-1]
    print("Getting Lending Pool Address.....")
    poolAddress = contract.getPoolAddress()
    print("You are about to approve token spend.....")
    amountToApprove = amount(value)
    approveToken = tokenApprove(amountToApprove, poolAddress, address)
    print(
        f"You have approved this value: {amountToApprove} to be spent on your behalf!!"
    )
    try:
        isFundSufficient = checkTokenSpendApproval(amountToApprove)
        aavePool = interface.ILendingPool(poolAddress)
        # address asset, uint256 amount, address onBehalfOf, uint16 referralCode
        deposit = (
            aavePool.supply(
                wrappedEther,
                amountToApprove,
                address,
                0,
                {
                    "from": address,
                },
            ),
        )
        print("You have deposited Ethereum for reward!!!..")
        print(
            "add this token contract \n0x5b071b590a59395fE4025A0Ccc1FcC931AAc1830 \nto see your deposit earning in real time"
        )
    except VirtualMachineError as error:
        if error == "Insufficient funds":
            print("You have Insufficiet funds")
        else:
            print(error)


def convertEthToWrappedEth(etherAmount: int):
    address = getWallet()
    contract = DeFi[-1]
    value = amount(etherAmount)
    try:
        deposit = contract.getWrappedEther(
            {
                "from": address,
                "value": value,
            }
        )
        print(f"you have swapped ether worth {value} for wrapped ethereum")
    except VirtualMachineError as error:
        print(error)


def setMinimumFee():
    address = getWallet()
    contract = DeFi[-1]
    try:
        minmumFee = contract.minimunFee({"from": address})
    except VirtualMachineError as error:
        print(error)


def main():
    getUserData(getWallet())
