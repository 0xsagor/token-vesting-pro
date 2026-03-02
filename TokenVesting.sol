// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract TokenVesting is Ownable, ReentrancyGuard {
    IERC20 public immutable token;
    address public immutable beneficiary;
    
    uint256 public immutable start;
    uint256 public immutable cliff;
    uint256 public immutable duration;
    
    uint256 public released;
    bool public revoked;

    event TokensReleased(uint256 amount);
    event VestingRevoked();

    constructor(
        address _token,
        address _beneficiary,
        uint256 _start,
        uint256 _cliffDuration,
        uint256 _duration
    ) Ownable(msg.sender) {
        require(_beneficiary != address(0), "Zero address");
        token = IERC20(_token);
        beneficiary = _beneficiary;
        duration = _duration;
        start = _start;
        cliff = _start + _cliffDuration;
    }

    function release() public nonReentrant {
        uint256 unreleased = _releasableAmount();
        require(unreleased > 0, "No tokens to release");

        released += unreleased;
        token.transfer(beneficiary, unreleased);

        emit TokensReleased(unreleased);
    }

    function _releasableAmount() internal view returns (uint256) {
        return _vestedAmount() - released;
    }

    function _vestedAmount() internal view returns (uint256) {
        uint256 currentBalance = token.balanceOf(address(this));
        uint256 totalBalance = currentBalance + released;

        if (block.timestamp < cliff) {
            return 0;
        } else if (block.timestamp >= start + duration || revoked) {
            return totalBalance;
        } else {
            return (totalBalance * (block.timestamp - start)) / duration;
        }
    }

    function revoke() public onlyOwner {
        require(!revoked, "Already revoked");
        uint256 balance = token.balanceOf(address(this));
        uint256 unvested = balance - _releasableAmount();
        
        revoked = true;
        token.transfer(owner(), unvested);
        emit VestingRevoked();
    }
}
