import React, {useState} from 'react';
import logo from './logo.svg';
import './App.css';
import {BigNumber, ethers} from "ethers";

// declare global {
//   interface Window {
//     ethereum: import('ethers').providers.ExternalProvider;
//   }
// }
declare var window: any

function App() {

  const [accounts, setAccounts] = useState([]);

  const connectAccount = async () => {
    if(window.ethereum){
      const accounts = await window.ethereum.request({
        method:"eth_requestAccounts",
      });
      setAccounts(accounts);
    }
  }

  const interactWithContract = async (amount: number) => {
    if (window.ethereum && accounts[0] || ethers.utils.isAddress(accounts[0])) {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(
          "address",
          "abi",
          signer

      );

      //Exemple d'appel
      try {
        const response = await contract.mint(BigNumber.from(amount), {
          value: ethers.utils.parseEther((0.02 * amount).toString())
        });
      } catch (err) {
        console.log("Error: ", err)
      }
    }
  };


  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.tsx</code> and save to reload.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header>
    </div>
  );
}

export default App;
