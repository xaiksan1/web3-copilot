// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract SuperAgentsNosferatu is ERC721, Ownable {
    uint256 public constant TOTAL_SUPPLY = 3;
    uint256 public constant AGENT_PRICE = 0.015 ether; // Prix fixe
    string private _baseTokenURI =
        "https://nosferatu-nfts.example.com/metadata/";

    mapping(uint256 => string) public tokenURIMapping; // URIs pré-calculées
    mapping(uint256 => bool) private _exists; // Optimisation gas

    event TokenMinted(uint256 indexed tokenId, address indexed to);
    event BaseURIUpdated(string newURI);
    event Withdrawal(uint256 amount);

    // ✅ Constructeur corrigé : transmet initialOwner à Ownable
    constructor(
        address initialOwner
    ) ERC721("Super-Agents Nosferatu", "NOSFERATU") Ownable(initialOwner) {}

    function mintAgent(uint256 _agentId) public payable {
        require(_agentId < TOTAL_SUPPLY, "Agent ID out of range");
        require(!_exists[_agentId], "Agent already minted");
        require(msg.value >= AGENT_PRICE, "Insufficient payment");

        // Remboursement automatique
        if (msg.value > AGENT_PRICE) {
            payable(msg.sender).transfer(msg.value - AGENT_PRICE);
        }

        _safeMint(msg.sender, _agentId);
        _exists[_agentId] = true;
        tokenURIMapping[_agentId] = string(
            abi.encodePacked(_baseTokenURI, Strings.toString(_agentId), ".json")
        );
        emit TokenMinted(_agentId, msg.sender);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        require(_exists[tokenId], "Token does not exist");
        return tokenURIMapping[tokenId];
    }

    function setBaseTokenURI(string memory newURI) public onlyOwner {
        _baseTokenURI = newURI;
        emit BaseURIUpdated(newURI);
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        payable(owner()).transfer(balance);
        emit Withdrawal(balance);
    }

    receive() external payable {
        revert("No ETH accepted");
    }
}
