pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract LendingPoolV2 is Ownable, ReentrancyGuard, Pausable {
    IERC20 public immutable asset;
    uint256 public totalDeposits;
    uint256 public totalBorrows;
    uint256 public reserveFactor; // percentage (e.g. 1500 = 15%)
    uint256 public collateralRatio; // e.g. 150 = 150%
    uint256 public constant RAY = 1e27;
    struct UserPosition {
        uint256 deposit;
        uint256 borrow;
        uint256 timestamp;
    }
    mapping(address => UserPosition) internal positions;

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event Borrow(address indexed user, uint256 amount);
    event Repay(address indexed user, uint256 amount);
    event Liquidate(address indexed liquidator, address indexed user, uint256 repayAmount, uint256 collateralSeized);

    constructor(address _asset, uint256 _reserveFactor, uint256 _collateralRatio) {
        asset = IERC20(_asset);
        reserveFactor = _reserveFactor;
        collateralRatio = _collateralRatio;
    }

    function deposit(uint256 amount) external whenNotPaused nonReentrant {
        require(amount > 0, "ZERO");
        accrue(msg.sender);
        asset.transferFrom(msg.sender, address(this), amount);
        positions[msg.sender].deposit += amount;
        totalDeposits += amount;
        emit Deposit(msg.sender, amount);
    }

    function withdraw(uint256 amount) external whenNotPaused nonReentrant {
        accrue(msg.sender);
        require(positions[msg.sender].deposit >= amount, "INSUFFICIENT");
        positions[msg.sender].deposit -= amount;
        totalDeposits -= amount;
        require(_healthFactor(msg.sender) >= RAY, "UNSAFE");
        asset.transfer(msg.sender, amount);
        emit Withdraw(msg.sender, amount);
    }

    function borrow(uint256 amount) external whenNotPaused nonReentrant {
        require(amount > 0, "ZERO");
        accrue(msg.sender);
        uint256 maxBorrow = positions[msg.sender].deposit * RAY / (collateralRatio * 1e25);
        require(positions[msg.sender].borrow + amount <= maxBorrow, "COLLATERAL");
        positions[msg.sender].borrow += amount;
        totalBorrows += amount;
        positions[msg.sender].timestamp = block.timestamp;
        asset.transfer(msg.sender, amount);
        emit Borrow(msg.sender, amount);
    }

    function repay(uint256 amount) external whenNotPaused nonReentrant {
        accrue(msg.sender);
        require(positions[msg.sender].borrow > 0, "NO_DEBT");
        uint256 pay = amount > positions[msg.sender].borrow ? positions[msg.sender].borrow : amount;
        positions[msg.sender].borrow -= pay;
        totalBorrows -= pay;
        asset.transferFrom(msg.sender, address(this), pay);
        emit Repay(msg.sender, pay);
    }

    function liquidate(address user) external whenNotPaused nonReentrant {
        accrue(user);
        require(_healthFactor(user) < RAY, "HEALTHY");
        uint256 debt = positions[user].borrow;
        uint256 collateral = positions[user].deposit;
        positions[user].borrow = 0;
        positions[user].deposit = 0;
        totalBorrows -= debt;
        totalDeposits -= collateral;
        uint256 seize = debt * collateralRatio / 100;
        if (seize > collateral) seize = collateral;
        asset.transfer(msg.sender, seize);
        emit Liquidate(msg.sender, user, debt, seize);
    }

    function accrue(address user) public {
        uint256 borrowed = positions[user].borrow;
        uint256 ts = positions[user].timestamp;
        if (borrowed > 0 && ts > 0) {
            uint256 dt = block.timestamp - ts;
            uint256 rate = interestRate();
            uint256 interest = borrowed * rate * dt / (365 days) / RAY;
            positions[user].borrow += interest;
            totalBorrows += interest;
        }
        positions[user].timestamp = block.timestamp;
    }

    function interestRate() public view returns (uint256) {
        if (totalBorrows * 10000 / totalDeposits < 8000) {
            return 5e25; // 5%
        } else {
            return 1e26; // 10%
        }
    }

    function healthFactor(address user) external view returns (uint256) {
        return _healthFactor(user);
    }

    function _healthFactor(address user) internal view returns (uint256) {
        if (positions[user].borrow == 0) return type(uint256).max;
        return positions[user].deposit * RAY / (positions[user].borrow * collateralRatio / 100);
    }

    function setReserveFactor(uint256 rf) external onlyOwner {
        reserveFactor = rf;
    }

    function setCollateralRatio(uint256 cr) external onlyOwner {
        collateralRatio = cr;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}
