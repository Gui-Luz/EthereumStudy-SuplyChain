pragma solidity 0.8.0;
// "SPDX-License-Identifier: UNLICENSED"

contract Item {
    address public warehouse;
    string public product;
    bytes32 public identification;
    bool public available;
    uint public price;
    uint public lastUpdated;
    address public buyer;
    enum Status { InStock, ReadyForShipping, Shipped }
    Status public choice;
    event itemUpdated(address itemAddress, string product, address buyer, uint lastUpdated, Status choice);

    constructor(string memory _product, string memory _identification, uint _price) {
        product = _product;
        available = true;
        warehouse = msg.sender;
        identification = sha256(bytes(_identification));
        price = _price;
        choice = Status.InStock;
        lastUpdated = block.timestamp;
    }

    function buy() public payable {
        require(available, "Item is not available");
        require(msg.value == price, "Value sent is not equal to price");
        buyer = msg.sender;
        choice = Status.ReadyForShipping;
        available = false;
        lastUpdated = block.timestamp;
        emit itemUpdated(address(this), product, buyer, lastUpdated, choice);
    }

    function ship() public {
        require(msg.sender == warehouse, "You are not the warehouse of this product");
        transferPayment();
        choice = Status.Shipped;
        lastUpdated = block.timestamp;
        emit itemUpdated(address(this), product, buyer, lastUpdated, choice);
    }

    function transferPayment() private {
        payable(warehouse).transfer(address(this).balance);
    }
}