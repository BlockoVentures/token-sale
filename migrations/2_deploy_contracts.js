const BLOCPresale   = artifacts.require("./BLOCPresale.sol");
const BLOCCrowdsale = artifacts.require("./BLOCCrowdsale.sol");

module.exports = function(deployer, network, accounts) {

    const wallet       = accounts[0];
    const presaleStart = 1509042600; // Thursday, October 26, 2017 6:30:00 PM
    const presaleEnd   = 1509043200; // Thursday, October 26, 2017 6:40:00 PM
    const saleEnd      = 1509128400; // Thursday, October 27, 2017 6:20:00 PM

    console.log(wallet);
    
    deployer.deploy(BLOCPresale, presaleStart, presaleEnd, wallet, {
        from: "0x0407546e772f459c190375b59a89fda58ae7ef92",
        gas: 31500
    });

    deployer.deploy(BLOCCrowdsale, presaleEnd, saleEnd, wallet, {
        from: "0x0407546e772f459c190375b59a89fda58ae7ef92",
        gas: 31500
    });
};