const Vine = artifacts.require("Vine.sol");

module.exports = async function (deployer, network, addresses) {

  // if(network === 'develop') {
    // console.log(addresses);
    // var [admin, payer, charity, research, creative, operations, _] = addresses;
    // console.log(admin)
    //
    // await deployer.deploy(Vine, admin, charity, research, creative, operations);
    // const vine = await Vine.deployed();
    const admin_address = '0x56E8BD20021A361c5fe2D73E825fA237c5850d04';
    const charity_address = '0x0fF8a6347E9dE1eB20Ddf07169F0f7A5e4207866';
    const research_address = '0xCe31d04E8A1A9134F0f1618a4ceDE356DCEd6263';
    const creative_address = '0x7575968f5089247E7b9fC7e1A8BC8f67a4639357';
    const operations_address = '0x0ACA0275DdEDd4D955519879a287e0EC326243DA';

    await deployer.deploy(Vine, admin_address, charity_address, research_address, creative_address, operations_address)

  // } else {
  // }
};
