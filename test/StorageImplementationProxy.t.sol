// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/StorageImplementation.sol";
import "src/StorageImplementationPre.sol";
import "src/StorageImplementationPost.sol";
import "src/StorageImplementationPostV2.sol";
import "src/StorageImplementationPostInheritance.sol";

import "src/Proxy.sol";

contract TestStorageImplementationProxy is Test {
    // Proxy Interfaces
    Proxy proxy;
    StorageImplementation proxyStorage;
    StorageImplementationPre proxyStoragePre;

    StorageImplementationPost proxyStoragePost;
    StorageImplementationPostV2 proxyStoragePostV2;
    StorageImplementationPostInheritance proxyStoragePostInheritance;

    // Implementation Addresses
    address storageContract;
    address storagePre;
    address storagePost;
    address storagePostV2;
    address storagePostInheritance;

    function setUp() public {
        storageContract = address(new StorageImplementation());
        storagePre = address(new StorageImplementationPre());

        storagePost = address(new StorageImplementationPost());
        storagePostV2 = address(new StorageImplementationPostV2());
        storagePostInheritance = address(
            new StorageImplementationPostInheritance()
        );

        proxy = new Proxy(storageContract, address(this), "");

        // We have 1 proxy with three different interfaces for the same storage.
        proxyStorage = StorageImplementation(address(proxy));

        proxyStorage.initialize();
    }

    // ############################################################
    // StorageImplementation
    // ############################################################

    function test_SetXProxy() public {
        proxyStorage.setX(10);

        assertEq(proxyStorage.getX(), 10);
        assertEq(proxyStorage.getDatGap(0), 0);
        assertEq(proxyStorage.getDatGap(49), 0);
        assertEq(proxyStorage.lastValue(), 9001);
    }

    // ############################################################
    // StorageImplementationPre
    // ############################################################

    // This is desirable storage with the gap tmk. New storage slots have a fixed position on the storage mapping
    function test_PreTests() public {
        proxyStorage.setX(10);
        // Edit slot 1
        proxyStorage.setDatGap(0, 100);

        proxy.upgradeToAndCall(storagePre, "");

        proxyStoragePre = StorageImplementationPre(address(proxy));

        assertEq(proxyStoragePre.getX(), proxyStorage.getX());

        // Y is now in slot 1
        assertEq(proxyStoragePre.getY(), 100);
        proxyStoragePre.setY(999);
        assertEq(proxyStoragePre.getY(), 999);

        // Switch back to original implementation
        proxy.upgradeToAndCall(storageContract, "");

        assertEq(proxyStorage.getX(), 10);
        assertEq(proxyStorage.getDatGap(0), 999); // Slot 0 is now 999
        assertEq(proxyStorage.getDatGap(49), 0);
        assertEq(proxyStorage.lastValue(), 9001);
    }

    // ############################################################
    // StorageImplementationPost
    // ############################################################

    function test_PostTests() public {
        proxyStorage.setX(10);
        // Edit slot 50
        proxyStorage.setDatGap(49, 100);

        proxy.upgradeToAndCall(storagePost, "");

        proxyStoragePost = StorageImplementationPost(address(proxy));

        assertEq(proxyStoragePost.getX(), proxyStorage.getX());

        // Y is now in slot 50
        assertEq(proxyStoragePost.getY(), 100);
        proxyStoragePost.setY(999);
        assertEq(proxyStoragePost.getY(), 999);

        // Switch back to original implementation
        proxy.upgradeToAndCall(storageContract, "");

        assertEq(proxyStorage.getX(), 10);
        assertEq(proxyStorage.getDatGap(0), 0);
        assertEq(proxyStorage.getDatGap(49), 999); // Slot 50 is now 999
        assertEq(proxyStorage.lastValue(), 9001);
    }

    // BUGGED
    // Variables after the gap can slide into lower storage slots on an upgrade
    function test_PostTests_V2() public {
        proxyStorage.setX(10);
        proxyStorage.setDatGap(49, 100);
        proxy.upgradeToAndCall(storagePost, "");
        proxyStoragePost = StorageImplementationPost(address(proxy));
        proxyStoragePost.setY(999);

        assertEq(proxyStoragePost.getY(), 999);

        proxy.upgradeToAndCall(storagePostV2, "");
        proxyStoragePostV2 = StorageImplementationPostV2(address(proxy));

        assertEq(proxyStoragePostV2.getY(), 0);
        assertEq(proxyStoragePostV2.getZ(), 999);

        proxyStoragePostV2.setY(420);
        // Switch back to original implementation
        proxy.upgradeToAndCall(storageContract, "");

        assertEq(proxyStorage.getX(), 10);
        assertEq(proxyStorage.getDatGap(0), 0);
        assertEq(proxyStorage.getDatGap(48), 420);
        assertEq(proxyStorage.getDatGap(49), 999);
        assertEq(proxyStorage.lastValue(), 9001);
    }

    // BUGGED
    function test_PostTests_Inheritance() public {
        proxyStorage.setX(10);
        proxyStorage.setDatGap(49, 49);
        proxyStorage.setDatGap(48, 48);
        proxy.upgradeToAndCall(storagePost, "");
        proxyStoragePost = StorageImplementationPost(address(proxy));
        proxyStoragePost.setY(999);

        assertEq(proxyStoragePost.getY(), 999);

        proxy.upgradeToAndCall(storagePostInheritance, "");
        proxyStoragePostInheritance = StorageImplementationPostInheritance(
            address(proxy)
        );

        console.log(proxyStoragePostInheritance.getX());
        console.log(proxyStoragePostInheritance.getY());
        console.log(proxyStoragePostInheritance.getZ());
        console.log(proxyStoragePostInheritance.lastValue());
        console.log(proxyStoragePostInheritance.getDatGap(0));
        console.log(proxyStoragePostInheritance.getDatGap(48));
        console.log(proxyStoragePostInheritance.getDatGap(49));
    }
}
