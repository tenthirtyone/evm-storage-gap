pragma solidity 0.8.28;
contract StorageImplementation {
    uint256 public x;
    uint256[50] private __datgap;

    uint256 public lastValue;

    function initialize() external {
        lastValue = 9001;
    }

    function setX(uint256 x_) external {
        x = x_;
    }

    function getX() external view returns (uint256) {
        return x;
    }

    function setDatGap(uint256 index, uint256 value) external {
        __datgap[index] = value;
    }

    function getDatGap(uint256 index) external view returns (uint256) {
        return __datgap[index];
    }
}
