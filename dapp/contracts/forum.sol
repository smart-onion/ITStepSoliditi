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
    mapping (address => bool) likes;
    Post[] posts;
    address owner;

    constructor(){
        owner = msg.sender;
    }

    modifier isAuthor(address author) {
        bool next = false;
        for(uint i; i < posts.length; i++){
            if(posts[i].author == author){
                next = true;
                break;
            }
        }
        require(next, "You are not author!");
        _;
    }
    modifier isPostsIndex(uint index){
        require(index < posts.length);
        _;
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
    function deletePost(uint postIndex) public isAuthor(msg.sender) isPostsIndex(postIndex){
        posts[postIndex] = posts[posts.length - 1];
        posts.pop();
    }
    function like(uint postIndex)public isPostsIndex(postIndex){
        for(uint i; i < posts.length;i++){
            if(i == postIndex){
                if(likes[msg.sender]){
                    posts[i].like--;
                    likes[msg.sender] = false;
                }else{
                    likes[msg.sender] = true;
                    posts[i].like++;
                }
                
                break;
            }

        }
    }



    function get_posts() external view returns(Post[] memory){
        return posts;
    }
    function getPostsByAuthor(address author) public view returns(Post[] memory){
        uint[] memory indexes = new uint[](posts.length);
        uint currentIndex = 0;
        for(uint i; i < posts.length;i++){
            if(posts[i].author == author){
                indexes[currentIndex++] = i;
            }
        }

        Post[] memory  authorPosts = new Post[](currentIndex);

        for(uint i; i < authorPosts.length;i++){
            authorPosts[i] = posts[indexes[i]];
        }
        return authorPosts;
    }
    function get_post(uint idx) external view returns(Post memory){
        require(idx < posts.length, "Not found");
        return posts[idx];
    }
}