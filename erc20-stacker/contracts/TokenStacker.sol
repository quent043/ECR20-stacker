// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenStacker is Ownable {
    IERC20 public stackingToken;

    uint public constant REWARD_RATE = 16000;
    uint public constant REQUIRED_STACK_TIME_MILIS = 1;
    // uint public constant REQUIRED_STACK_TIME_MILIS = 6048 * 10**5;
    uint public totalStackingTokenSupply;

    mapping(address => Deposit) public userToTokens;

    struct Deposit {
        uint tokenAmount;
        uint startDate;
    }

    event LogDepositReceived(address _from, uint _amount);
    event LogAmount(uint _amount);
    event LogAddress(address _address);


    constructor(address _tokenAddress) {
        stackingToken = IERC20(_tokenAddress);
    }

    /**
    @notice Function used to receive ether
    @dev  Emits "LogDepositReceived" event | Ether send to this contract for
    no reason will be credited to the contract owner, and the deposit logged,
    */
    receive() external payable{
        payable (owner()).transfer(msg.value);
        emit LogDepositReceived(msg.sender, msg.value);
    }


    function stackTokens(uint tokenAmount) external payable {
        address owner = msg.sender;
        require(userToTokens[owner].startDate == 0, "Tokens already staked.");
        require(tokenAmount >= 100, "You need to stack a minimum on 100 tokens.");

        userToTokens[owner] = Deposit (
            tokenAmount,
            block.timestamp
        );

        // cresusToken.approve(address(this), tokenAmount); NEED DELEGATE CALL ?
        // Ou ajouter coté react un appel pour approve le token amount avant en async
        stackingToken.transferFrom(owner, address(this), tokenAmount);
        totalStackingTokenSupply += tokenAmount;
    }

    function withdrawTokens() external payable {
        address owner = msg.sender;
        emit LogAddress(owner);

        require(userToTokens[owner].tokenAmount > 0, "No tokens");
        emit LogAmount((block.timestamp - userToTokens[owner].startDate));
        require( (block.timestamp - userToTokens[owner].startDate) > REQUIRED_STACK_TIME_MILIS, "You need to wait 7 days to get your tokens back");

        uint returnedAmount = userToTokens[owner].tokenAmount + ((userToTokens[owner].tokenAmount * REWARD_RATE) / 100000);

        emit LogAmount(userToTokens[owner].tokenAmount);
        emit LogAmount((userToTokens[owner].tokenAmount * REWARD_RATE) / 100000);

        stackingToken.transfer(owner, returnedAmount);
        totalStackingTokenSupply -= returnedAmount;


        userToTokens[msg.sender] = Deposit (0, 0);
    }




}