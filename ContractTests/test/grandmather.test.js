const {loadFixture} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const {expect} = require("chai");
const {ethers} = require("hardhat");


describe("Grandmather", async () => {
    const deploy = async () => {
        const [grandma, son1,son2,son3] = await ethers.getSigners();
        const factory = await ethers.getContractFactory("Grandmather");
        const contract = await factory.deploy();
        await contract.waitForDeployment();
        return {contract, grandma, son1, son2, son3};
    }
    it("Grandmather is owner of contract", async ( ) => {
        const {contract, grandma} = await loadFixture(deploy);
        const owner = await contract.owner();
        expect(owner, "You are not grandmather").to.be.eq(grandma);
    });

    it("Grandmother can set grandsons", async () => {
        const {contract, grandma, son1, son2, son3} = await loadFixture(deploy);
        const seconds = Math.floor(Date.now() / 1000)
        console.log(seconds)
        await contract.setGrandson(son1, seconds - (2 * 24 * 60 * 60 * 1000));
        await contract.setGrandson(son2, seconds);
        await contract.setGrandson(son3, seconds + 2 * 24 * 60 * 60 * 1000*1000);
        console.log(await contract.grandsons(0))
        console.log("Timestamp: ", seconds)

        const correct = await contract.grandsons(0)
        expect((await contract.grandsons(0)).grandson).to.be.eq(son1);
        expect((await contract.grandsons(1)).grandson).to.be.eq(son2);
        expect((await contract.grandsons(2)).grandson).to.be.eq(son3);
        await contract.grandsons(0);

        const topupAmount = 1000000000000000;
        await contract.topup({value: topupAmount})
        const part = Math.round(topupAmount / 3);
        expect(await ethers.provider.getBalance(contract.target), "Balance is not correct").to.be.eq(topupAmount);
        

        expect((await contract.grandsons(0)).balance, " Balance on grandson is not correct").to.be.eq(part);
        expect((await contract.grandsons(1)).balance, " Balance on grandson is not correct").to.be.eq(part);
        expect((await contract.grandsons(2)).balance, " Balance on grandson is not correct").to.be.eq(part);

        const son1Balance = await ethers.provider.getBalance(son1);

        await contract.connect(son1).withdraw();

        expect(await ethers.provider.getBalance(son1), "Withdrow not successeded").to.be.changeEtherBalance(son1,-(son1Balance + BigInt(part)) )
        console.log(await ethers.provider.getBalance(son1)) 

        // no birthdate yet
        console.log(await contract.grandsons(2))
        console.log("Timestamp: ", seconds)
        await expect(contract.connect(son3).withdraw()).to.be.revertedWith("Not your birth date yet");
        
        await expect(contract.connect(son1).withdraw()).to.be.revertedWith("You already withdrow");

        await expect(contract.withdraw(), "Withdrow success not from grandson").to.be.revertedWith("You are not grandson!")
        
        const tx = await contract.connect(son2).withdraw();

        await expect(tx).to.emit(contract, "Withdrow").withArgs(son2.address, part)
    });

        
  
    
})