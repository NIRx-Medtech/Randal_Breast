%% MOxyDeoxy2Components
% This function computes different signal components based on the provided 
% oxygenated (SignalMatrixO) and deoxygenated (SignalMatrixD) hemoglobin signals.
%
% Usage:
% SignalComponent = MOxyDeoxy2Components(SignalMatrixO, SignalMatrixD, component)
%
% Inputs:
% - SignalMatrixO: Matrix of oxygenated hemoglobin signals
% - SignalMatrixD: Matrix of deoxygenated hemoglobin signals
% - component: String specifying the desired component:
%   * 'tot' - Computes the total hemoglobin concentration (HbT = HbO + HbD)
%   * 'exc' - Computes the excess deoxygenation (HbD - HbO)
%   * 'sat' - Estimates oxygen saturation deviation (requires tissue-specific factor)
%
% Output:
% - SignalComponent: Computed signal based on the selected component

function SignalComponent = MOxyDeoxy2Components(SignalMatrixO, SignalMatrixD, component)

switch component
    case 'tot'
        % Compute total hemoglobin concentration (HbT)
        SignalComponent = SignalMatrixO + SignalMatrixD;

    case 'exc'
        % Compute excess deoxygenation (HbD - HbO)
        SignalComponent = SignalMatrixD - SignalMatrixO;

    case 'sat'
        % Define O2 saturation factor (85 for breast tissue, 70 for brain)
        pct_sat = 85; % Adjust this value based on the tissue type
        
        % Compute oxygen saturation deviation
        % Note: T1lb_tot is undefined in this function, which may cause an error
        SignalComponent = (SignalMatrixO + 6e-7 * pct_sat) ./ (SignalMatrixO + SignalMatrixD + 6e-5) * 100 - pct_sat;

    otherwise
        % Error message if an invalid component is provided
        error('Component should be "sat", "exc", or "tot"')
end

