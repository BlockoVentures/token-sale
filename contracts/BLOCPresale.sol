pragma solidity ^0.4.15;

import "zeppelin-solidity/contracts/crowdsale/Crowdsale.sol";
import "zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol";
import "zeppelin-solidity/contracts/crowdsale/FinalizableCrowdsale.sol";
import "zeppelin-solidity/contracts/crowdsale/RefundableCrowdsale.sol";
import "./BLOCToken.sol";

contract BLOCPresale is CappedCrowdsale, RefundableCrowdsale {

    using SafeMath for uint256;

    uint256 constant ROUND_1 = 390;

    uint256 public tokensSold = 0;

    event WalletChange(address wallet);

    function BLOCPresale(
        uint256 _startTime,
        uint256 _endTime,
        address _wallet
    )
        CappedCrowdsale(5935 ether)
        RefundableCrowdsale(1500 ether)
        Crowdsale(_startTime, _endTime, ROUND_1, _wallet)
        FinalizableCrowdsale()
    {
        BLOCToken(token).pause();
    }

    function createTokenContract() internal returns(MintableToken) {
        return new BLOCToken();
    }

    function getRate() public returns (uint256) {
        return ROUND_1;
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

    function setWallet(address _wallet) onlyOwner {
        require(_wallet != 0x0);
        wallet = _wallet;
        WalletChange(_wallet);
    }
}