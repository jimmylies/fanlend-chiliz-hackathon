// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../interfaces/ICollateralVault.sol";
import "../interfaces/IPriceOracle.sol";

/// @notice Manages user collateral deposits/withdrawals and value accounting
contract CollateralVault is ICollateralVault {
    using SafeERC20 for IERC20;

    /// user => token => amount
    mapping(address => mapping(address => uint256)) public collateralBalances;

    IPriceOracle public immutable priceOracle;

    constructor(IPriceOracle _priceOracle) {
        priceOracle = _priceOracle;
    }

    /// @inheritdoc ICollateralVault
    function deposit(address token, uint256 amount) external override {
        require(amount > 0, "CollateralVault: amount=0");
        collateralBalances[msg.sender][token] += amount;
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        emit Deposit(msg.sender, token, amount);
    }

    /// @inheritdoc ICollateralVault
    function withdraw(address token, uint256 amount) external override {
        uint256 bal = collateralBalances[msg.sender][token];
        require(bal >= amount, "CollateralVault: insufficient");
        collateralBalances[msg.sender][token] = bal - amount;
        IERC20(token).safeTransfer(msg.sender, amount);
        emit Withdraw(msg.sender, token, amount);
    }

    /// @inheritdoc ICollateralVault
    function getCollateralValue(address user, address token)
        external
        view
        override
        returns (uint256)
    {
        uint256 amt = collateralBalances[user][token];
        uint256 price = priceOracle.getPrice(token);
        return (amt * price) / 1e18;
    }
}
