// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Price Oracle interface
interface IPriceOracle {
    /// @notice returns token price in USD (1e18)
    function getPrice(address token) external view returns (uint256);
}
