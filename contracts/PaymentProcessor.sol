pragma solidity ^0.8.12;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './Vine.sol';

contract PaymentProcessor {
  address public admin;
  IERC20 public dai;
  ERC20 public vine;

  event PaymentDone(
    address payer,
    uint amount,
    uint paymentId,
    uint date
  )

  constructor(address adminAddress, address daiAddress) public {
    admin = adminAddress;
    dai = IERC20(daiaddress);
  }

  function pay(uint amount, uint paymentId) external {
    dai.transferFrom(msg.sender, admin, amount);
    vine.customerPaid(msg.sender, amount);
    emit PaymentDone(msg.sender, amount, paymentId, block.timestamp)
    //Todo: aupdate vine token `customers` mapping with
  }

  //
}
