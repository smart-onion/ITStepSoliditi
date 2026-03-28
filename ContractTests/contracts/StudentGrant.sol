// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >=0.8.2 < 0.9.0;

contract StudentGrant{
    struct Goal{
        uint id;
        string description;
        bool status;
        uint reward;
        uint amount;
        address[] sponsors;        
    }
    struct Sponsor{
        address sponsor;
        uint amount;
    }

    Goal[] goals;
    Sponsor[] sponsors;
    address owner;
    address student;

    mapping (address => Goal) voting;

    constructor(string memory description, address studentAddress, uint reward){
        goals.push(Goal(block.timestamp, description, false, reward,0, new address[](0)));
        owner = msg.sender;
        student = studentAddress;
        sponsors.push(Sponsor(owner, 0));
    }

    modifier isOwner() {
        require(msg.sender == owner, "You are not owner");
        _;
    }
    modifier isSponsor {
        bool next = false;
        for(uint i; i < sponsors.length; i++){
            if(msg.sender == sponsors[i].sponsor){
                next = true;
            }
        }
        require(next, "You are not sponsor!");
        _;
    }

    function setNewGoal(string calldata description, uint reward) public isSponsor{
        
        goals.push(Goal(block.timestamp,description, false, reward,0, new address[](0)));
    }

    function becomeSponsor(uint goalId) public payable{
        sponsors.push(Sponsor(msg.sender, msg.value));
        bool next = false;
        for(uint i; i < goals.length;i++){
            if(goals[i].id == goalId){
                goals[i].amount += msg.value;
                goals[i].sponsors.push(msg.sender);
                next = true;
            }
        }
        require(next, "Goal ID not exists!");
    }

    function goalIsAchieved(uint goalId) public isSponsor{
        for(uint i; i < goals.length; i++){
            if(goals[i].id == goalId){
                if(voting[msg.sender].id == goals[i].id){
                    revert("You already vote for this goal!");
                }
                voting[msg.sender] = goals[i];
            }
        }
        
    }

}