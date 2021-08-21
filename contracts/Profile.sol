// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0 ;
contract Profile{
    
    address public user ;
    address public manager ;
    address insurancepolicy ;
    bool verified = false ;
    
    constructor(address _manager) {
        manager = _manager ;
        user = msg.sender ;
    }
    
    modifier onlyManager(){
        require(msg.sender == manager) ;
        _;
    }
}