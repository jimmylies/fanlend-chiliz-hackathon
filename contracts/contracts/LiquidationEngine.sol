// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../interfaces/ILiquidationEngine.sol";
import "../interfaces/ICollateralVault.sol";
import "../interfaces/IPositionManager.sol";
import "../interfaces/IPriceOracle.sol";

/// @notice Allows public liquidation of under-collateralized positions
contract LiquidationEngine is ILiquidationEngine {
    using SafeERC20 for IERC20;

    ICollateralVault   public immutable vault;
    IPositionManager   public immutable manager;
    IPriceOracle       public immutable oracle;

    /// e.g. 0.05e18 = 5% bonus to liquidator
    uint256 public immutable liquidationBonus;

    constructor(
        ICollateralVault _vault,
        IPositionManager _manager,
        IPriceOracle _oracle,
        uint256 _bonus
    ) {
        vault            = _vault;
        manager          = _manager;
        oracle           = _oracle;
        liquidationBonus = _bonus;
    }

    /// @inheritdoc ILiquidationEngine
    function liquidate(
        address user,
        uint256 posId
    ) external override {
        IPositionManager.Position memory pos = manager.getPosition(user, posId);

        uint256 collVal  = vault.getCollateralValue(user, pos.collateralToken);
        uint256 borrowVal= (pos.borrowAmount * oracle.getPrice(pos.borrowToken)) / 1e18;

        // check under-collateralized: borrowVal > collVal * maxLTV
        require(
            borrowVal * 1e18 > collVal * manager.maxLTV(),
            "LiquidationEngine: healthy"
        );

        // liquidator repays debt
        IERC20(pos.borrowToken).safeTransferFrom(
            msg.sender,
            address(manager),
            pos.borrowAmount
        );
        manager.closePosition(user, posId);

        // calculate collateral to seize with bonus
        uint256 seizeValue = (borrowVal * (1e18 + liquidationBonus)) / 1e18;
        uint256 priceColl = oracle.getPrice(pos.collateralToken);
        uint256 seizeAmt   = (seizeValue * 1e18) / priceColl;

        vault.withdraw(pos.collateralToken, seizeAmt);
        IERC20(pos.collateralToken).safeTransfer(msg.sender, seizeAmt);

        emit Liquidation(user, pos.collateralToken, pos.borrowToken, pos.borrowAmount, seizeAmt);
    }
}
