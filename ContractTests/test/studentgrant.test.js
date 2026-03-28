const {loadFixture} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const {expect} = require("chai");
const {ethers} = require("hardhat");


describe("StudentGrant", async () => {
    const deploy = async () => {
        const [owner, student, sponsor1, sponsor2, sponsor3] = await ethers.getSigners();
        const factory = await ethers.getContractFactory("StudentGrant");
        const contract = await factory.deploy();
        await contract.waitForDeployment();
        return {contract, owner, student, sponsor1, sponsor2, sponsor3};
    }
    it("StudentGrant is owner of contract", async ( ) => {
        const {contract, grandma} = await loadFixture(deploy);
        
    });

    it("Grandmother can set grandsons", async () => {
       
    });

        
  
    
})