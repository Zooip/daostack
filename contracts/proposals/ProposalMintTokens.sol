pragma solidity ^0.4.4;

import "./Proposal.sol";
import "../DAOInterface.sol";
import "../MintableToken.sol";
import "../Reputation.sol";


contract ProposalMintTokens is Proposal {
	/* a proposal to decide to assign a number of new tokens to a given beneficary 

    The constructor takes the following arguments:

        _dao: 
        _amount: the amount of tokens to assign
        _beneficary: the beneficary of the action

    The proposal can be executed in case:
        - more than 50% of reputation holders in the reputation contract 
          have voted 'y' on the proposal
        - the reputationContract has the rights to mint new tokens

	*/

    bool public executed;
    DAOInterface public dao;
    uint256 public amount;
    address public beneficary;


    function ProposalMintTokens( 
        address _dao,
        uint256 _amount,
        address _beneficary
        )  Proposal (DAOInterface(_dao).reputationContract()) {
        dao = DAOInterface(_dao);
        amount = _amount;
        beneficary = _beneficary;
    }


    function executeDecision() returns (bool) {
        /*
            This function expects to be called from the dao (by calling dao.executeProposal(proposal))
        */
        if (winningChoice() == 1) {
            dao.mintTokens(amount, beneficary);
            ProposalExecuted('ProposalMintTokens executed');
            return true;
        } 
        return false;

        // use "delegatecall" to have code running in the context of the original msg.sender
        // if (!dao.delegatecall(bytes4(sha3("mintTokens(uint256,address,address)")), amount, beneficary, dao.tokenContract())) {
        //     throw;
        // } 
    }   

}