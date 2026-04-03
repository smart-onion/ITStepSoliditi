import { useState, useEffect } from 'react';
import web3 from './lib/web3';
import counterContract from './contracts/counter_contract';

function App() {
  const [account, setAccount] = useState('');
  const [counter, setCounter] = useState(-1);
  const [newValue, setNewValue] = useState(0);

  useEffect(() => {
    const loadAccounts = async () => {
      const accounts = await web3.eth.getAccounts();
      if (accounts.length > 0) {
        setAccount(accounts[0]);
      }
    }

    loadAccounts();
    getCounter();

    const handleChangedAccount = (accounts) => {
      setAccount(accounts[0]);
    }
    window.ethereum.on("accountsChanged", handleChangedAccount);

    return () => {
      window.ethereum.removeListener("accountsChanged", handleChangedAccount);
    }

  }, [])

  const getCounter = async () => {
    const result = await counterContract.methods.get_value().call();
    setCounter(result);
  }

  const setCount = async (e) => {
    e.preventDefault();
    await counterContract.methods.set_value(newValue).send({ from: account });
    getCounter();
  }

  const getNextValue = async (e) => {
    await counterContract.methods.set_value(Number(counter)+1).send({ from: account })
    getCounter();
  }
  return (
    <div>
      <h1>Account: {account}</h1>
      <h3>Stored value: {counter}</h3>
      <form onSubmit={setCount}>
        <input type="number" onChange={(e) => setNewValue(e.target.value)} placeholder='Set count' />
        <button type="submit">Set count</button>
      </form>
      <button onClick={getNextValue}>Click: {counter}</button>
    </div>
  )
}

export default App
