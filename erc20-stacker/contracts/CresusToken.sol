// ERC20Token.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./TokenStacker.sol";

contract CresusToken is ERC20 {
    // TokenStacker tokenStacker;

    //     constructor(uint256 initialSupply, address payable tockenStacker) ERC20("CRESUS", "CRT") {
    //         _mint(msg.sender, initialSupply);
    //         tokenStacker = TokenStacker(tockenStacker);
    //         uint amount = (1000 * initialSupply) / 100;
    //         (bool tokensSent, ) = tockenStacker.call{value: amount}("");
    // }

    uint constant INITIAL_SUPPLY = 1_000_000_000 * 10 ** 18;
    uint constant FAUCET_REQUEST = 1000 * 10 ** 18;

    constructor(uint256 initialSupply) ERC20("CRESUS", "CRT") {
        _mint(msg.sender, initialSupply);
    }

    function faucet(address recipient) external {
        _mint(recipient, FAUCET_REQUEST);
    }
}