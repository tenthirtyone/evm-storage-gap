// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/StorageImplementation.sol";
import "src/Proxy.sol";

contract TestStorageImplementationProxy is Test {
    Proxy proxy;
    StorageImplementation proxyStorage;
    StorageImplementation storageContract;

    function setUp() public {
        storageContract = new StorageImplementation();
        proxy = new Proxy(address(storageContract));
        proxyStorage = StorageImplementation(address(proxy));
    }

    function testSetX() public {
        proxyStorage.setX(10);
        assertEq(proxyStorage.getX(), 10);
    }
}
