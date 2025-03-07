%% Load oxy and deoxy components and compute another 3 components
oxy=load(['left-breast-tumor_subject01_left-breast_oxyHb.dat']);
deoxy=load(['left-breast-tumor_subject01_left-breast_deoxyHb.dat']);
sat = MOxyDeoxy2Components(oxy,deoxy,'sat'); % Saturation Signal Matrix
tot = MOxyDeoxy2Components(oxy,deoxy,'tot'); % Total Hb Signal Matrix
exc = MOxyDeoxy2Components(oxy,deoxy,'exc'); % Exchange Signal Matrix
%% Tranform oxy and deoxy to State Matrix
StateMatrix = Msignal2states(oxy,deoxy);
%% Compute Transition probabilities
TrProbMatrix = MTransitionProbs(StateMatrix);
%% Compute the pre/post transition mean and flux for every component
[pre.oxy, post.oxy, flux.oxy] = MPrePostFlux(StateMatrix, oxy);
[pre.deoxy, post.deoxy, flux.deoxy] = MPrePostFlux(StateMatrix, deoxy);
[pre.sat, post.sat, flux.sat] = MPrePostFlux(StateMatrix, sat);
[pre.tot, post.tot, flux.tot] = MPrePostFlux(StateMatrix, tot);
[pre.exc, post.exc, flux.exc] = MPrePostFlux(StateMatrix, exc);
%% Compute the Gibbs Free Energy (GFE)
GFE.oxy = MGibbsFreeEnergy(oxy, deoxy, 'oxy');
GFE.deoxy = MGibbsFreeEnergy(oxy, deoxy, 'deoxy');
GFE.sat = MGibbsFreeEnergy(oxy, deoxy, 'sat');
GFE.tot = MGibbsFreeEnergy(oxy, deoxy, 'tot');
GFE.exc = MGibbsFreeEnergy(oxy, deoxy, 'exc');
%% Compute the Gradients
gGFE.oxy = MGradients(GFE.oxy);
gGFE.deoxy = MGradients(GFE.deoxy);
gGFE.sat = MGradients(GFE.sat);
gGFE.tot = MGradients(GFE.tot);
gGFE.exc = MGradients(GFE.exc);
