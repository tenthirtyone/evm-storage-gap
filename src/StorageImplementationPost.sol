pragma solidity 0.8.28;

contract StorageImplementationPost {
    uint256 public x;
    uint256[49] private __datgap;
    uint256 public y;

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

    function getDatGap(uint256 index) external view returns (uint256) {
        return __datgap[index];
    }

    function setY(uint256 y_) external {
        y = y_;
    }

    function getY() external view returns (uint256) {
        return y;
    }

    function readStorageSlot(uint256 slot) public view returns (bytes32) {
        // Assembly block to read storage slot
        bytes32 data;
        assembly {
            // Use SLOAD to read from the storage slot
            data := sload(slot)
        }

        return data;
    }

    function readStorageSlotAsUint(uint256 slot) public view returns (uint256) {
        bytes32 data = readStorageSlot(slot);
        return uint256(data);
    }
}
