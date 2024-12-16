// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Governance {
    struct Proposal {
        string description;
        uint256 voteCount;
        mapping(address => bool) voters; // Removed invalid initializer
    }

    Proposal[] public proposals; // Must be inside the contract
    mapping(address => bool) public hasVoted; // Simplified for tracking voting status

    modifier oneVotePerWallet() {
        require(!hasVoted[msg.sender], "Already voted");
        _;
    }

    function createProposal(string memory _description) public {
        // Push a new proposal to the array
        Proposal storage newProposal = proposals.push();
        newProposal.description = _description;
        newProposal.voteCount = 0;
    }

    function vote(uint256 _proposalId) public oneVotePerWallet {
        require(_proposalId < proposals.length, "Invalid proposal ID");
        Proposal storage proposal = proposals[_proposalId];
        proposal.voteCount += 1;
        proposal.voters[msg.sender] = true; // Record that this address has voted
        hasVoted[msg.sender] = true; // Mark wallet as having voted
    }

    function getProposal(uint256 _proposalId) public view returns (string memory description, uint256 voteCount) {
        require(_proposalId < proposals.length, "Invalid proposal ID");
        Proposal storage proposal = proposals[_proposalId];
        return (proposal.description, proposal.voteCount);
    }
}