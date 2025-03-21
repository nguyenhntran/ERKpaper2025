%  ----------------------------------------------------------
% | CODE #2                                                  |
% |                                                          |
% | SUMMARY:                                                 |
% | CREATES .MAT FILES WITH CONSTANTS AND INITIAL CONDITIONS.|
% |                                                          |
% | Inputs:                                                  |
% | None                                                     |
% |                                                          |
% | Outputs:                                                 |
% | 1. Constants.mat                                         |
% | 2. InitConds.mat                                         |
%  ----------------------------------------------------------

% Define constants

[k1R, kd1R, PtaseR] = deal(0.5/60 , 0.5/60 , 1);

[k2, K2, kd2, D2] = deal(2/60 , 1 , 0.25/60 , 0.1);

[k3F, K3, K3R, kd3, D3, PtaseNFB] = deal(0.0286/60 , 0.01 , 0.85 , 0.0057/60 , 0.5 , 1);

[k4, K4, kd4, D4, PtaseMEK] = deal(2/60 , 1 , 0.5/60 , 1 , 1);

[k5, K5, kd5, D5, KNFB, PtaseRaf] = deal(10/60 , 1 , 3.75/60 , 1 , 0.05 , 1);

[kPFB, KPFB] = deal(0.75/60 , 0.01);

[k6R, K6, kd6, D6, GAP] = deal(40/60 , 1 , 7.5/60 , 1 , 1);

[k7, K7, kd7, D7, PtasePFB] = deal(0.1/60 , 0.1 , 0.005/60 , 0.1 , 1);

[duspbasal, duspind, Kdusp] = deal(1 , 6 , 0.1);

Tdusp = 90*60;

TDUSP = 90*60;

% Save constants
save('../data/Constants.mat', ...
    'k1R', 'kd1R', 'PtaseR', 'k2', 'K2', 'kd2', 'D2', ...
    'k3F', 'K3', 'K3R', 'kd3', 'D3', 'PtaseNFB', 'k4', 'K4', 'kd4', 'D4', 'PtaseMEK', 'k5', 'K5', ...
    'kd5', 'D5', 'KNFB', 'PtaseRaf', 'kPFB', 'KPFB', 'k6R', 'K6', 'kd6', 'D6', 'GAP', 'k7', 'K7', ...
    'kd7', 'D7', 'PtasePFB', 'duspbasal', 'duspind', 'Kdusp', 'Tdusp', 'TDUSP')

% -------------------------------------------------------------------------

% Define initial conditions
init = [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1];

% Save initial conditions
save('../data/InitConds.mat', 'init')