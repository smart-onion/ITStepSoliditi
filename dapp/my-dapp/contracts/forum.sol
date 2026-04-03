// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract Forum{
    struct Post {
        string message;
        address author;
        uint timestamp;
        uint like;
    }

    event PostCreated(address indexed author, uint timestamp);
    event PostsCleared(uint indexed timestamp, uint post_quantity);

    Post[] posts;
    address owner;

    constructor(){
        owner = msg.sender;
    }


    function create_post(string memory message) external {
        posts.push(
            Post(
                message,
                msg.sender,
                block.timestamp,
                0
            )
        );
        emit PostCreated(msg.sender, block.timestamp);
    }

    function clear_posts() external{
        require(owner == msg.sender, "You're not owner");
        emit PostsCleared(block.timestamp, posts.length);
        delete posts;
    }

    function get_posts() external view returns(Post[] memory){
        return posts;
    }

    function get_post(uint idx) external view returns(Post memory){
        require(idx < posts.length, "Not found");
        return posts[idx];
    }
}