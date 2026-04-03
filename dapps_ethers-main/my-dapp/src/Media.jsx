import { useState, useEffect } from "react";
import web3 from "./lib/web3";
import mediaContract from "./contracts/media_contract";
import lighthouse from '@lighthouse-web3/sdk';
import { MediaCard } from "./MediaCard";
import API from "./lib/lighthouseApi"
const styles = {
  display: "grid",
  gridTemplateColumns: "1fr 1fr 1fr",
  

}
const Media = () => {
    //! Це лише приклад, ключі так зберігати не можна
    const apiKey = API;
    const imageUrl = 'https://gateway.lighthouse.storage/ipfs/';

    const [account, setAccount] = useState('');
    const [picName, setPicName] = useState('');
    const [file, setFile] = useState('');
    const [cid, setCid] = useState('');
    const [media, setMedia] = useState([]);

    const loadMedia = async () => {
     const allCids = await mediaContract.methods.get_pics().call('');
     setMedia(allCids);
     console.log(allCids)
    }

    useEffect(() => {
    const loadAccounts = async () => {
      const accounts = await web3.eth.getAccounts();
      if (accounts.length > 0) {
        setAccount(accounts[0]);
      }
    }
    
    loadAccounts();
    loadMedia();


    const handleChangedAccount = (accounts) => {
      setAccount(accounts[0]);
    }
    window.ethereum.on("accountsChanged", handleChangedAccount);

    return () => {
      window.ethereum.removeListener("accountsChanged", handleChangedAccount);
    }

  }, [])

  const createPicture = async (e) => {
        e.preventDefault();
        const uploadResult = await lighthouse.upload([file], apiKey);
        setCid(uploadResult.data.Hash);

        await mediaContract.methods.new_pic(uploadResult.data.Hash, picName).send({ from: account });
        const result = await mediaContract.methods.get_pics().call();
        loadMedia();
  }

  const deletePic = async (index, cid) => {
      await mediaContract.methods.delete_pic(index).send({from: account});
      const pics = await lighthouse.getUploads(API);
      pics.data.fileList.forEach(async (i) => {
          if (i.cid == cid){
                await lighthouse.deleteFile(API, i.id)
          }
      })
      loadMedia();
  }

  return (
    <div>
        <h1>Account: {account}</h1>
        <form onSubmit={createPicture}>
            <input type="text" placeholder="Set name for pic" onChange={(e)=>setPicName(e.target.value)} />
            <input type="file" onChange={(e)=>setFile(e.target.files[0])}/>
            <button type="submit">Upload picture</button>
        </form>
        <img src={`${imageUrl}${cid}`} alt={picName} />
        <div style={styles}>
        {media?.map((m, i) => (
          <MediaCard key={i} src={`${imageUrl}${m.cid}`} name={m.name} author={"..." + m.creator.slice(-10)} isDelete={() => deletePic(i, m.cid)}/>
        ))}
        </div>
    </div>
  )
}

export default Media;