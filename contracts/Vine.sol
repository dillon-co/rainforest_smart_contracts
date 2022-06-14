llpragma solidity ^0.8.12;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

// To ensure digital scarcity of the token, the minting is
// tied to the purchase of goods and services.
// A customer needs to pay for goods throught the paymentProcessor
// contract and need to have been sent the product by the supplier in order to have minted tokens.

contract Vine is ERC20 {
  address payable admin;
  address payable charityTreasury;
  address payable researchTreasury;
  address payable creativeTreasury;
  address payable operationsTreasury;

  uint productCount;

  Vine public vine;

  event PaymentDone(
    address payer,
    uint amount,
    uint date
  );

  struct supplier{
    string name;
    bool active;
  }

  struct customer {
    bool paid;
    bool packageSent;
    uint amountBought;
    uint tokensMined;
  }

  struct product {
    string name;
    uint priceInWei;
    uint amount;
  }

  mapping (address => supplier) public suppliers;
  mapping (address => customer) public customers;
  mapping (uint => product) public products;

  constructor(address payable _adminAddress,
              address payable _charityAddress,
              address payable _researchAddress,
              address payable _creativesAddress,
              address payable _operationsAddress) ERC20('Vine Governence Token', 'VINE') {
     admin              = _adminAddress;
     charityTreasury    = _charityAddress;
     researchTreasury   = _researchAddress;
     creativeTreasury   = _creativesAddress;
     operationsTreasury = _operationsAddress;
     suppliers[_adminAddress].active = true;
     suppliers[_adminAddress].name = "Admin";
     productCount = 0;
     setProduct("1 Coffee Bag", 17000000000000000, 1);
     setProduct("3 Coffee Bags", 44000000000000000, 3);
  }

  function addSupplierAddress(address payable _supplier, string memory _supplierName) public {
    require(msg.sender == admin, "Only admin can add suppliers");

    suppliers[_supplier].active = true;
    suppliers[_supplier].name = _supplierName;
  }

  function customerPaid(address _customer, uint _amountBought) internal {
    customers[_customer].paid = true;
    customers[_customer].amountBought = _amountBought;
  }

  function sendSampleBag(address _customer) public {
    require(msg.sender == admin, "Only admin can send sample bags");

    customers[_customer].paid = true;
    customers[_customer].amountBought = 1;
    customers[_customer].packageSent = true;
  }

  function customerPaidOnDifferentChain(address _customer, uint _amountBought) public {
    require(
      (msg.sender == admin),
      "Only the admin can call this function"
    );

    customerPaid(_customer, _amountBought);
  }

  function packageSent(address _customer) public {
    require(
      suppliers[msg.sender].active,
      "Only the supplier can update this value"
    );

    require(
      customers[_customer].paid,
      "Customer has not paid for order."
    );

    customers[_customer].packageSent = true;
  }

  function setProduct(string memory _name, uint _priceInWei, uint _amount) public {
    require(msg.sender == admin, "Only the admin can add products");
    productCount += 1;
    products[productCount].name = _name;
    products[productCount].priceInWei = _priceInWei;
    products[productCount].amount = _amount;
  }

  function updateProduct(uint pdoductId, string memory _name, uint _priceInWei, uint _amount) public {
    require(msg.sender == admin, "Only the admin can add products");
    productCount += 1;
    products[productId].name = _name;
    products[productId].priceInWei = _priceInWei;
    products[productId].amount = _amount;
  }

  function mintToBuyer(address _customer) public {
    require(customers[_customer].paid, "Wallet needs to have bought something to mint tokens.");
    require(customers[_customer].packageSent, "You have to receive your package before you can mint tokens");
    uint tokensReceived = customers[_customer].amountBought * 100;

    _mint(_customer, tokensReceived);

    // zero out customer
    customers[_customer].paid = false;
    customers[_customer].packageSent = false;
    customers[_customer].amountBought = 0;
    customers[_customer].tokensMined += tokensReceived;
  }

  function buyProduct(uint _charityAmount, uint _researchAmount, uint _creativeAmount, uint _productId) external payable {
    require(
      (_charityAmount + _researchAmount + _creativeAmount + 50) == 100,
      "Amount sent to all accounts must equal 100"
    );
    uint price = products[_productId].priceInWei;
    require(
      msg.value >= price,
      "Unable to complete purchase. You must send the correct amount"
    );
    require(
      customers[msg.sender].amountBought < 4,
      "You can only buy 3 at a time"
    );

    charityTreasury.call{value: (price*(_charityAmount/100))};
    researchTreasury.call{value: (price*(_researchAmount/100))};
    creativeTreasury.call{value: (price*(_creativeAmount/100))};
    operationsTreasury.call{value: (price / 2)};

    customerPaid(msg.sender, products[_productId].amount);
    emit PaymentDone(msg.sender, msg.value, block.timestamp);
  }

  function getAdmin() public view returns (address) {
    return admin;
  }

  function addressIsAdmin(address _address) public view returns (bool) {
    return(_address == admin);
  }
}
