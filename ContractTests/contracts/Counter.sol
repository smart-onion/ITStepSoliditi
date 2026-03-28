// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >=0.8.2 < 0.9.0;


contract Counter {
    uint value;
    struct User{
        string name;
        uint age;
    }

    function getUser() public pure returns(User memory){
        return User("Alex", 18);
    }

    function set_value(uint _value) public {
        value = _value;
    }

    function get_value()public view returns(uint){
        return value;
    }
}