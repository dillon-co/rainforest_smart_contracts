pragma solidity ^0.8.12;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './Vine.sol';

contract PaymentProcessor {
  address public admin;
  address public charityTreasury
  address public researchTreasury
  address public createivesTreasury
  address public operationsTreasury

  ERC20 public vine;

  event PaymentDone(
    address payer,
    uint amount,
    uint paymentId,
    uint date
  )

  struct paySplits {
    uint charity
    uint research
    uint creatives
    uint operations
  }

  constructor(address adminAddress, address daiAddress,
                                    address charityAddress,
                                    address rnDAddress,
                                    address createivesAddress,
                                    address operationsAddress) public {
    charityTreasury    = charityAddress
    researchTreasury   = researchAddress
    createivesTreasury = createivesAddress
    operationsTreasury = operationsAddress
    admin              = adminAddress;
  }

  // Pass in % of funds that should got to each treasury. (e.g. 20 for 20%). All percents should add up to 100.
  // Fixed point numbers arent fully supported, hence the funky math.
  function pay(uint charityAmount, uint researchAmount, uint creativeAmount, uint operationsAmount, uint paymentId) external {
    require((charityAmount + researchAmount + creativeAmount + operationsAmount) == 100)

    charityTreasury.transfer((msg.value*charityAmount)/100);
    researchTreasury.transfer((msg.value*researchAmount)/100);
    creativeTreasury.transfer((msg.value*creativeAmount)/100);
    operationsTreasury.transfer((msg.value*operationsAmount)/100);

    vine.customerPaid(msg.sender, msg.value);
    emit PaymentDone(msg.sender, msg.value, paymentId, block.timestamp)
  }
}
