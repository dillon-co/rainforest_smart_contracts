pragma solidity ^0.8.12;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './Vine.sol';

contract PaymentProcessor {
  address payable admin;
  address payable charityTreasury;
  address payable researchTreasury;
  address payable creativeTreasury;
  address payable operationsTreasury;

  ERC20 public vine;

  event PaymentDone(
    address payer,
    uint amount,
    uint paymentId,
    uint date
  );

  constructor(address payable adminAddress,
              address payable charityAddress,
              address payable researchAddress,
              address payable creativesAddress,
              address payable operationsAddress) public {
    charityTreasury    = charityAddress;
    researchTreasury   = researchAddress;
    creativeTreasury = creativesAddress;
    operationsTreasury = operationsAddress;
    admin              = adminAddress;
  }

  // Pass in % of funds that should got to each treasury. (e.g. 20 for 20%). All percents should add up to 100.
  // Fixed point numbers arent fully supported, hence the funky math.
  function pay(uint charityAmount, uint researchAmount, uint creativeAmount, uint operationsAmount, uint paymentId) external {
    require((charityAmount + researchAmount + creativeAmount + operationsAmount) == 100);

    charityTreasury.transfer((msg.value*charityAmount)/100);
    researchTreasury.transfer((msg.value*researchAmount)/100);
    creativeTreasury.transfer((msg.value*creativeAmount)/100);
    operationsTreasury.transfer((msg.value*operationsAmount)/100);

    vine.customerPaid(msg.sender, msg.value);
    emit PaymentDone(msg.sender, msg.value, paymentId, block.timestamp);
  }
}
