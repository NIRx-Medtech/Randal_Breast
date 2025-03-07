%% MGradients function
% MGradients computes gradient-like transformations of the Gibbs Free Energy (GFE) matrix.
%
% Usage:
%   Z = MGradients(GFE)
%
% Input:
%   - GFE: A 10x10 Gibbs Free Energy matrix.
%
% Output:
%   - Z: A transformed matrix representing gradient values along different 
%        sliding directions.
%
% Description:
% This function performs the following operations:
% 1. Reshapes GFE into a 100x1 column vector.
% 2. Computes pairwise differences between all elements.
% 3. Applies a predefined diagonal shift matrix (`dpd0`) to extract directional gradients.
% 4. Computes gradient accumulations in three different sliding directions:
%    - First sliding direction (summation across certain blocks).
%    - Second sliding direction (column reordering transformation).
%    - Third slicing direction (reshaping into 10x10 blocks).
%
% This function is useful in analyzing directional energy changes in the GFE matrix.

function Z = MGradients(GFE)

% Reshape GFE into a 100x1 column vector
X = reshape(GFE, [100, 1]);

% Compute pairwise differences for all elements
Y = repmat(X, [1, 100]) - repmat(X', [100, 1]);

% Initialize directional shift matrix for sliding gradients
dpd0 = [ones([10, 1]), zeros([10, 9])]; 
dpd0 = repmat(dpd0, [1, 10]); % Repeat for 10x10 block structure

% Apply shifts for gradient accumulation
for k = 1:9
    dpd0 = [dpd0; dpd0(1:10, [101-k:100, 1:100-k])]; 
end

% Element-wise multiplication to apply shifts to the gradient matrix
Y = dpd0 .* Y; 

% Compute the first sliding direction (initial block sum)
Z = Y(1:10, :);

% Accumulate values over 10-row blocks for first sliding direction
for k3 = 2:10
    Z = Z + Y(10*k3-9:10*k3, :);
end
       
% Compute the second sliding direction by reordering columns
colOrder = [];
for i = 1:length(GFE)
    colOrder = [colOrder, i:length(GFE):length(GFE)^2];
end

% Append the second directional gradient results
Z(length(GFE)+1:2*length(GFE), :, :) = Z(1:length(GFE), colOrder);

% Compute the third slicing direction by reshaping into 10x10 blocks
for k = 1:10
    Z(2*length(GFE)+1:3*length(GFE), 10*k-9:10*k) = reshape(Z(k, :), [10, 10]); 
end

end
