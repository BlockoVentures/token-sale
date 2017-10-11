'use strict';

const assertJump = require('./helpers/assertJump');

const BLOCCrowdsale = artifacts.require('BLOCCrowdsale');
const BLOCToken     = artifacts.require('BLOCToken');

contract('BLOCCrowdsale', (accounts) => {

    let crowdsale, token;

    let owner = accounts[0],
        other = accounts[1];

    // Set up
    beforeEach(async function() {

        const startTime = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 1;
        const endTime   = startTime + (86400); // 1 days

        crowdsale = await BLOCCrowdsale.new(startTime, endTime, owner);
        token     = BLOCToken.at(await crowdsale.token());
    });

    it('token starts paused', async () => {
        const paused = await token.paused();
        assert(paused, true);
    });

    it('owner should be able to change wallet', async () => {
        await crowdsale.setWallet(other);
        let newWallet = await crowdsale.wallet();
        assert.equal(other, newWallet);
    });

    it('non-owner should not be able to change wallet', async () => {

        const owner = await crowdsale.owner();
        assert.notEqual(owner, other);

        try {
            await crowdsale.setWallet(other, {from: other});
            assert.fail('should have thrown before');
        } catch (error) {
            assertJump(error);
        }
    });

    it('owner should not be able to unpause token until token sale is finished', async () => {
        try {
            await crowdsale.unpauseToken();
            assert.fail('should have thrown before');
        } catch (error) {
            assertJump(error);
        }
    });

    it('non-owner should not be able to unpause token until token sale', async () => {
        try {
            await crowdsale.unpauseToken({from: other});
            assert.fail('should have thrown before');
        } catch (error) {
            assertJump(error);
        }
    });

    // TODO: Write sale specific tests
});