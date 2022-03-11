// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Storage {
    uint256 totalContractBalance = 0;
    mapping(address => uint256) public balance;
    uint256 public constant threshold = 100 * 10**18;
    uint256 public deadline = block.timestamp + 720 minutes;

    function getContractBalance() public view returns (uint256) {
        return totalContractBalance;
    }

    function isActive() public view returns (bool) {
        return block.timestamp <= deadline && totalContractBalance >= threshold;
    }

    function deposit() public payable {
        balance[msg.sender] += msg.value;
        totalContractBalance += msg.value;
    }

    receive() external payable {
        deposit();
    }

    function withdraw() public {
        require(block.timestamp > deadline, "deadline hasn't passed yet");
        require(!isActive(), "Contract is active");
        require(balance[msg.sender] > 0, "You haven't deposited");

        uint256 amount = balance[msg.sender];
        balance[msg.sender] = 0;
        totalContractBalance -= amount;

        payable(msg.sender).transfer(amount);
    }
}
