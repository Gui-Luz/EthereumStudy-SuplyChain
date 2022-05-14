pragma solidity 0.8.0;
import "./Warehouse.sol";
// "SPDX-License-Identifier: UNLICENSED"

contract WarehouseFactory {
    address public owner;
    address[] warehouses;
    Warehouse newWarehouse;
    event warehouseCreation(address warehouseAddress, string description);

    constructor() {
        owner = msg.sender;
    }

    function createWarehouse(string memory _description) public {
        newWarehouse = new Warehouse(_description, msg.sender);
        warehouses.push(address(newWarehouse));
        emit warehouseCreation(address(newWarehouse), _description);
    }

    function getWarehouses() public view returns (address[] memory) {
        return warehouses;
    }
}