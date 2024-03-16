from brownie import network, accounts, config
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


def ledingPoolAddressProvider():
    return config["wallets"][network.show_active()]["leandingPoolAddressProvider"]


def aggregatorV3():
    return config["wallets"][network.show_active()]["aggregatorV3Contract"]
