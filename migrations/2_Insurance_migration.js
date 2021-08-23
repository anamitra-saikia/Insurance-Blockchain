const insuranceA = artifacts.require("insuranceA");
const insuranceB = artifacts.require("insuranceB");
const pay = artifacts.require("PaymentProcessor");
const Dai = artifacts.require("dai");
const factory = artifacts.require("CloneFactory");

module.exports = async function (deployer , network , addresses) {

  if(network === 'develop'){
    await deployer.deploy(Dai) ;

    await deployer.deploy(insuranceA);
    await deployer.deploy(insuranceB);
    await deployer.deploy(pay, addresses[5] , Dai.address) ;
    await deployer.deploy(factory, insuranceA.address, insuranceB.address , pay.address);

    const dai = await Dai.deployed() ;
    for (let i = 1; i < 4; i++) {
      await dai.faucet(addresses[i] , web3.utils.toWei('1000000')) ;
    }

    let f = await factory.deployed() ;
    console.log(await f.paymentProcessor()) ;
    console.log(await f.implementationA()) ;
    console.log(await f.implementationB()) ;
    
  }
};

