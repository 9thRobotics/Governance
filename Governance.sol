// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Governance is Ownable {
    using SafeMath for uint256;

    struct Proposal {
        string description;
        uint256 voteCount;
        mapping(address => bool) voters;
    }

    Proposal[] public proposals;
    mapping(address => bool) public hasVoted;

    event ProposalCreated(uint256 proposalId, string description);
    event VoteCast(address voter, uint256 proposalId);

    modifier oneVotePerWallet() {
        require(!hasVoted[msg.sender], "Already voted");
        _;
    }

    function createProposal(string memory _description) public onlyOwner {
        Proposal storage newProposal = proposals.push();
        newProposal.description = _description;
        newProposal.voteCount = 0;
        emit ProposalCreated(proposals.length - 1, _description);
    }

    function vote(uint256 _proposalId) public oneVotePerWallet {
        require(_proposalId < proposals.length, "Invalid proposal ID");
        Proposal storage proposal = proposals[_proposalId];
        proposal.voteCount = proposal.voteCount.add(1);
        proposal.voters[msg.sender] = true;
        hasVoted[msg.sender] = true;
        emit VoteCast(msg.sender, _proposalId);
    }

    function getProposal(uint256 _proposalId) public view returns (string memory description, uint256 voteCount) {
        require(_proposalId < proposals.length, "Invalid proposal ID");
        Proposal storage proposal = proposals[_proposalId];
        return (proposal.description, proposal.voteCount);
    }
}
