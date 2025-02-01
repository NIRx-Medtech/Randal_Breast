%% Msignal2states Function
% This function classifies each voxel(optode)/time point into a specific state
% based on input signals oxyHb and deoxyHb. The function computes derived
% variables and assigns a state index according to predefined conditions.
%
% Usage:
%   StateMatrix = Msignal2states(SignalMatrixO,SignalMatrixD)
%
% Inputs:
%   - SignalMatrixO: oxygenated Hb signal Matrix (each row is a sample point and
%   each column is a voxel/optode)
%   - SignalMatrixD: deoxygenated Hb (each row is a sample point and
%   each column is a voxel/optode)
%
% Output:
%   - StateMatrix: A matrix of the same size as input, with state indices
%              (ranging from 1 to 10) assigned to each voxel/time point.
% 
% Example:
%   StateMatrix = Msignal2states(SignalMatrixO,SignalMatrixD);

function StateMatrix = Msignal2states(SignalMatrixO,SignalMatrixD)
    
    % Compute total signal
    T1lb_tot = MOxyDeoxy2Components(SignalMatrixO, SignalMatrixD, 'tot');
    
    % Define O2 saturation factor (85 for breast tissue, 70 for brain)
    pct_sat = 85;
    
    % Compute derived parameters of Hemoglobin Exchange and Saturation
    T1lb_exc = MOxyDeoxy2Components(SignalMatrixO, SignalMatrixD, 'exc');
    T1lb_sat = MOxyDeoxy2Components(SignalMatrixO, SignalMatrixD, 'sat');
    
    % Determine the sign of each component
    ST1lb_o = sign(SignalMatrixO);
    ST1lb_d = sign(SignalMatrixD);
    ST1lb_tot = sign(T1lb_tot);
    ST1lb_sat = sign(T1lb_sat);
    ST1lb_exc = sign(T1lb_exc);
    
    % Initialize state matrix with zeros
    StateMatrix = zeros(size(SignalMatrixO));
    
    % Assign state indices based on multiple conditions
    StateMatrix(SignalMatrixD<0 & T1lb_exc<0 & SignalMatrixO<0 & T1lb_sat>0 & T1lb_tot<0) = 1;
    StateMatrix(SignalMatrixD<0 & T1lb_exc>0 & SignalMatrixO<0 & T1lb_sat>0 & T1lb_tot<0) = 2;
    StateMatrix(SignalMatrixD<0 & T1lb_exc>0 & SignalMatrixO<0 & T1lb_sat<0 & T1lb_tot<0) = 3;
    StateMatrix(SignalMatrixD>0 & T1lb_exc>0 & SignalMatrixO<0 & T1lb_sat<0 & T1lb_tot<0) = 4;
    StateMatrix(SignalMatrixD>0 & T1lb_exc>0 & SignalMatrixO<0 & T1lb_sat<0 & T1lb_tot>0) = 5;
    StateMatrix(SignalMatrixD>0 & T1lb_exc>0 & SignalMatrixO>0 & T1lb_sat<0 & T1lb_tot>0) = 6;
    StateMatrix(SignalMatrixD>0 & T1lb_exc<0 & SignalMatrixO>0 & T1lb_sat<0 & T1lb_tot>0) = 7;
    StateMatrix(SignalMatrixD>0 & T1lb_exc<0 & SignalMatrixO>0 & T1lb_sat>0 & T1lb_tot>0) = 8;
    StateMatrix(SignalMatrixD<0 & T1lb_exc<0 & SignalMatrixO>0 & T1lb_sat>0 & T1lb_tot>0) = 9;
    StateMatrix(SignalMatrixD<0 & T1lb_exc<0 & SignalMatrixO>0 & T1lb_sat>0 & T1lb_tot<0) = 10;

end
