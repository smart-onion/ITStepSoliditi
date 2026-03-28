// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 < 0.9.0;

library ResourceUtils {
    struct Player{
        address player;
        uint energy;
        uint balance;
        uint level;
    }

    function manageEnergy(Player memory player)public pure returns(Player memory) {
        player.energy--;
        return player;
    }

    function calculateUpgraid(Player memory player) public pure returns(uint){
        uint ammount = 1 gwei * player.level;
        require(ammount > player.balance);
        return ammount;
    }



}


contract ResoutceManager {
    uint registerValue = 1 gwei;
    uint fee = 1000;
    using ResourceUtils for ResourceUtils.Player;

    ResourceUtils.Player[] public players;

    function register() public payable {
        require(msg.value == registerValue, "Not enough wei!");
        players.push(ResourceUtils.Player(msg.sender, 100, msg.value - fee, 1));

    }

    function upgrade() public {
        for(uint i; i < players.length;i++){
            players[i].balance -= ResourceUtils.calculateUpgraid(players[i]);
            players[i].manageEnergy();
        }
    }
}