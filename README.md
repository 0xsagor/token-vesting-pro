# Token Vesting Pro

This repository offers a secure solution for managing token distributions for team members, advisors, and private sale participants. It ensures long-term alignment by locking tokens and releasing them gradually.

### Key Features
* **Cliff Period:** Prevents any withdrawal until a specific duration has passed.
* **Linear Release:** Smooth, second-by-second token unlocking after the cliff.
* **Revocable Vesting:** Optional feature for founders to reclaim unvested tokens if a contributor leaves.
* **Flat Structure:** Simplified for rapid integration and auditing.

### Deployment Guide
1. Deploy your ERC-20 Token.
2. Deploy `TokenVesting.sol` specifying the beneficiary and timing parameters.
3. Transfer the total allocated tokens to the `TokenVesting` contract address.
