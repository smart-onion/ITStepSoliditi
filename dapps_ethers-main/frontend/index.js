const contract_address = "0x5FbDB2315678afecb367f032d93F642f64180aa3";

let web3;
let contract;
let current_account;

document.addEventListener("DOMContentLoaded", () => {
    document.getElementById("connection_btn").addEventListener("click", connectWallet);
    document.getElementById("makePost_btn").addEventListener("click", makePost);
    document.getElementById("getPosts_btn").addEventListener("click", getPosts);
    document.getElementById("clearPosts_btn").addEventListener("click", clearPosts);


    if(window.ethereum){
        web3 = new Web3(window.ethereum);
        contract = new web3.eth.Contract(abi, contract_address);

        window.ethereum.on("accountsChanged", (accounts)=>{
            if(accounts.length > 0){
                current_account = accounts[0];
                enterToDapp();
            }
        })

        contract.events.PostCreated({ fromBlock: "latest" })
            .on("data", event=>{
                console.log("Post created: ", event.returnValues);
                renderPosts();
            })

        contract.events.PostsCleared({ fromBlock: "latest" })
            .on("data", event=>{
                console.log("Posts cleared: ", event.returnValues);
                renderPosts();
            })
    }else {
        alert("Please install web3 provider")
    }
})

const getPosts = async () => {
    try {
        const post = await contract.methods.get_post(0).call();
        console.log("Post: ", post);
        renderPosts();
    } catch (error) {
        console.error("Get posts error: ", error);
        alert("Get posts error. See logs");
    }
}

const makePost = async () => {
    try {
        const post_text = document.getElementById("post_text");
        const message = post_text.value;
        if(!message) return alert("Post text empty. Please type something");

        await contract.methods.create_post(message).send({from: current_account});
        post_text.value = "";

    } catch (error) {
        console.error("Make post error: ", error);
        alert("Make post error. See logs");
    }
}
const connectWallet = async (e) => {
    if (window.ethereum) {
        try {
            const accounts = await window.ethereum.request({
                method: "eth_requestAccounts"
            });
            console.log(accounts);
            current_account = accounts[0];
            e.target.hidden = true;
            enterToDapp();
        } catch (error) {
            alert("Connect to DApp error. See logs");
            console.error("Connect error: ", error);
        }
    }
    else {
        alert("Please install web3 provider")
    }
}

const enterToDapp = () =>{
    const account_lbl = document.getElementById("account_lbl");
    account_lbl.hidden = false;
    account_lbl.style.color = "darkgreen";
    account_lbl.textContent = current_account;

    document.getElementById("dapp").hidden = false;

    renderPosts();
}

const renderPosts = async () => {
    try {
        const posts = await contract.methods.get_posts().call();
        const post_container = document.getElementById("posts");

        while(post_container.firstChild){
            post_container.removeChild(post_container.firstChild);
        }
        if(posts.length === 0){
            const p = document.createElement("p");
            p.textContent = "Not posts yet";

            post_container.appendChild(p);
            return;
        }
        posts.forEach(post=>{
            const div = document.createElement("div");

            const author = document.createElement("p");
            author.textContent = `Author: ${post.author}`;

            const message = document.createElement("p");
            message.textContent = `Message: ${post.message}`;

            const timestamp = document.createElement("p");
            timestamp.textContent = `Date: ${new Date(Number(post.timestamp) * 1000)}`;

            const likes = document.createElement("p");
            likes.textContent = `Likes: ${post.like}`;

            div.appendChild(author);
            div.appendChild(message);
            div.appendChild(timestamp);
            div.appendChild(likes);
            div.appendChild(document.createElement("hr"));

            post_container.appendChild(div);
        })
    } catch (error) {
        console.error("Redner post error: ", error);
        alert("Redner post error. See logs");
    }
}

const clearPosts = async () => {
    try {
        await contract.methods.clear_posts().send({from: current_account});
    } catch (error) {
        console.error("Clear posts error: ", error);
        alert("Clear posts error. See logs");
    }
}