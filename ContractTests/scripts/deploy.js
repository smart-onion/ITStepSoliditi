const { ethers } = require("hardhat");

(
    async () => {
        const factory = await ethers.getContractFactory("ProductContract");
        const payments = await factory.deploy();
        await payments.waitForDeployment();
        console.log("Contract address: ", await payments.getAddress())
    }
)().catch((err) => {
    console.error(err);
    process.exitCode = -1;
})
