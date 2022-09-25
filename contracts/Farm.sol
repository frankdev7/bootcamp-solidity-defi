// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Candy.sol";
import "./Bee.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Farm is Ownable {
    string public name = "Token farm";
    Candy public candyToken;
    Bee public beeToken;

    address[] public stakers;
    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    constructor(Candy candyToken_, Bee beeToken_) {
        candyToken = candyToken_;
        beeToken = beeToken_;
    }

    modifier checkBalanceForStake(uint256 amount_) {
        require(amount_ > 0, "greater than zero");
        _;
    }

    modifier checkBalanceForUnstake() {
        uint256 balance = stakingBalance[msg.sender];
        require(balance > 0, "you dont have tokens");
        _;
    }

    function stakeTokens(uint256 amount_) public checkBalanceForStake(amount_) {
        beeToken.transferFrom(msg.sender, address(this), amount_);
        // update staking balance
        stakingBalance[msg.sender] += amount_;
        // save staker
        if (!hasStaked[msg.sender]) stakers.push(msg.sender);
        // update staking status
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

    function unstakeTokens() public checkBalanceForUnstake {
        uint256 balance = stakingBalance[msg.sender];
        beeToken.transfer(msg.sender, balance);
        stakingBalance[msg.sender] = 0;
        isStaking[msg.sender] = false;
    }

    function claimRewards() public {
        uint256 balance = stakingBalance[msg.sender];
        if (balance > 0) {
            candyToken.transfer(msg.sender, balance);
        }
    }
}
