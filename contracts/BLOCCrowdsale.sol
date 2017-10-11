pragma solidity ^0.4.15;

import "zeppelin-solidity/contracts/crowdsale/Crowdsale.sol";
import "zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol";
import "zeppelin-solidity/contracts/crowdsale/FinalizableCrowdsale.sol";
import "zeppelin-solidity/contracts/crowdsale/RefundableCrowdsale.sol";
import "./BLOCToken.sol";

// RefundableCrowdsale
contract BLOCCrowdsale is CappedCrowdsale, RefundableCrowdsale {

    using SafeMath for uint256;

    uint256 constant TOTAL_SHARE = 100;
    uint256 constant CROWDSALE_SHARE = 90;
    uint256 constant DEV_SHARE = 10;

    uint256 constant TOKEN_PER_ETH_ROUND_1 = 390;
    uint256 constant TOKEN_PER_ETH_ROUND_2 = 360;
    uint256 constant TOKEN_PER_ETH_ROUND_3 = 345;
    uint256 constant TOKEN_PER_ETH_ROUND_4 = 330;
    uint256 constant TOKEN_PER_ETH_ROUND_5 = 315;
    uint256 constant TOKEN_PER_ETH_ROUND_6 = 300;

    uint256 constant ROUND_1 = 390;
    uint256 constant ROUND_2 = 360 + ROUND_1;
    uint256 constant ROUND_3 = 345 + ROUND_2;
    uint256 constant ROUND_4 = 330 + ROUND_3;
    uint256 constant ROUND_5 = 315 + ROUND_4;
    uint256 constant ROUND_6 = 300 + ROUND_5;

    uint256 public tokensSold = 0;

    event WalletChange(address wallet);

    function BLOCCrowdsale(
        uint256 _startTime,
        uint256 _endTime,
        address _wallet
    )
        CappedCrowdsale(29500 ether)
        RefundableCrowdsale(1900 ether)
        Crowdsale(_startTime, _endTime, TOKEN_PER_ETH_ROUND_1, _wallet)
        FinalizableCrowdsale()
    {
        BLOCToken(token).pause();
    }

    function createTokenContract() internal returns(MintableToken) {
        return new BLOCToken();
    }

    function getRate() public returns (uint256) {

        // Round 1
        uint256 curTokenRate = TOKEN_PER_ETH_ROUND_1;
        uint256 totalSupply = token.totalSupply();

        // Round 2
        if (totalSupply >= (ROUND_1 * 10 ** 18)) {
            curTokenRate = TOKEN_PER_ETH_ROUND_2;
        }

        // Round 3
        if (totalSupply >= (ROUND_2 * 10 ** 18)) {
            curTokenRate = TOKEN_PER_ETH_ROUND_3;
        }

        // Round 4
        if (totalSupply >= (ROUND_3 * 10 ** 18)) {
            curTokenRate = TOKEN_PER_ETH_ROUND_4;
        }

        // Round 5
        if (totalSupply >= (ROUND_4 * 10 ** 18)) {
            curTokenRate = TOKEN_PER_ETH_ROUND_5;
        }

        // Round 6
        if (totalSupply >= (ROUND_5 * 10 ** 18)) {
            curTokenRate = TOKEN_PER_ETH_ROUND_6;
        }

        return curTokenRate;
    }

    function unpauseToken() onlyOwner {
        require(isFinalized);
        BLOCToken(token).unpause();
    }

    function buyTokens(address beneficiary) payable {

        require(beneficiary != 0x0);
        require(validPurchase());

        uint256 weiAmount = msg.value;
        uint256 updatedWeiRaised = weiRaised.add(weiAmount);

        uint256 rate = getRate();

        // calculate token amount to be created
        uint256 tokens = weiAmount.mul(rate);

        // update state
        weiRaised = updatedWeiRaised;
        tokensSold = tokensSold.add(tokens);

        token.mint(beneficiary, tokens);
        TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

        forwardFunds();
    }

    function finalization() internal {

        uint256 totalSupply = token.totalSupply();
        uint256 finalSupply = TOTAL_SHARE.mul(totalSupply).div(CROWDSALE_SHARE);

        // emit tokens for the devs
        token.mint(wallet, DEV_SHARE.mul(finalSupply).div(TOTAL_SHARE));

        token.finishMinting();
        super.finalization();
    }

    function setWallet(address _wallet) onlyOwner {
        require(_wallet != 0x0);
        wallet = _wallet;
        WalletChange(_wallet);
    }
}