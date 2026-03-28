// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 < 0.9.0;
import "hardhat/console.sol";

contract Grandmather {
    struct Grandson {
        address grandson;
        uint balance;
        uint birthdate;
    }

    event Withdrow(address indexed grandson, uint value);

    address public owner;
    Grandson[] public grandsons;
    struct Trunsaction {
        address grandson;
        uint timestamp;
        uint value;
    }

    mapping(address => Trunsaction) public transactions;

    constructor() {
        owner = msg.sender;
    }
    modifier isOwner() {
        require(msg.sender == owner, "You are not owner!");
        _;
    }

    modifier isGrandson() {
        bool next = false;
        for (uint i; i < grandsons.length;i++){
            if(grandsons[i].grandson == msg.sender){
                next = true;
            }
        }
        require(next,"You are not grandson!");
        _;
    }
    modifier setBalances() {
        if(grandsons.length > 0){
            uint part = msg.value / grandsons.length;
            for(uint i; i < grandsons.length;i++){
                grandsons[i].balance += part;
            }
        }
        
        _;
    }

    receive() external payable setBalances { }

    function setGrandson(address grandson, uint birthdate) public isOwner{
        grandsons.push(Grandson(grandson, 0, birthdate));
    }

    function topup() public payable setBalances{}

    function withdraw() public payable isGrandson setBalances{
        for(uint i; i < grandsons.length; i ++){
            require(block.timestamp >= grandsons[i].birthdate, ("Not your birth date yet"));
            if (transactions[msg.sender].grandson == msg.sender){
                revert("You already withdrow");
            }
            
            if (msg.sender == grandsons[i].grandson){
                payable(msg.sender).call{value:grandsons[i].balance}("");
                emit Withdrow(msg.sender, grandsons[i].balance);
                transactions[msg.sender] = Trunsaction(msg.sender, block.timestamp, grandsons[i].balance);
                break;
            }
        }
    }
}