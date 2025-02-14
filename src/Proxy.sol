import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract Proxy is TransparentUpgradeableProxy {
    constructor(
        address _logic,
        address initialOwner,
        bytes memory _data
    ) TransparentUpgradeableProxy(_logic, initialOwner, _data) {}

    function upgradeToAndCall(
        address newImplementation,
        bytes memory data
    ) public payable {
        ERC1967Utils.upgradeToAndCall(newImplementation, data);
    }

    function implementation() public view returns (address) {
        return ERC1967Utils.getImplementation();
    }
}
