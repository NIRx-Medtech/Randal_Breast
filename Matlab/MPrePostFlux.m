%% MPrePostFlux Function
% MPrePostFlux computes the pre/post transition mean and flux
% for any component (oxyHb, deoxyHb, totalHb, Saturation, Exchange) over
% all voxels and all time steps.
%
% Usage:
% [pre, post, flux] = MPrePostFlux(StateMatrix, SignalMatrix)
%
% Inputs:
%   - StateMatrix: A matrix where each element represents the state of a voxel/optode at a given time step.
%   - SignalMatrix: A matrix containing signal values corresponding to each voxel/optode and time step.
%
% Outputs:
%   - pre: The mean signal value before each transition.
%   - post: The mean signal value after each transition.
%   - flux: The difference between post and pre transition values.

function [pre, post, flux] = MPrePostFlux(StateMatrix, SignalMatrix)


% Normalization factor for probability calculation
[a b] = size(StateMatrix);
nfac = 100 / ((a-1)*b);

% Initialize pre and post transition matrices
pre = zeros([10 10]);
post = zeros([10 10]);

for preState = 1:10
    for postState = 1:10
        transitions = (StateMatrix(1:end-1, :) == preState) & (StateMatrix(2:end, :) == postState);
        % Find indices of transitions matching the transition pair
        [I, J] = find(transitions == 1);
            
        % Accumulate pre and post transition signal values
        for k2 = 1:length(I)
            pre(preState,postState) = pre(preState,postState) + SignalMatrix(I(k2), J(k2));
            post(preState,postState) = post(preState,postState) + SignalMatrix(I(k2) + 1, J(k2));
        end

    end
end


% Compute transition probabilities using an external function
Prb_T1lb = MTransitionProbs(StateMatrix);
nfac2 = Prb_T1lb / nfac; % Matrix of occurencies for every trainsition pair

% Normalize pre and post transition values
pre = pre ./ nfac2;
post = post ./ nfac2;

% Compute flux as the difference between post and pre
flux = post - pre;

end
