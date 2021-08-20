const base = artifacts.require("testbase");
const factory = artifacts.require("CloneFactory");


module.exports = function (deployer) {
  deployer.deploy(base).then(()=>{
    return deployer.deploy(factory, base.address );
  })
};
