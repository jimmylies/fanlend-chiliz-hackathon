// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Position Manager interface
interface IPositionManager {
    event PositionOpened(
        address indexed user,
        uint256 indexed posId,
        address collateralToken,
        address borrowToken,
        uint256 borrowAmount
    );
    event PositionClosed(address indexed user, uint256 indexed posId);

    struct Position {
        address collateralToken;
        uint256 collateralValue;
        address borrowToken;
        uint256 borrowAmount;
    }

    function openPosition(
        address collateralToken,
        address borrowToken,
        uint256 borrowAmount
    ) external;

    function closePosition(address user, uint256 posId) external;
    function getPosition(address user, uint256 posId) external view returns (Position memory);
    function maxLTV() external view returns (uint256);
}
