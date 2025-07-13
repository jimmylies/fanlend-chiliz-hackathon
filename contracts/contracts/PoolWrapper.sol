pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

interface ILendingPoolV2 {
    function deposit(uint256 amount) external;
    function withdraw(uint256 amount) external;
    function asset() external view returns (IERC20);
    function totalDeposits() external view returns (uint256);
}

contract PoolWrapper is ERC20, ReentrancyGuard {
    ILendingPoolV2 public immutable pool;
    IERC20 public immutable asset;

    constructor(address poolAddress) ERC20("WrappedPoolToken", "wPT") {
        pool = ILendingPoolV2(poolAddress);
        asset = pool.asset();
    }

    function deposit(uint256 amount) external nonReentrant {
        require(amount > 0, "ZERO");
        uint256 totalUnderlying = pool.totalDeposits();
        asset.transferFrom(msg.sender, address(this), amount);
        asset.approve(address(pool), amount);
        pool.deposit(amount);

        uint256 shares;
        if (totalSupply() == 0 || totalUnderlying == 0) {
            shares = amount;
        } else {
            shares = amount * totalSupply() / totalUnderlying;
        }
        _mint(msg.sender, shares);
    }

    function withdraw(uint256 shares) external nonReentrant {
        require(shares > 0, "ZERO");
        uint256 totalUnderlying = pool.totalDeposits();
        uint256 amount = shares * totalUnderlying / totalSupply();

        _burn(msg.sender, shares);
        pool.withdraw(amount);
        asset.transfer(msg.sender, amount);
    }

    function previewDeposit(uint256 amount) external view returns (uint256) {
        uint256 totalUnderlying = pool.totalDeposits();
        if (totalSupply() == 0 || totalUnderlying == 0) {
            return amount;
        }
        return amount * totalSupply() / totalUnderlying;
    }

    function previewWithdraw(uint256 shares) external view returns (uint256) {
        uint256 totalUnderlying = pool.totalDeposits();
        return shares * totalUnderlying / totalSupply();
    }
}
