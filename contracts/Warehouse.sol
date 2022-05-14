pragma solidity 0.8.0;
import "./Item.sol";
// "SPDX-License-Identifier: UNLICENSED"



contract Warehouse {
    address public manager;
    string public description;
    uint public lastUpdated;
    address[] stock;
    address[] soldItems;
    mapping (address => uint) itemIndex;
    uint index;
    Item item;
    event itemCreation(address itemAddress);

    constructor(string memory _description, address _manager) {
        manager = _manager;
        description = _description;
    }

    function createItem(string memory _product, string memory _identification, uint _price) onlyManager public {
        Item newItem = new Item(_product, _identification, _price);
        stock.push(address(newItem));
        itemIndex[address(newItem)] = index;
        index++;
        emit itemCreation(address(newItem));
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

    function transferPayment(address _recevingAccount) onlyManager public {
        payable(_recevingAccount).transfer(address(this).balance);
    }


    receive() payable external {
        require(itemIndex[msg.sender] >= 0, "You are not alowed to pay this warehouse");
    }

    modifier onlyManager() {
        require(manager == msg.sender, "Manager: caller is not the warehouse manager");
        _;
    }
}