// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library AlexandriaMath {
    // M￩thode exponentielle pour les comp￩tences (7.1 quadrillions au niveau N)
    function calculateMethodPower(
        uint256 level
    ) internal pure returns (uint256) {
        require(level > 0, "Level must be > 0");
        // Formule: 1 * 1500^(level-1) (ex: Niv1=1, Niv2=1500, Niv3=1500^2, etc.)
        // NOTE: Utilise des checks pour ￩viter les overflows (m￪me si 0.8.20 les g￨re)
        uint256 power = 1;
        for (uint256 i = 1; i < level; i++) {
            power *= 1500;
        }
        return power;
    }

    // Exemple pour "Zangetsu Tensa Noir" (ajustable)
    function zangetsuTensa(
        uint256 level,
        uint256 baseDamage
    ) internal pure returns (uint256) {
        return baseDamage * calculateMethodPower(level);
    }
}
