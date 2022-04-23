pragma solidity ^0.8.12

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openseppellin//contracts/utils/Arrays.sol'

contract Vine is ERC20 {

  struct customer {
    bool paid,
    bool packageSent,
    uint amountBought;
  }

  new mapping (address => customer) public customers
  address paymentProcessor;
  address shippersAddress;


  constructor(address paymentProcessor, address shipper) ERC20('Vine Governence Token', 'VINE') {}
     paymentProcessor = paymentProcessor;
     shippersAddress = shipper
  }


  function customerPaid(address _customer, uint _amountBought) public {
    require(
      msg.sender == paymentProcessor,
      'Only the paymentProcessor contract can call this function'
    );

    customers[_customer].paid = true;
    customers[_customer].amountBought = _amountBought
  }

  function packageSent(address _customer) public {
    requre(
      msg.sender == supplier && customers[_customer].paid,
      "Only the supplier can update this value"
    )

    customers[_customer].packageSent = true
  }

  function mintToBuyer(address _customer) public {
    require(
        (customers[_minter].paid && customers[_minter].packageSent),
        "Wallet needs to have bought and recieved package to mint tokens."
      )
    uint tokensReceived = customers[_customer].amountBought * 100;
    _mint(_customer, tokensReceived);

    // zero out customer
    customers[_customer].paid = false;
    customers[_customer].packageSent = false;
    customers[_customer].amountBought = 0;
  }
}
