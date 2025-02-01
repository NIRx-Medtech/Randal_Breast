%% MGibbsFreeEnergy function
% MGibbsFreeEnergy computes the Gibbs Free Energy (GFE) for a given 
% signal matrix based on a specified component.
%
% Usage:
%   GFE = MGibbsFreeEnergy(SignalMatrixO, SignalMatrixD, component)
%
% Inputs:
%   - SignalMatrixO: Original signal matrix
%   - SignalMatrixD: Distorted or modified signal matrix
%   - component: String specifying the component type 
%       ('deoxy', 'exc', 'oxy', 'sat', 'tot')
%
% Output:
%   - GFE: 10x10 matrix representing the Gibbs Free Energy for 
%     transition states based on the selected component.
%
% This function first selects the appropriate diffusion constant (DC) 
% based on the component type. Then, it computes the centroid matrix 
% and calculates Gibbs Free Energy across 100 transition pairs.

% Choose the proper DC and index according to the selected component

function GFE = MGibbsFreeEnergy(SignalMatrixO, SignalMatrixD, component)

switch component
    case 'deoxy'
        DC = 9e-6;  % Diffusion constant for deoxygenated hemoglobin
        k1 = 1;
    case 'exc'
        DC = -4.2e-5; % Diffusion constant for excited state
        k1 = 2;
    case 'oxy'
        DC = -5.1e-5; % Diffusion constant for oxygenated hemoglobin
        k1 = 3;
    case 'sat'
        DC = 85;  % Saturation level constant
        k1 = 4;
    case 'tot'
        DC = 6e-5; % Total component
        k1 = 5;
    otherwise
        error('Component is not defined correctly. Choose from deoxy, exc, oxy, sat, or tot.')
end

% Compute the Centroid Matrix from Signal Matrices
Ldat = MComputeCentroids(SignalMatrixO, SignalMatrixD);

% Initialize the Gibbs Free Energy Matrix for 100 transition pairs
Gisit = zeros([100, 4]);

% Compute Gibbs Free Energy for each transition pair
for k2 = 1:100
    % Extract relevant centroid data and add DC
    G3 = Ldat(k2, [k1+4, k1+9]) + DC;
    
    % Compute Gibbs Free Energy using the logarithmic ratio
    Gisit(k2, :) = [Ldat(k2, 1:3), G3(1) * log(G3(1) / G3(2))];
end

% Reshape the computed Gibbs Free Energy into a 10x10 matrix
GFE = reshape(Gisit(:, 4), [10, 10])';

end
