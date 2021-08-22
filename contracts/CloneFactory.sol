// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0 ;

import "./CloneDeterministic.sol" ;
import "./Insurance.sol" ;

contract CloneFactory{
    
    address public admin ;
    address public implementationA ;
    address public implementationB ;  
    
    constructor(address _addrA , address _addrB){
        admin = msg.sender ;
        implementationA = _addrA ;
        implementationB = _addrB ;
    }
    
    modifier onlyAdmin(){
        require(msg.sender == admin, 'Access Denied : Not Admin') ;
        _;
    }
     

    function makeCloneA(address _pHolder, string memory _ipfs, string memory _id) public onlyAdmin{
        bytes32 salt = keccak256(abi.encodePacked(_id)) ;
        address clone = CloneDeterministic.cloneDeterministic(implementationA, salt) ;
        insuranceA(clone).initialize(_pHolder , _ipfs) ;
    }


    function makeCloneB(address _pHolder, string memory _ipfs, string memory _id) public onlyAdmin{
        bytes32 salt = keccak256(abi.encodePacked(_id)) ;
        address clone = CloneDeterministic.cloneDeterministic(implementationB, salt) ;
        insuranceB(clone).initialize(_pHolder , _ipfs) ;
    }


    function getAddressA(string memory _id)public view returns(address) {
        bytes32 salt = keccak256(abi.encodePacked(_id)) ;
        address clone = CloneDeterministic.predictAddress(implementationA,salt) ;
        return clone ;
    }


    function getAddressB(string memory _id)public view returns(address) {
        bytes32 salt = keccak256(abi.encodePacked(_id)) ;
        address clone = CloneDeterministic.predictAddress(implementationB,salt) ;
        return clone ;
    }
}