// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 < 0.9.0;
import "hardhat/console.sol";

contract Couter{
    int public counter = 0;

    function increment() public {
        counter += 1;
    }

    function decrement() public {
        counter -= 1;
    }

    function read_counter() public view returns(int){
        return counter;
    }
}

contract TaskManager{
    string[] private tasks;

    function add_task(string memory new_task) public {
        tasks.push(new_task);
    }

    function remove_last_task() public {
        tasks.pop();
    }

    function remove_by_index(uint index) public {
        for(uint i; i < tasks.length;i++){
            if (i >= index && i < tasks.length - 1){
                tasks[i] = tasks[i + 1];
            }
        }
        tasks.pop();
    }

    function view_all_tasks() public view returns(string[] memory){
        for(uint i;i<tasks.length;i++){
            console.log(i, "-", tasks[i]);
        }
        return tasks;
    }
}


contract Store {
    struct Product {
        string name;
        uint price;
    }
    
    Product[] products;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function add_product(string memory name, uint price) public {
        Product memory new_product;
        new_product.name  = name;
        new_product.price = price;
        products.push(new_product);
    }

    function list_products() public view returns(Product[] memory){
        for(uint i; i < products.length;i++){
           console.log("id: %d   name:%s.  price:%d",i, products[i].name, products[i].price);
        }
        return products;
    }

    function buy_product(uint product_id) public payable {
        if (product_id >= products.length || product_id < 0){
            revert("Index out of range"); 
        }
        if(msg.value < products[product_id].price ){
            revert("Not enouth value");
        }

        payable(owner).transfer(products[product_id].price);
    }
}


contract Vote{
    struct Candidate {
        string name;
        uint votes;
    }
    
    Candidate[] private candidates;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function become_candidate(string calldata name) public payable {
        uint to_pay = 100000 ;
        if (msg.value < to_pay){
            revert("Not enouth value");
        }
        payable(owner).transfer(to_pay);
        Candidate memory c;
        c.name = name;
        c.votes = 0;
        candidates.push(c);
    }

    function list_candidates() public view returns(Candidate[]memory){
        for(uint i;i < candidates.length;i++){
            console.log("%d: %s - %d votes",i, candidates[i].name, candidates[i].votes);
        }
        return candidates;
    }

    function vote(uint candidate_id) public {
        if (candidate_id < 0 || candidate_id >= candidates.length){
            revert("index out of range");
        }
        candidates[candidate_id].votes++;
    }
}

contract Subsciption {
    address public owner;
    uint public price = 1 gwei;
    uint public subscription_time = 30 days;
    
    
    mapping (address => uint) subs;

    constructor() {
        owner = msg.sender;
    }

    function set_price(uint new_price) public {
        if(msg.sender != owner){
            revert("Not allowed");
        }
        price = new_price;
    }

    function check_subscription() public view returns(bool){
        return subs[msg.sender]!= 0 && subs[msg.sender] + block.timestamp > subs[msg.sender] + 30 days;
    }

    function subscribe() public payable {
        if(msg.value != price ) revert("Not correct value!");
        if(subs[msg.sender] > 0) revert("Subscribe already!");
        subs[msg.sender] = block.timestamp;
        payable(owner).transfer(price);
    }

}


contract Finance{
    uint public  total_votes = 0;
    struct Idea{
        address owner;
        string description;
        uint votes;
    }

    Idea[] ideas;
    
    function add_idea(string calldata description) public {
        ideas.push(Idea(msg.sender, description, 0));
    }

    function list_ideas() public view returns (Idea[] memory){
        for(uint i; i < ideas.length;i++){
            console.log("%d - %s   votes: %d", i, ideas[i].description, ideas[i].votes);
        }
        return ideas;
    }

    function vote(uint idea_id) public {
        if (idea_id < 0 || idea_id >= ideas.length) revert("Index out of range");
        ideas[idea_id].votes++;
        total_votes++;
    }
    function donate() public payable {}

    function constribute() public {
        uint total_amount = address(this).balance;
        for(uint i; i < ideas.length;i++){
            if(ideas[i].votes < 0) continue ;
            uint to_send = (total_amount * ideas[i].votes) / total_votes;
            if (to_send > 0){
                payable(ideas[i].owner).transfer(to_send);
            }
        }
    }
}