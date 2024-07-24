// Minting new tokens: The platform should be able to create new tokens and distribute them to players as rewards. Only the owner can mint tokens.
// Transferring tokens: Players should be able to transfer their tokens to others.
// Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
// Checking token balance: Players should be able to check their token balance at any time.
// Burning tokens: Anyone should be able to burn tokens, that they own, that are no longer needed.

// 0x05f7AA0C3e939feFD7cf2216BB7cF88794e265eD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "hardhat/console.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {

    event ItemRedeemed(address indexed player, string item);

    // Mapping to keep track of redeemed items for each player
    mapping(address => string[]) private redeemedItems;

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function transferTokens(address _receiver, uint amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        approve(msg.sender, amount);
        transferFrom(msg.sender, _receiver, amount);
    }

    function checkBalance() external view returns (uint) {
        return balanceOf(msg.sender);
    }

    function burnTokens(uint amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _burn(msg.sender, amount);
    }

    function gameStore() public pure returns (string memory) {
        return "1. T-shirt NFT value = 200 \n2. Boots value = 100 \n3. Hat value = 75";
    }

    function redeemTokens(uint choice) external {
        require(choice >= 1 && choice <= 3, "Invalid selection");

        string memory item;
        uint cost;

        if (choice == 1) {
            item = "T-shirt NFT";
            cost = 200;
        } else if (choice == 2) {
            item = "Boots";
            cost = 100;
        } else if (choice == 3) {
            item = "Hat";
            cost = 75;
        }

        require(balanceOf(msg.sender) >= cost, "Insufficient balance");

        _burn(msg.sender, cost);
        redeemedItems[msg.sender].push(item);
        emit ItemRedeemed(msg.sender, item);
    }

    function getRedeemedItems() external view returns (string[] memory) {
        return redeemedItems[msg.sender];
    }
}
