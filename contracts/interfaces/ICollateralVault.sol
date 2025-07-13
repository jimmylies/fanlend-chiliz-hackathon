// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Collateral Vault interface
interface ICollateralVault {
    event Deposit(address indexed user, address indexed token, uint256 amount);
    event Withdraw(address indexed user, address indexed token, uint256 amount);
    function deposit(address token, uint256 amount) external;
    function withdraw(address token, uint256 amount) external;
    function getCollateralValue(address user, address token) external view returns (uint256);
}
