%  -----------------------------------------------------------------------
% | PART 1:                   FROM ODES                                   |
% |                              TO                                       |
% |  STATE SPACE REPRESENTATION AT ARBITRARY EQUILIBRIUM (FULLY SYMBOLIC) |
%  -----------------------------------------------------------------------


%--------------------------------PRELIM------------------------------------


% DEFINE CONSTANTS SYMBOLS
% reaction 1
syms k1R kd1R PtaseR 
% reaction 2
syms k2 K2 kd2 D2 
% reaction 3a
syms k3F K3 K3R kd3 D3 PtaseNFB 
% reaction 4
syms k4 K4 kd4 D4 PtaseMEK
% reaction 5
syms k5 K5 kd5 D5 KNFB PtaseRaf 
% reaction 5a
syms kPFB KPFB 
% reaction 6
syms k6R K6 kd6 D6 GAP 
% reaction 7a
syms k7 K7 kd7 D7 PtasePFB 
% reaction 8
syms duspbasal duspind Kdusp 
% reaction 8 and 9
syms Tdusp 
% reaction 10 and 11
syms TDUSP 

% SAVE CONSTANTS SYMBOLS
save('../data/ConstantSymbols')

% DEFINE PATHWAY INPUTS
syms u1 

% DEFINE PATHWAY SPECIES
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

% DEFINE REACTION SPEEDS
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

% DEFINE PATHWAY CONCENTRATION KINETICS
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

% DEFINE PATHWAY OUTPUTS
G1 = ERK_star;

% DEFINE ASSOCIATED MATRICES
x = [R; R_star; Ras; Ras_star; Raf; Raf_star; MEK; MEK_star; ERK; ERK_star; NFB; NFB_star; PFB; PFB_star; dusp; DUSP]; % matrix of pathway concentrations
u = [u1]; % matrix of pathway inputs
F = [F1; F2; F3; F4; F5; F6; F7; F8; F9; F10; F11; F12; F13; F14; F15; F16]; % matrix of pathway concentration kinetics
G = [G1]; % matrix of pathway outputs


%---------------------------------MAIN-------------------------------------


% JACOBIAN MATRICES: Symbolic Constants & Symbolic equilibrium coords

% Take Jacobian of vectors F and G wrt vectors x and u
A = jacobian(F,x); % system matrix
B = jacobian(F,u); % input matrix
C = jacobian(G,x); % observation matrix
D = jacobian(G,u); % output matrix

% Define symbols for equilibrium coordinate (x,u) = (x_e,u_e)
syms x_1e x_2e x_3e x_4e x_5e x_6e x_7e x_8e x_9e x_10e x_11e x_12e x_13e x_14e x_15e x_16e u_1e
equilibrium = [x_1e x_2e x_3e x_4e x_5e x_6e x_7e x_8e x_9e x_10e x_11e x_12e x_13e x_14e x_15e x_16e u_1e];

% Replace (x,u) coordinate symbols for (x_e,u_e) coordinate symbols
A = subs(A , [transpose(x),transpose(u)] , equilibrium); % system matrix
B = subs(B , [transpose(x),transpose(u)] , equilibrium); % input matrix
C = subs(C , [transpose(x),transpose(u)] , equilibrium); % observation matrix
D = subs(D , [transpose(x),transpose(u)] , equilibrium); % output matrix

%  -----------------------------------------------------------
% | These matrices form the linear state space representation |
% | of our system. That is:                                   |
% | A_ij = del(F_i)/del(x_j)|(x=x_e,u=u_e)                    |
% | B_ij = del(F_i)/del(u_j)|(x=x_e,u=u_e)                    |
% | C_ij = del(G_i)/del(x_j)|(x=x_e,u=u_e)                    |
% | D_ij = del(G_i)/del(u_j)|(x=x_e,u=u_e)                    |
%  -----------------------------------------------------------


%----------------------------------SAVE------------------------------------

save('../data/A_fullsym','A');
save('../data/B_fullsym','B');
save('../data/C_fullsym','C');
save('../data/D_fullsym','D');

% NOTE: WE DO NOT ATTEMPT TO COMPUTE THE ALGEBRAIC TRANSFER FUNCTION 
%       H = C * (sI-A)^-1 * B + D HERE, BECAUSE IT TAKES TOO LONG.
%       WE DO, HOWEVER, DO THIS FOR THE AKT PATHWAY (IN PART1.M) BECAUSE 
%       ITS MODEL IS RELATIVELY SIMPLER AND, SO, RUN TIME FOR 
%       H = C * (sI-A)^-1 * B + D IS FASTER.