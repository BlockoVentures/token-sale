const BLOCCrowdsale = artifacts.require("./BLOCCrowdsale.sol");

module.exports = function(deployer, network, accounts) {

    // const startTime = 1511827200;
    const startTime = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 1;
    const endTime   = startTime + (86400 * 30); // 30 days
    const wallet    = accounts[0];

    deployer.deploy(BLOCCrowdsale, startTime, endTime, wallet);
};