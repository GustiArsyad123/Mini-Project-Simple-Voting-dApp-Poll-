// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimplePoll {
    struct Option {
        string name;
        uint256 voteCount;
    }

    Option[] public options;
    mapping(address => bool) public hasVoted;
    bool public votingOpen;
    address public owner;

    event Voted(address indexed voter, uint256 indexed optionIndex);
    event VotingOpened();
    event VotingClosed();

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(string[] memory _optionNames) {
        owner = msg.sender;
        require(_optionNames.length >= 2, "Need at least 2 options");

        for (uint256 i = 0; i < _optionNames.length; i++) {
            options.push(Option({name: _optionNames[i], voteCount: 0}));
        }

        votingOpen = true;
    }

    function vote(uint256 optionIndex) external {
        require(votingOpen, "Voting closed");
        require(!hasVoted[msg.sender], "Already voted");
        require(optionIndex < options.length, "Invalid option");

        hasVoted[msg.sender] = true;
        options[optionIndex].voteCount += 1;

        emit Voted(msg.sender, optionIndex);
    }

    function getOptions()
        external
        view
        returns (string[] memory names, uint256[] memory counts)
    {
        uint256 len = options.length;
        names = new string[](len);
        counts = new uint256[](len);

        for (uint256 i = 0; i < len; i++) {
            names[i] = options[i].name;
            counts[i] = options[i].voteCount;
        }
    }

    function openVoting() external onlyOwner {
        votingOpen = true;
        emit VotingOpened();
    }

    function closeVoting() external onlyOwner {
        votingOpen = false;
        emit VotingClosed();
    }
}
