pragma solidity 0.8.28;

contract StorageImplementationPre {
    uint256 public x;
    uint256[50] public __datgap;

    function setX(uint256 x_) external {
        x = x_;
    }

    function getX() external view returns (uint256) {
        return x;
    }
}
