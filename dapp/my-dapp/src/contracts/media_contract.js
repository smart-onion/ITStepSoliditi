import web3 from "../lib/web3";
import contractAbi from "./abi/mediaAbi.json";

const contractAdress = "0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0";
const mediaContract = new web3.eth.Contract(contractAbi, contractAdress);

export default mediaContract;