pragma solidity 0.8.0;
// "SPDX-License-Identifier: UNLICENSED"

contract Item {
    address public warehouse;
    bytes32 public identification;
    bool public available;
    uint public price;
    address public buyer;
    enum Status { InStock, ReadyForShipping, Shipped }
    Status public choice;

    constructor(string memory _identification, uint _price) {
        available = true;
        warehouse = msg.sender;
        identification = sha256(bytes(_identification));
        price = _price;
        choice = Status.InStock;
    }

    function buy() public payable {
        require(!available);
        require(msg.value == price, "Value sent is not equal to price");
        buyer = msg.sender;
        choice = Status.ReadyForShipping;
        available = false;
    }

    function ship() public {
        require(msg.sender == warehouse, "You are not the warehouse of this product");
        choice = Status.Shipped;
    }
}

contract Warehouse {
    address public manager;
    address[] itemsList;
    Item item;

    constructor() {
        manager = msg.sender;
    }

    function createItem(string memory _identification, uint _price) onlyManager public {
        Item newItem = new Item(_identification, _price);
        itemsList.push(address(newItem));
    }

    function getItemsInStock() public view returns (address[] memory) {
        return itemsList;
    }

    function ship(address _existingItemAddress) onlyManager public {
        item = Item(_existingItemAddress);
        item.ship();
    }

    modifier onlyManager() {
        require(manager == msg.sender, "Manager: caller is not the warehouse manager");
        _;
    }
}