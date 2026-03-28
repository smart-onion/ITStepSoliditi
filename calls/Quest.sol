// SPDX-License-Identifier: MIT
pragma solidity  >=0.8.2 < 0.9.0;

interface IQuest {
    function start(uint id) external ;
    function complete(uint id) external;
    function getReward() external;
}

contract QuestManager is IQuest {
    struct Player {
        address player;
        uint questId;
        bool completed;
        bool confirmed;
    }

    struct Quest{
        uint id;
        string name;
        uint reward;
        uint participants;
    }
    address owner;
    Quest[] public quests;
    Player[] players;



    constructor() {
        owner = msg.sender;
    }

    modifier isOwner(){
        require(msg.sender == owner, "You are not owner!");
        _;
    }
    modifier isEnoughParticipants(uint questId){
        for(uint i; i < quests.length;i++){
            if(quests[i].id == questId){
                require(quests[i].participants > 0, "No more participants!");
                break;
            }
        }
        
        _;
    }
    modifier questExist(uint id) {
        bool next = false;
        for(uint i; i < quests.length; i++){
            if (quests[i].id == id){
                next = true;
            }
        }
        require(next, "Quest not exist!");
        _;
    }

    function addQuest(string calldata name, uint reward, uint participants) public payable  isOwner {
        require(participants > 0 && (reward * participants) == msg.value, "Not correct reward or value!");
        quests.push(Quest(block.timestamp, name, reward, participants));

    }

    function start(uint id) external  override questExist(id) isEnoughParticipants(id){
        players.push(Player(msg.sender, id, false, false));
        for(uint i; i < quests.length;i++){
            if(quests[i].id == id){
                quests[i].participants--;
            }
        }
    }

    function confirmComlited(address player, uint questId)public isOwner{
        for(uint i; i < players.length;i++){
            if(players[i].player == player && players[i].questId == questId){
                players[i].confirmed = true;
            }
        }
    }

    function complete(uint id) external override questExist(id){
        for(uint i; i < players.length;i++){
            if (players[i].player == msg.sender){
                players[i].completed = true;
            }
        }
    }

    function getReward() public {
        for(uint i; i < players.length;i++){
            if(msg.sender == players[i].player){
                require(players[i].confirmed, "Quest not comfirmed!");
                for(uint j; j < quests.length;j++){
                    if (players[i].questId == quests[j].id){
                        (bool result, ) = payable(msg.sender).call{value: quests[j].reward}("");
                        require(result, "Payment failed!");                        
                        break ;
                    }
                }
            }
        }
    }
}