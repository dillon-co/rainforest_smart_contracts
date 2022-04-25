const Vine = artifacts.require("Vine.sol");
const PaymentProcessor = artifacts.require("PaymentProcessor.sol");

module.exports = function (deployer, network, addresses) {

  if(network === 'develop') {
    const [admin, payer, charity, research, creative, operations, _] = addresses;
  } else {
    const admin = '';
    const charity = '';
    const research = '';
    const creative = '';
    const operations = '';
  }
  
  await deployer.deploy(PaymentProcessor, admin, charity, research, creative, operations);
  const paymentProcessor = await PaymentProcessor.deployed();

  await deployer.deploy(Vine, paymentProcessor.address, admin);
};
