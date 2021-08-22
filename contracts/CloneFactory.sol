// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0 ;

import "./Clones.sol" ;
import "./testbase.sol" ;


contract CloneFactory{
    
    address public owner ;
    address public base ; 
    address public  proxy ;
    address public padd ;
    
    constructor(address _addr){
        owner = msg.sender ;
        base = _addr ;
    }
    
    modifier onlyAdmin(){
        require(msg.sender == owner, 'Access Denied') ;
        _;
    }
     
    function cloneGen(string memory _text, uint _number) public onlyAdmin{
        proxy = Clones.clone(base) ;
       testbase(proxy).initialize(_text , _number) ;
    }


    function cloneD(string memory _text, uint _number, string memory _id) public onlyAdmin{
        bytes32 salt = keccak256(abi.encodePacked(_id)) ;
        proxy = Clones.cloneDeterministic(base, salt) ;
        testbase(proxy).initialize(_text , _number) ;
    }

    function predict(string memory _id)public {
        bytes32 salt = keccak256(abi.encodePacked(_id)) ;
        padd = Clones.predictDeterministicAddress(base,salt) ;
    }
}