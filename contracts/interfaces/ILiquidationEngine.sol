// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Liquidation Engine interface
interface ILiquidationEngine {
    event Liquidation(
        address indexed user,
        address collateralToken,
        address borrowToken,
        uint256 repayAmount,
        uint256 seizeAmount
    );
    function liquidate(address user, uint256 posId) external;
}
