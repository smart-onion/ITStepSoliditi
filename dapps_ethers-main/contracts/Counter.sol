// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract Counter{
    uint value;

    struct User{
        string name;
        uint age;
    }

    function get_user() public pure returns(User memory){
        return User("Tom", 24);
    }

    function set_value(uint _value) public{
        value = _value;
    }

    function get_value() public view returns(uint){
        return value;
    }
}