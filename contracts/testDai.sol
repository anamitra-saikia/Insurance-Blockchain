// SPDX-License-Identifier: UNLICENSED


 //Dai Token Minter for development in test net


pragma solidity ^0.8.0 ;

import './OpenZeppelin/ERC20.sol' ;

contract dai is ERC20{
    constructor() ERC20("Dai" , "DAI")  {}

    function faucet(address _receiver , uint _amount) external {
        _mint(_receiver , _amount) ;
    }
}

