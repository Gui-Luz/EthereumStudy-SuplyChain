pragma solidity 0.8.0;
import "./Item.sol";
// "SPDX-License-Identifier: UNLICENSED"



contract Warehouse {
    address public manager;
    string public description;
    address[] stock;
    address[] soldItems;
    mapping (address => uint) itemIndex;
    uint index;
    Item item;

    constructor(string memory _description) {
        manager = msg.sender;
        description = _description;
    }

    function createItem(string memory _identification, uint _price) onlyManager public {
        Item newItem = new Item(_identification, _price);
        stock.push(address(newItem));
        itemIndex[address(newItem)] = index;
        index++;
    }

    function getItemsInStock() public view returns (address[] memory) {
        return stock;
    }

    function getSoldItems() public view returns (address[] memory) {
        return soldItems;
    }

    function ship(address _existingItemAddress) onlyManager public {
        item = Item(_existingItemAddress);
        item.ship();
        soldItems.push(_existingItemAddress);
        delete stock[itemIndex[_existingItemAddress]];
    }

    modifier onlyManager() {
        require(manager == msg.sender, "Manager: caller is not the warehouse manager");
        _;
    }
}