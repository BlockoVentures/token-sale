pragma solidity ^0.4.15;

import "zeppelin-solidity/contracts/token/PausableToken.sol";
import "zeppelin-solidity/contracts/token/MintableToken.sol";
import "zeppelin-solidity/contracts/token/BurnableToken.sol";

contract BLOCToken is PausableToken, MintableToken {

    string public constant symbol = "BLOC";
    string public constant name = "BlockCapital BLOC";
    uint8 public constant decimals = 18;

}