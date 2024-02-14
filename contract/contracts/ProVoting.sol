// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract ProVoting {

    struct Proposal {
        uint256 proposalId;
        string title;
        string description;
        uint256 voteCount;
        uint256 yesVotes;
        uint256 noVotes;
    }

    event ProposalAdded(uint256 _newProposalId, string _newProposalTitle);
    event VoteCasted(address indexed voter, uint256 indexed proposalId, bool vote);

    mapping(uint256 => mapping(address => bool)) private alreadyVoted; //Mapping of proposal IDs to whether an address has voted for that proposal

    Proposal[] public proposals; // this line creates an array called proposals that will store all of the Proposal objects.

    // creates a modifier to ensure that provided string is not empty
    modifier nonEmptyString(string memory str) {
        require(bytes(str).length > 0, "String cannot be empty");
        _;
    }

    function createProposal(string memory _title, string memory _description) 
        public
        nonEmptyString(_title)
        nonEmptyString(_description) {
        
        Proposal memory newProposal = Proposal({
            proposalId: proposals.length,
            title: _title,
            description: _description,
            voteCount: 0,
            yesVotes: 0,
            noVotes: 0
        });

        proposals.push(newProposal);

        emit ProposalAdded(newProposal.proposalId, newProposal.title);
    }

    function vote(uint256 _proposalId, bool _yesVote) public {
        require(_proposalId < proposals.length, "Invalid proposal ID");
        require(
            !alreadyVoted[_proposalId][msg.sender],
            "You have already voted for this proposal"
        );

        if (_yesVote){
            proposals[_proposalId].yesVotes += 1;
        }
        else {
            proposals[_proposalId].noVotes += 1;
        }

        proposals[_proposalId].voteCount += 1;
        alreadyVoted[_proposalId][msg.sender] = true;

        emit VoteCasted(msg.sender, _proposalId, _yesVote);
    }

    function getProposalVotes(uint256 _proposalId)
        public
        view
        returns (uint256 yesVotes, uint256 noVotes)
    {
        require(_proposalId < proposals.length, "Invalid proposal ID");
        return (
            proposals[_proposalId].yesVotes,
            proposals[_proposalId].noVotes
        );
    }

    function getProposals() public view returns (Proposal[] memory) {
        return proposals;
    }

}