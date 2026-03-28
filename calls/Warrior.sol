// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.2 < 0.9.0;

abstract contract WarriorGuild{
    string public name;
    uint public damage;
    uint public armor;

    function attack() public virtual returns (uint);

}

contract Knight is WarriorGuild {
    constructor() {
        name="knight";
        damage = 10;
        armor=23;

    }
    function attack() public view override returns (uint){
        return damage - 3;
    }
}

contract Mage is WarriorGuild {
    constructor() {
        name="knight";
        damage = 23;
        armor=10;

    }
    function attack() public view override returns (uint){
        return damage - 1;
    }
}

contract Assassin is WarriorGuild {
    constructor() {
        name="knight";
        damage = 19;
        armor=13;

    }
    function attack() public view override returns (uint){
        return damage - 2;
    }
}