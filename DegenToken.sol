// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "hardhat/console.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function transferTokens(address _receiver, uint amount) external {
        require(balanceOf(msg.sender) >= amount, "you are not owner");
        approve(msg.sender, amount);
        transferFrom(msg.sender, _receiver, amount);
    }

    function checkBalance() external view returns (uint) {
        return balanceOf(msg.sender);
    }

    function burnTokens(uint amount) external {
        require(balanceOf(msg.sender) >= amount, "You do not have enough Tokens");
        _burn(msg.sender, amount);
    }

    function gameStore() public pure returns (string memory) {
        return "1.Player1 NFT value = 200 \n 2. Player2 value = 100 \n 3. Player3 value = 75";
    }

    function redeemTokens(uint choice) external payable {
        require(choice <= 3, "Invalid selection");
        if (choice == 1) {
            require(balanceOf(msg.sender) >= 200, "Insufficient Balance");
            approve(msg.sender, 200);
            transferFrom(msg.sender, owner(), 200);
        } else if (choice == 2) {
            require(balanceOf(msg.sender) >= 100, "Insufficient Balance");
            approve(msg.sender, 100);
            transferFrom(msg.sender, owner(), 100);
        } else {
            require(balanceOf(msg.sender) >= 75, "Insufficient Balance");
            approve(msg.sender, 75);
            transferFrom(msg.sender, owner(), 75);
        }
    }
}
