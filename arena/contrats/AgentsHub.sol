// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IAgentsHub.sol";
import "./interfaces/IAgentsNFT.sol";  // ← NOUVEAU : Import de l'interface
import "./interfaces/IArena.sol";
import "./libraries/AlexandriaMath.sol";

contract AgentsHub is IAgentsHub, Ownable {
    using AlexandriaMath for uint256;

    // Déclarations des interfaces et variables
    IArena public arena;
    IAgentsNFT public agentsNFT;  // ← NOUVEAU : Référence au contrat NFT
    mapping(uint256 => AgentData) private _agents;
    mapping(uint256 => string) public methodNames; // Nom des méthodes (ex: "Zangetsu Tensa Noir")

    // Données d'un agent + compétences
    struct AgentData {
        address owner;
        uint256 level;
        mapping(uint256 => uint256) skills; // skillId => niveau de maîtrise
        bool isActive;
    }

    // Événements
    event AgentRegistered(uint256 indexed tokenId, address indexed owner);
    event SkillAdded(uint256 indexed tokenId, uint256 skillId, uint256 level);
    event MethodPowerCalculated(uint256 indexed tokenId, uint256 skillId, uint256 power);

    // ← NOUVEAU : Constructeur mis à jour pour accepter l'adresse de AgentsNFT
    constructor(address _arena, address _agentsNFT) {
        arena = IArena(_arena);
        agentsNFT = IAgentsNFT(_agentsNFT);  // ← NOUVEAU : Initialisation
        // Exemple: Ajout des noms de méthodes (à compléter avec ton CSV)
        methodNames[1] = "Zangetsu Tensa Noir";
        methodNames[2] = "Serena Scalpel";
        // ...
    }

    // ← NOUVEAU : Fonction helper pour vérifier la propriété du NFT
    function _checkNFTOwnership(uint256 tokenId, address owner) private view {
        require(agentsNFT.ownerOf(tokenId) == owner, "Not NFT owner");
    }

    // Enregistrement d'un agent (appelé par AgentsNFT) ← MODIFIÉ
    function registerAgent(uint256 tokenId, address owner) external override {
        require(_agents[tokenId].owner == address(0), "Agent already registered");
        _checkNFTOwnership(tokenId, owner);  // ← NOUVEAU : Vérification de propriété
        _agents[tokenId] = AgentData({owner: owner, level: 1, isActive: true});
        emit AgentRegistered(tokenId, owner);
    }

    // Ajouter une compétence (ex: bmad-alexandria-methods) ← MODIFIÉ
    function addSkill(uint256 tokenId, uint256 skillId, uint256 skillLevel) external override {
        require(_agents[tokenId].owner == msg.sender, "Not owner");
        _checkNFTOwnership(tokenId, msg.sender);  // ← NOUVEAU : Vérification supplémentaire
        _agents[tokenId].skills[skillId] = skillLevel;
        emit SkillAdded(tokenId, skillId, skillLevel);

        // Calcul de la puissance exponentielle (ex: 7.1 quadrillions)
        uint256 power = skillLevel.calculateMethodPower();
        emit MethodPowerCalculated(tokenId, skillId, power);
    }

    // Monter de niveau ← MODIFIÉ
    function levelUp(uint256 tokenId) external override {
        require(_agents[tokenId].owner == msg.sender, "Not owner");
        _checkNFTOwnership(tokenId, msg.sender);  // ← NOUVEAU : Vérification supplémentaire
        _agents[tokenId].level++;
    }

    // Lire les données d'un agent
    function getAgentData(uint256 tokenId) external view override returns (AgentData memory) {
        return _agents[tokenId];
    }

    // Lire la puissance d'une méthode
    function getMethodPower(uint256 tokenId, uint256 skillId) external view returns (uint256) {
        uint256 skillLevel = _agents[tokenId].skills[skillId];
        require(skillLevel > 0, "Skill not acquired");
        return skillLevel.calculateMethodPower();
    }

    // Changer l'adresse de l'Arena
    function setArenaAddress(address _newArena) external onlyOwner {
        arena = IArena(_newArena);
    }
}