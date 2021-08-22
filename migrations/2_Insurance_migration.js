const insuranceA = artifacts.require("insuranceA");
const insuranceB = artifacts.require("insuranceB");
const factory = artifacts.require("CloneFactory");

module.exports = function (deployer) {
  deployer.deploy(insuranceA);
  deployer.deploy(insuranceB).then(()=>{return deployer.deploy(factory, insuranceA.address, insuranceB.address); } );
};

