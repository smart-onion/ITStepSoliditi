// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >= 0.8.2 < 0.9.0;

contract ProductContract{
    struct Product{
        string name;
        string description;
        uint price;
        address creator;
        uint time;
        string pitureUrl;
    }
    Product[] public products;

    
    function setProduct(Product calldata product) public {
        products.push(product);
    }
    function getProducts() public view returns(Product[] memory) {
        return products;
    }

}