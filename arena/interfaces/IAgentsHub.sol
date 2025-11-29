pragma solidity ^0.8.20;

interface IAgentsHub {
    struct AgentData {
        address owner;
        uint256 level;
        uint256[] skills;
        bool isActive;
    }

    function registerAgent(uint256 tokenId, address owner) external;

    function levelUp(uint256 tokenId) external;

    function getAgentData(
        uint256 tokenId
    ) external view returns (AgentData memory);
}

// IArena.sol
pragma solidity ^0.8.20;

interface IArena {
    function battle(uint256 agent1, uint256 agent2) external;

    function claimReward(uint256 agentId) external;
}
