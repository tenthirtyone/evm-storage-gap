pragma solidity 0.8.28;

import "src/StorageImplementationPost.sol";

contract StorageImplementationPostInheritance is StorageImplementationPost {
    uint256 public z;

    uint256[48] private __datgap;

    function setZ(uint256 z_) external {
        z = z_;
    }

    function getZ() external view returns (uint256) {
        return z;
    }
}
