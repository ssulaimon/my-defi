from brownie import network, accounts, config, interface, DeFi, interface
from web3 import Web3


def getWallet():
    if network.show_active() == "development":
        return accounts[0]
    else:
        return accounts.add(
            config["networks"][network.show_active()]["wallets"]["account-one"]
        )


def amount(ether: int):
    return Web3.to_wei(ether, "ether")


def wETHContract():
    return config["wallets"][network.show_active()]["weth"]


def poolAddressProvider():
    return config["wallets"][network.show_active()]["leandingPoolAddressProvider"]


def aggregatorV3():
    return config["wallets"][network.show_active()]["aggregatorV3Contract"]


def tokenApprove(amount: int, spender: str, address: str):
    contractAddress = wETHContract()
    contract = interface.IWrappedEther(contractAddress)
    # address guy, uint wad
    approve = contract.approve(spender, amount, {"from": address})


def checkTokenSpendApproval(amount: int):
    contract = DeFi[-1]
    address = getWallet()
    isApproved = contract.isAllowed(amount, {"from": address})
    return isApproved


def getUserData(userAddress: str):
    contract = DeFi[-1]
    print("Getting Lending Pool Address.....")
    poolAddress = contract.getPoolAddress()
    pool = interface.ILendingPool(poolAddress)
    (
        totalCollateralBase,
        totalDebtBase,
        availableBorrowsBase,
        currentLiquidationThreshold,
        ltv,
        healthFactor,
    ) = pool.getUserAccountData(userAddress)
    depositedEthAmount = Web3.from_wei(totalCollateralBase, "ether")
    loanAbleValue = Web3.from_wei(availableBorrowsBase, "ether")
    print(depositedEthAmount)
    print(loanAbleValue)


def poolAddressGetter():
    contract = interface.IPoolAddressProvider(poolAddressProvider())
    return contract.getPool()
