// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.2 < 0.9.0;

contract Emergency {
    address public owner;

    struct Payment {
        address from;
        uint date;
        uint ammount;
    }
    struct EmergencyDetails {
        address victim;
        string description;
        uint ammount;
        uint date;
    }
    event EmergencyCall (address indexed, uint ammount);

    mapping(address => Payment[]) payments;

    address[] organizations;

    EmergencyDetails[] emergencies;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable { 
        Payment memory newPayment = Payment(msg.sender, block.timestamp, msg.value);
        //if (payments[msg.sender].length > 0){
            payments[msg.sender].push(newPayment);
        //}

    }

    modifier isOwner() {
        require(msg.sender == owner, "You are not owner!");
        _;
    }
    modifier isOrganization() {
        bool next = false;
        for(uint i; i < organizations.length; i++){
            if (msg.sender == organizations[i]){
                next = true;
            }
        }
        require(next, "Not an organization!");
        _;
    }
    function addEth() public payable {}

    function addOrganization(address organizationAddress) public isOwner{
        organizations.push(organizationAddress);
    } 

    function raiseEmergency(address victim,uint ammount, string calldata description)public  isOwner isOrganization{
        emergencies.push (EmergencyDetails(victim,description, ammount,block.timestamp));
        (bool request, ) = payable(victim).call{value: ammount}("");
        require(request, "Payment failed!");
        emit EmergencyCall(victim, ammount);

    }
}