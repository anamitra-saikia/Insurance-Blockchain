const insurance = artifacts.require("insuranceCL");

module.exports = function (deployer) {
  deployer.deploy(insurance);
};
