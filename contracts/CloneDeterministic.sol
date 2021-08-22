// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

/*
 * EIP 1167 Clone/Minimal Proxy deployer
 * Code source : OpenZeppelin Library
 * This library includes function to create clone using the create2 opcode (salted deterministic deployment)
 * [create2 opcode] new_address = hash(0xFF, sender, salt, bytecode)
 * Salt : bytes32 salt = keccak256(abi.encodePacked(ID))
 */
 
library CloneDeterministic {

    // CloneDeterministic() : Generated a minimal proxy on the determined address 
    
    function cloneDeterministic(address source, bytes32 salt) internal returns (address instance) {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(ptr, 0x14), shl(0x60, source))
            mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
            instance := create2(0, ptr, 0x37, salt)
        }
        require(instance != address(0), "create2 contract deployment failed");
    }


    // Computes the address of a clone deployed using {Clones-cloneDeterministic}.
    
    function predictAddress(address source, bytes32 salt, address deployer) internal pure returns (address predicted) {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(ptr, 0x14), shl(0x60, source))
            mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf3ff00000000000000000000000000000000)
            mstore(add(ptr, 0x38), shl(0x60, deployer))
            mstore(add(ptr, 0x4c), salt)
            mstore(add(ptr, 0x6c), keccak256(ptr, 0x37))
            predicted := keccak256(add(ptr, 0x37), 0x55)
        }
    }


    // Computes the address of a clone deployed using {Clones-cloneDeterministic}.

    function predictAddress(address source, bytes32 salt)
        internal
        view
        returns (address predicted)
    {
        return predictAddress(source, salt, address(this));
    }
}
