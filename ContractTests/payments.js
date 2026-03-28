const {loadFixture} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const {expect} = require("chai");
const {ethers} = require("hardhat");

describe("PaymentContract", () => {
    const deploy = async () => {
        const [user1, user2] = await ethers.getSigners();
        const factory = await ethers.getContractFactory("PaymentContract");
        const c_payment = await factory.deploy();
        await c_payment.waitForDeployment();
        return {c_payment, user1, user2};
    }

    it("empty contract balance and contract address format is correct", async () => {
        const {c_payment, user1, user2} = await loadFixture(deploy);
        console.log("Contract address: ", await c_payment.getAddress());

        // addresses
        console.log("User1 address: ", await user1.address)
        console.log("User2 address: ", await user2.address)

        // balances
        console.log("User1 balance: ", await ethers.provider.getBalance(user1.address));
        console.log("User2 balance: ", await ethers.provider.getBalance(user2.address));

        const contract_address = await c_payment.getAddress();
        expect(contract_address, "Contract address is not correct!").to.be.properAddress;

        const balance = await c_payment.get_current_balance();
        console.log("Contract balance: ", balance);
        expect(balance, "Contract balance must be: 0ETH").to.be.eq(0);
        

    });

    it("pay function", async () => {
        const {c_payment, user1, user2} = await loadFixture(deploy);

        const payment_value = 2000;
        const payment_massage = "Hello from hardhet";

        await expect(()=> c_payment.pay(payment_massage, {value: payment_value})).to.changeEtherBalance(user1, -payment_value);
        const contract_balance = await ethers.provider.getBalance(c_payment.target);

        expect(contract_balance, "Contract must change after first payment").to.be.eq(payment_value);
        console.log("Contract balance: ", contract_balance);

        const payment_index = 0;
        const payment = await c_payment.get_payment(user1.address, payment_index);

        console.log("Payment: ",payment);

        const current_block = await ethers.provider.getBlock(await ethers.provider.getBlockNumber())
        const user1_address = await user1.address
        expect(payment.value, "expected value and result are same").to.be.eq(payment_value);
        expect(payment.timestamp, "expected timestamp and result are same").to.be.eq(current_block.timestamp);
        expect(payment.from, "expected account and result are same").to.be.eq(user1_address);
        expect(payment.message, "expected message and result are same").to.be.eq(payment_massage);

        const wei_min = 1000;
        const revertet_message = "Transfered less then minimum";

        await expect(c_payment.pay(payment_massage, {value: wei_min})).to.be.revertedWith(revertet_message);
        
        const tx = await c_payment.connect(user2).pay(payment_massage, {value: payment_value});
        const event_name = "NewPayment";
        await expect(tx).to.emit(c_payment, event_name).withArgs(user2.address, payment.value);
    });
})