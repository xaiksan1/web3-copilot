// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IArena.sol";
import "./interfaces/IAgentsHub.sol";
import "./libraries/AlexandriaMath.sol";

contract Arena is IArena, Ownable {
    using AlexandriaMath for uint256;

    IAgentsHub public hub;
    mapping(uint256 => uint256) public agentWins;
    uint256 public rewardPerWin = 0.001 ether; // R￩compense par victoire

    event BattleResult(
        uint256 indexed agent1,
        uint256 indexed agent2,
        bool agent1Won,
        uint256 power1,
        uint256 power2
    );
    event RewardClaimed(uint256 indexed agentId, uint256 amount);

    constructor(address _hub) {
        hub = IAgentsHub(_hub);
    }

    // Combat entre 2 agents (utilise les comp￩tences exponentielles)
    function battle(
        uint256 agent1,
        uint256 agent2,
        uint256 skillId
    ) external override {
        require(agent1 != agent2, "Same agent");

        // R￩cup￨re les donn￩es des agents
        AgentsHub.AgentData memory data1 = hub.getAgentData(agent1);
        AgentsHub.AgentData memory data2 = hub.getAgentData(agent2);

        // Calcul la puissance de la m￩thode utilis￩e (ex: Zangetsu Tensa Noir)
        uint256 power1 = data1.skills[skillId].calculateMethodPower();
        uint256 power2 = data2.skills[skillId].calculateMethodPower();

        // Logique de combat (simplifi￩e)
        bool agent1Wins = power1 > power2;
        if (agent1Wins) agentWins[agent1]++;
        else agentWins[agent2]++;

        emit BattleResult(agent1, agent2, agent1Wins, power1, power2);
    }

    // R￩clamer les r￩compenses
    function claimReward(uint256 agentId) external override {
        require(agentWins[agentId] > 0, "No wins");
        uint256 reward = agentWins[agentId] * rewardPerWin;
        agentWins[agentId] = 0;
        payable(msg.sender).transfer(reward);
        emit RewardClaimed(agentId, reward);
    }

    // Changer le Hub
    function setHubAddress(address _newHub) external onlyOwner {
        hub = IAgentsHub(_newHub);
    }

    // Changer la r￩compense par victoire
    function setRewardPerWin(uint256 _reward) external onlyOwner {
        rewardPerWin = _reward;
    }
}
