%  -------------------------------------------------------------------
% |                             CODE #4                               |
% | SUMMARY:                                                          |
% | Verify if each row in limx is actually a true equilibrium point,  |
% | by substituting the [x1_lim x2_lim ... x15_lim x16_lim u1_lim]    |
% | coordinate values back into original rate equations and seeing if |
% | they evaluate close to 0.                                         |
% |                                                                   |
% | Inputs:                                                           |
% | EquilibriaCoords.mat                                              |
% |                                                                   |
% | Outputs:                                                          |
% | EquilibriaTest.txt                                                |
%  -------------------------------------------------------------------

% ------------------ This part adapted from LinearODES.m ------------------

% Concentration symbols
syms u1 % EGF
R = sym('x1');
R_star = sym('x2');
Ras = sym('x3');
Ras_star = sym('x4');
Raf = sym('x5');
Raf_star = sym('x6');
MEK = sym('x7');
MEK_star = sym('x8');
ERK = sym('x9');
ERK_star = sym('x10');
NFB = sym('x11');
NFB_star = sym('x12');
PFB = sym('x13');
PFB_star = sym('x14');
dusp = sym('x15');
DUSP = sym('x16');

% Concentration symbols vector
concsym = [R R_star Ras Ras_star Raf Raf_star MEK MEK_star ERK ERK_star NFB NFB_star PFB PFB_star dusp DUSP u1];

% Constant symbols and values
syms k1R kd1R PtaseR 
r1syms = [k1R kd1R PtaseR]; 
r1vals = [0.5/60 , 0.5/60 , 1];
syms k2 K2 kd2 D2 
r2syms = [k2 K2 kd2 D2];
r2vals = [2/60 , 1 , 0.25/60 , 0.1];
syms k3F K3 K3R kd3 D3 PtaseNFB 
r3asyms = [k3F K3 K3R kd3 D3 PtaseNFB];
r3avals = [0.0286/60 , 0.01 , 0.85 , 0.0057/60 , 0.5 , 1];
syms k4 K4 kd4 D4 PtaseMEK
r4syms = [k4 K4 kd4 D4 PtaseMEK];
r4vals = [2/60 , 1 , 0.5/60 , 1 , 1];
syms k5 K5 kd5 D5 KNFB PtaseRaf 
r5syms = [k5 K5 kd5 D5 KNFB PtaseRaf];
r5vals = [10/60 , 1 , 3.75/60 , 1 , 0.05 , 1];
syms kPFB KPFB 
r5asyms = [kPFB KPFB];
r5avals = [0/60 , 0.01];
syms k6R K6 kd6 D6 GAP 
r6syms = [k6R K6 kd6 D6 GAP];
r6vals = [40/60 , 1 , 7.5/60 , 1 , 1];
syms k7 K7 kd7 D7 PtasePFB 
r7asyms = [k7 K7 kd7 D7 PtasePFB];
r7avals = [0.1/60 , 0.1 , 0.005/60 , 0.1 , 1];
syms duspbasal duspind Kdusp 
r8syms = [duspbasal duspind Kdusp];
r8vals = [1 , 6 , 0.1];
syms Tdusp 
r8_9syms = [Tdusp];
r8_9vals = [90*60];
syms TDUSP 
r10_11syms = [TDUSP];
r10_11vals = [90*60];

% Constant symbols and values vector
constsyms = [r1syms, r2syms, r3asyms, r4syms, r5syms, r5asyms, r6syms, r7asyms, r8syms, r8_9syms, r10_11syms];
constvals = [r1vals, r2vals, r3avals, r4vals, r5vals, r5avals, r6vals, r7avals, r8vals, r8_9vals, r10_11vals];

% Rate equations
v1 = k1R * R * u1 - kd1R * PtaseR * R_star;
v6 = k6R * R_star * Ras/(K6+Ras) - kd6 * GAP * Ras_star/(D6+Ras_star);
v5 = k5 * Ras_star * Raf/(K5+Raf) * KNFB^2/(KNFB^2+NFB_star^2) - kd5 * PtaseRaf * Raf_star/(D5+Raf_star);
v5a = kPFB * PFB_star * Raf/(KPFB+Raf);
v4 = k4 * Raf_star * MEK/(K4+MEK) - kd4 * PtaseMEK * MEK_star/(D4+MEK);
v2 = k2 * MEK_star * ERK/(K2+ERK) - kd2 * DUSP * ERK_star/(D2+ERK_star);
v3a = k3F * ERK_star * NFB/(K3+NFB) * R_star^2/(K3R^2+R_star^2) - kd3 * PtaseNFB * NFB_star/(D3+NFB_star);
v7a = k7 * ERK_star * R_star * PFB/(K7+PFB) - kd7 * PtasePFB * PFB_star/(D7+PFB_star);
v8 = duspbasal * ( 1 + duspind * ERK_star^2/(Kdusp+ERK_star^2) ) * log(2)/Tdusp;
v9 = dusp * log(2)/Tdusp;
v10 = dusp * log(2)/TDUSP;
v11 = DUSP * log(2)/TDUSP;
F1 = -v1; % dx1/dt
F2 = +v1; % dx2/dt
F3 = -v6; % dx3/dt
F4 = +v6; % dx4/dt
F5 = -v5 - v5a; % dx5/dt
F6 = +v5 + v5a; % dx6/dt
F7 = -v4; % dx7/dt
F8 = +v4; % dx8/dt
F9 = -v2; % dx9/dt
F10 = +v2; % dx10/dt
F11 = -v3a; % dx11/dt
F12 = +v3a; % dx12/dt
F13 = -v7a; % dx13/dt
F14 = +v7a; % dx14/dt
F15 = +v8 - v9; % dx15/dt
F16 = +v10 - v11; % dx16/dt

% -------------------------- Main part of code ----------------------------

% Rate equation vector
F = [F1; F2; F3; F4; F5; F6; F7; F8; F9; F10; F11; F12; F13; F14; F15; F16];

% Sub in constants
F_sub1 = subs(F, constsyms, constvals);

% Load matrix of candidate equilibria coordinates
load('../data/EquilibriaCoords.mat')

% Name file to write to
fileID = fopen('../data/EquilibriaTest.txt','w');

% Get matrix dimensions
[R,C] = size(limx);
% Loop over rows
for ind = 1:R
    % Get respective row
    row = limx(ind,:);
    % Print prompt
    fprintf(fileID, "CASE %g: \n\n",ind);
    fprintf(fileID, "When constant EGF input u = %g (unitless) \n\n", row(end)); 
    fprintf(fileID, "Our candidate equilibrium coordinate is [x_1e x_2e ... x_15e x_16e u_1e] = [%g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g]", row);
    fprintf(fileID, "\n\nSubstituting these coordinate values into the original ODEs gives:\n\n");
    % Sub in equilibria coordinates
    F_sub2 = subs(F_sub1,concsym,row);
    %Print results
    fprintf(fileID,'%f\n',F_sub2);
    % Print new line
    fprintf(fileID,"\n____________________________________________\n\n");
end