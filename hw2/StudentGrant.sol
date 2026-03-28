// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >=0.8.2 < 0.9.0;

contract StudentGrant{
    struct Goal{
        uint id;
        string description;
        bool status;
        uint reward;
        address[] sponsors;        
    }
    struct Sponsor{
        address sponsor;
        uint amount;
    }

    Goal[] public  goals;
    Sponsor[] public sponsors;
    address owner;
    address public student;

    mapping (address => Goal) voting;

    constructor(string memory description, address studentAddress){
        goals.push(Goal(block.timestamp, description, false,0, new address[](0)));
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

    function setNewGoal(string calldata description) public isSponsor{
        
        goals.push(Goal(block.timestamp,description, false, 0, new address[](0)));
    }

    function becomeSponsor(uint goalId) public payable{
        sponsors.push(Sponsor(msg.sender, msg.value));
        bool next = false;
        for(uint i; i < goals.length;i++){
            if(goals[i].id == goalId){
                goals[i].reward += msg.value;
                goals[i].sponsors.push(msg.sender);
                next = true;
            }
        }
        require(next, "Goal ID not exists!");
    }

    function goalIsAchieved(uint goalId) public isSponsor{
        for(uint i; i < goals.length; i++){
            require(!goals[i].status, "Goal already closed!");

            if(goals[i].id == goalId){
                if(voting[msg.sender].id == goals[i].id){
                    revert("You already vote for this goal!");
                }
                voting[msg.sender] = goals[i];
            }
        }
        for (uint i; i< goals.length;i++){
            uint totalSponsors = goals[i].sponsors.length;
            uint totalVotes = 0;
            for (uint j; j < goals[i].sponsors.length;j++) {
                if(voting[goals[i].sponsors[j]].id == goals[i].id){
                    totalVotes++;
                }
            } 

            if(totalVotes > (totalSponsors / 2)){
                goals[i].status = true;
                (bool result,) = payable(student).call{value: goals[i].reward}("");
                require(result, "Transaction failed!");
            }
        }
        
    }

}