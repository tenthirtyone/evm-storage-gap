// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/StorageImplementation.sol";
import "src/StorageImplementationPre.sol";
import "src/StorageImplementationPost.sol";
import "src/Proxy.sol";

contract TestStorageImplementationProxy is Test {
    Proxy proxy;
    StorageImplementation proxyStorage;

    address storageContract;
    address storagePre;
    address storagePost;

    function setUp() public {
        storageContract = address(new StorageImplementation());
        storagePre = address(new StorageImplementationPre());
        storagePost = address(new StorageImplementationPost());

        proxy = new Proxy(storageContract);
        proxyStorage = StorageImplementation(address(proxy));
        proxyStorage.initialize();
    }

    // ############################################################
    // StorageImplementation
    // ############################################################

    function test_SetXProxy() public {
        proxyStorage.setX(10);

        assertEq(proxyStorage.getX(), 10);
        assertEq(proxyStorage.__datgap(0), 0);
        assertEq(proxyStorage.__datgap(49), 0);
        assertEq(proxyStorage.lastValue(), 9001);
    }

    // ############################################################
    // StorageImplementationPre
    // ############################################################
}
