pragma solidity 0.8.28;

contract StorageImplementationPre {
    uint256 public x;
    uint256 public y;
    uint256[49] public __datgap;

    uint256 public lastValue = 9001;

    function setX(uint256 x_) external {
        x = x_;
    }

    function getX() external view returns (uint256) {
        return x;
    }

    function setDatGap(uint256 index, uint256 value) external {
        __datgap[index] = value;
    }

    function setY(uint256 y_) external {
        y = y_;
    }

    function getY() external view returns (uint256) {
        return y;
    }
}
