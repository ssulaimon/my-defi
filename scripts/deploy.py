from brownie import DeFi, interface
from scripts.modules import (
    getWallet,
    amount,
    wETHContract,
    ledingPoolAddressProvider,
    aggregatorV3,
)


def approveToken():
    address = getWallet()
    value = amount(0.5)
    wrapped = wETHContract()
    contract = interface.IWETH(wrapped)
    tx = contract.approve(
        "0x6Ae43d3271ff6888e7Fc43Fd7321a503ff738951", value, {"from": address}
    )
    tx.wait(1)
    print(tx)


def depositToken():
    address = getWallet()
    value = amount(0.001)
    wrappedEth = wETHContract()
    contract = interface.ILendingPool("0x6Ae43d3271ff6888e7Fc43Fd7321a503ff738951")
    # address asset, uint256 amount, address onBehalfOf, uint16 referralCode
    contract.supply(wrappedEth, value, address, 0, {"from": address})


def main():
    depositToken()
