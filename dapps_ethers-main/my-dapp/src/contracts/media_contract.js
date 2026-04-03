import web3 from "../lib/web3";
import contractAbi from "./abi/mediaAbi.json";

const contractAdress = "0x0165878A594ca255338adfa4d48449f69242Eb8F";
const mediaContract = new web3.eth.Contract(contractAbi, contractAdress);

export default mediaContract;