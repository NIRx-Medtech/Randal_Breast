%% MTransitionProbs Function
% This function calculates the transition probability matrix for a given state sequence.
% It computes the frequency of transitions between states over time across multiple voxels,
% normalizes these frequencies, and returns a 10x10 matrix representing transition probabilities.
%
% Usage:
%   Prb_T1lb = MTransitionProbs(StateMatrix);
%
% Inputs:
%   - StateMatrix: A matrix where each column represents the state of a voxel over time.
%
% Outputs:
%   - TrProbMatrix: A 10x10 matrix containing transition probabilities between states.

function TrProbMatrix = MTransitionProbs(StateMatrix)

for preState = 1:10
    for postState = 1:10
        transitionsCount(preState,postState) = McountStateTransitions(StateMatrix,preState,postState);
    end
end

% Initialize a 10x10 transition probability matrix
TrProbMatrix = zeros(10, 10);

% Compute normalization factor: percentage per transition type
% Number of total transitions is the number of voxels times the number of time steps
nfac = 100 / sum(sum(transitionsCount));

% Divide the number of occurences by the total transitions and multiply by
% 100 %
TrProbMatrix = nfac .* transitionsCount;

end
