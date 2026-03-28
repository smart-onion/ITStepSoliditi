// lice
pragma solidity ^0.8.0;

contract PaymentContract{

    event NewPayment(address indexed from, uint value);

    struct Payment{
        uint value;
        uint timestamp;
        address from;
        string message;
    }
    struct Transactions{
        uint totalPayments;
        mapping(uint => Payment) payments;
    }
    
    mapping(address => Transactions) public transactions;

    function get_current_balance()external view returns(uint) {
        return address(this).balance;
    }

    modifier min_payment(uint min) {
        require(msg.value >= min, "Transfered less then minimum");
        _;
    }

    function pay(string calldata _message) external payable min_payment(2000){
        uint payment_numer = transactions[msg.sender].totalPayments++;
        Payment memory new_payment = Payment(msg.value, block.timestamp, msg.sender, _message);
        transactions[msg.sender].payments[payment_numer] = new_payment;
        emit NewPayment(msg.sender, msg.value);
    }

    function get_payment(address from, uint payment_number) external view returns(Payment memory){
        return transactions[from].payments[payment_number];
    }
}