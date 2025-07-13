// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../interfaces/IPositionManager.sol";
import "../interfaces/ICollateralVault.sol";
import "../interfaces/IPriceOracle.sol";

/// @notice Tracks borrowing positions and enforces LTV
contract PositionManager is IPositionManager {
    ICollateralVault public immutable vault;
    IPriceOracle   public immutable oracle;

    /// max LTV in 1e18 (e.g. 0.75e18 for 75%)
    uint256 public immutable maxLTV;

    struct Position {
        address collateralToken;
        uint256 collateralValue;  // in USD (1e18)
        address borrowToken;
        uint256 borrowAmount;     // raw token amount
    }

    /// user => position IDs
    mapping(address => Position[]) public positions;

    constructor(
        ICollateralVault _vault,
        IPriceOracle _oracle,
        uint256 _maxLTV
    ) {
        vault    = _vault;
        oracle   = _oracle;
        maxLTV   = _maxLTV;
    }

    /// @inheritdoc IPositionManager
    function openPosition(
        address collateralToken,
        address borrowToken,
        uint256 borrowAmount
    ) external override {
        uint256 collValue = vault.getCollateralValue(msg.sender, collateralToken);
        require(collValue > 0, "PositionManager: no collateral");

        // ensure borrowAmount * price <= collValue * maxLTV
        uint256 borrowValue = (borrowAmount * oracle.getPrice(borrowToken)) / 1e18;
        require(
            borrowValue * 1e18 <= collValue * maxLTV,
            "PositionManager: LTV breach"
        );

        // transfer borrowed tokens from user to themselves via external funding
        IERC20(borrowToken).transferFrom(msg.sender, msg.sender, borrowAmount);

        positions[msg.sender].push(
            Position(collateralToken, collValue, borrowToken, borrowAmount)
        );
        emit PositionOpened(
            msg.sender, positions[msg.sender].length - 1,
            collateralToken, borrowToken, borrowAmount
        );
    }

    /// @inheritdoc IPositionManager
    function closePosition(address user, uint256 posId)
        external
        override
    {
        Position memory pos = positions[user][posId];
        // user repays full borrow
        IERC20(pos.borrowToken).transferFrom(msg.sender, address(this), pos.borrowAmount);

        // allow collateral withdrawal separately via vault
        delete positions[user][posId];
        emit PositionClosed(user, posId);
    }

    /// @inheritdoc IPositionManager
    function getPosition(address user, uint256 posId)
        external
        view
        override
        returns (Position memory)
    {
        return positions[user][posId];
    }
}
