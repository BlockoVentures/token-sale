const BLOCPresale   = artifacts.require("./BLOCPresale.sol");
const BLOCCrowdsale = artifacts.require("./BLOCCrowdsale.sol");

module.exports = function(deployer, network, accounts) {

    const wallet       = accounts[0];
    const presaleStart = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 1;
    const presaleEnd   = presaleStart + (86400 * 30); // 30 days
    const saleEnd      = presaleEnd + (86400 * 30); // 30 days

    deployer.deploy(BLOCPresale, presaleStart, presaleEnd, wallet);
    deployer.deploy(BLOCCrowdsale, presaleStart, saleEnd, wallet);
};