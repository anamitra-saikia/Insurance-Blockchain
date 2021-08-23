// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0 ;

import "./CloneDeterministic.sol" ;
import "./Insurance.sol" ;

contract CloneFactory{
    
    address public admin ;
    address public implementationA ;
    address public implementationB ;
    address public paymentProcessor ;
    //address public clone ;  
    
    constructor(address _addrA , address _addrB, address _pay){
        admin = msg.sender ;
        implementationA = _addrA ;
        implementationB = _addrB ;
        paymentProcessor = _pay ; 
    }
    
    modifier onlyAdmin(){
        require(msg.sender == admin, 'Access Denied : Not Admin') ;
        _;
    }
     
    event cloneGen(
        address indexed policyholder,
        address deployed,
        string ID
    ) ;

    function makeCloneA(address _pHolder, string memory _ipfs, uint64 _premiumAmount, string memory _id) public onlyAdmin{
        bytes32 salt = keccak256(abi.encodePacked(_id)) ;
        address clone = CloneDeterministic.cloneDeterministic(implementationA, salt) ;
        insuranceA(clone).initialize(_pHolder , _ipfs, _premiumAmount, paymentProcessor) ;
        emit cloneGen(_pHolder, clone, _id);
    }


    function makeCloneB(address _pHolder, string memory _ipfs, uint64 _premiumAmount, string memory _id) public onlyAdmin{
        bytes32 salt = keccak256(abi.encodePacked(_id)) ;
        address clone = CloneDeterministic.cloneDeterministic(implementationB, salt) ;
        insuranceB(clone).initialize(_pHolder , _ipfs, _premiumAmount, paymentProcessor) ;
        emit cloneGen(_pHolder, clone, _id);
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