from brownie import DeFi
from scripts.modules import getWallet, amount


def test_balance():
    contract = DeFi[-1]
    address = getWallet()
    wrappedEthBalance = contract.wETHBalance({"from": address})
    ether = amount(0.1)
    assert wrappedEthBalance > ether


def test_interactionBalance():
    contract = DeFi[-1]
    value = amount(0.001)
    address = getWallet()
    depositEther = contract.convertToWETH({"from": address, "value": value})

    protocolBalance = contract.checkAmountDeposited({"from": address})

    assert protocolBalance == value
