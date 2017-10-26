const BLOCPresale   = artifacts.require("./BLOCPresale.sol");
const BLOCCrowdsale = artifacts.require("./BLOCCrowdsale.sol");

module.exports = function(deployer, network, accounts) {

    const wallet       = accounts[0];
    const presaleStart = 1509042600; // Thursday, October 26, 2017 6:30:00 PM
    const presaleEnd   = 1509043200; // Thursday, October 26, 2017 6:40:00 PM
    const saleEnd      = 1509128400; // Thursday, October 27, 2017 6:20:00 PM

    deployer.deploy(BLOCPresale, presaleStart, presaleEnd, wallet, { gas: 7000000 });
    deployer.deploy(BLOCCrowdsale, presaleEnd, saleEnd, wallet, { gas: 7000000 });
};