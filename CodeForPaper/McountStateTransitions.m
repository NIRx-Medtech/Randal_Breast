%% McountStateTransitions function
% McountStateTransitions computes the occurrences of transitions from one state to another.
%
% Usage:
%   count = McountStateTransitions(StateMatrix, preState, postState)
%
% Inputs:
%   - StateMatrix: A matrix where each element represents the state of a voxel/optode at a given time step.
%   - preState: The initial state in the transition.
%   - postState: The target state in the transition.
%
% Output:
%   - count: The number of times the transition from fromState to toState occurs.

function count = McountStateTransitions(StateMatrix, preState, postState)

% Find transitions from `preState` to `postState`
transitions = (StateMatrix(1:end-1, :) == preState) & (StateMatrix(2:end, :) == postState);

% Count occurrences of the transitions
count = sum(transitions(:));

end