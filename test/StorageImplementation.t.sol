// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/StorageImplementation.sol";

contract TestStorageImplementation is Test {
    StorageImplementation storageContract;

    function setUp() public {
        storageContract = new StorageImplementation();
    }

    function testSetX() public {
        storageContract.setX(10);
        assertEq(storageContract.getX(), 10);
    }
}
