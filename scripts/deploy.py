from brownie import DeFi, interface
from scripts.modules import (
    getWallet,
    amount,
    wETHContract,
    ledingPoolAddressProvider,
    aggregatorV3,
)

# 0xA65000645b9D4905260B63BCf5474a9D7EEB4834


def deploy_defi():
    address = getWallet()
    ether = amount(10)
    weth = wETHContract()
    pool = ledingPoolAddressProvider()
    priceFeed = aggregatorV3()
    contract = DeFi.deploy(
        weth,
        pool,
        priceFeed,
        {
            "from": address,
        },
    )


def get_weth():
    address = getWallet()
    ether = amount(0.001)
    contract = DeFi[-1]
    deposit = contract.convertToWETH({"from": address, "value": ether})
    print(deposit)


def get_amount():
    address = getWallet()
    contract = DeFi[-1]
    balance = contract.wETHBalance({"from": address})
    print(balance)


def get_pool():
    address = getWallet()
    contract = DeFi[-1]
    pool = contract.addressPool()
    print(pool)


def main():
    deploy_defi()
