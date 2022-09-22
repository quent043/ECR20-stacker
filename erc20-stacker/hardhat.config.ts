import {HardhatUserConfig, task} from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-ethers";
import "@nomiclabs/hardhat-etherscan";
import * as dotenv from "dotenv";

dotenv.config();

task("balance", "Prints an account's balance")
    .addParam("account", "The account's address")
    .setAction(async (taskArgs, ethers) => {
      const balance = await ethers.ethers.provider.getBalance(taskArgs.account);

      console.log(ethers.ethers.utils.formatEther(balance), "ETH");
    });

const config: HardhatUserConfig = {
  defaultNetwork: "rinkeby",
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545"
    },
    hardhat: {
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${process.env.INFURA_ID}`,
      accounts: [
        "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80",
        "0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d"]
    }
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_KEY
  },
  solidity: {
    version: "0.8.14",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 40000
  }
}

export default config;
