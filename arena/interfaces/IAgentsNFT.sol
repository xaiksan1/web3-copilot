// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

interface IAgentsNFT {
    // ￉v￩nements (optionnels dans une interface, mais utiles pour la documentation)
    /*
    event TokenMinted(uint256 indexed tokenId, address indexed to);
    event BaseURIUpdated(string newURI);
    event HubUpdated(address newHub);
    */

    // Fonctions externes
    function mintAgent(uint256 _agentId) external payable;

    function tokenURI(uint256 tokenId) external view returns (string memory);

    function setBaseTokenURI(string memory newURI) external;

    function setHub(address _hub) external;

    function withdraw() external;
}
