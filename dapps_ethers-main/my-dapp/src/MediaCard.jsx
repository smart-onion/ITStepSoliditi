import mediaContract from "./contracts/media_contract"
import lighthouse from '@lighthouse-web3/sdk';
import API from "./lib/lighthouseApi"
const styles = {
    backgroundColor: "white",
    width: "fit-content",
    justifyItems: "start",
    padding: 10,
    border: "1px solid red",
    margin: 5,
    borderRadius: 10
}



export const MediaCard = ({src, name, author, isDelete}) => {
    console.log(src)
    return (
        <div style={styles}>
            <img src={src} />
            <h3>{name}</h3>
            <p>Author: {author}</p>
            <button onClick={isDelete}>delete</button>
        </div>
    )
}