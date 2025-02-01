%% MComputeCentroids
% This function computes the centroids of state transitions based on input signal matrices.
% 
% Usage:
% Centroids = MComputeCentroids(SignalMatrixO, SignalMatrixD)
%
% Inputs:
% - SignalMatrixO: Matrix containing oxy-hemoglobin signals.
% - SignalMatrixD: Matrix containing deoxy-hemoglobin signals.
%
% Outputs:
% - Centroids: A 100x14 matrix containing transition statistics and related signal values.
%
% Description:
% The function first computes the state transitions from the input signal matrices.
% It then calculates the frequency of transitions between states and extracts
% mean pre- and post-transition values for different signal components, including
% deoxy-hemoglobin, oxy-hemoglobin, saturation, and total hemoglobin.

function Centroids = MComputeCentroids(SignalMatrixO, SignalMatrixD)

    % Convert the signal matrices into a state transition matrix
    StateMatrix = Msignal2states(SignalMatrixO, SignalMatrixD);

    % Initialize the Centroids matrix
    % Column 1: Transition type index (1-100)
    Centroids(:,1) = (1:100)';

    % Column 2: Starting state (1-10)
    Centroids(:,2) = repelem((1:10)', 10);

    % Column 3: Ending state (1-10)
    Centroids(:,3) = repmat((1:10)', 10, 1);

    % Column 4: Count of transitions from starting state to ending state
    for i = 1:length(Centroids)
        Centroids(i,4) = McountStateTransitions(StateMatrix, Centroids(i,2), Centroids(i,3));
    end

    % Compute pre- and post-transition values for different signal components

    % Columns 5 and 10: Pre- and post-transition values for deoxy-hemoglobin
    [pre, post, ~] = MPrePostFlux(StateMatrix, SignalMatrixD);
    Centroids(:,5) = reshape(pre', [100,1]);
    Centroids(:,10) = reshape(post', [100,1]);

    % Columns 6 and 11: Pre- and post-transition values for exchange component
    [pre, post, ~] = MPrePostFlux(StateMatrix, MOxyDeoxy2Components(SignalMatrixO, SignalMatrixD, 'exc'));
    Centroids(:,6) = reshape(pre', [100,1]);
    Centroids(:,11) = reshape(post', [100,1]);

    % Columns 7 and 12: Pre- and post-transition values for oxy-hemoglobin
    [pre, post, ~] = MPrePostFlux(StateMatrix, SignalMatrixO);
    Centroids(:,7) = reshape(pre', [100,1]);
    Centroids(:,12) = reshape(post', [100,1]);

    % Columns 8 and 13: Pre- and post-transition values for saturation
    [pre, post, ~] = MPrePostFlux(StateMatrix, MOxyDeoxy2Components(SignalMatrixO, SignalMatrixD, 'sat'));
    Centroids(:,8) = reshape(pre', [100,1]);
    Centroids(:,13) = reshape(post', [100,1]);

    % Columns 9 and 14: Pre- and post-transition values for total hemoglobin
    [pre, post, ~] = MPrePostFlux(StateMatrix, MOxyDeoxy2Components(SignalMatrixO, SignalMatrixD, 'tot'));
    Centroids(:,9) = reshape(pre', [100,1]);
    Centroids(:,14) = reshape(post', [100,1]);

end
