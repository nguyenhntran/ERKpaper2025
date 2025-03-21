%  -----------------------------------------------------------------------------------
% | PART 2: FROM STATE SPACE REPRESENTATION AT ARBITRARY EQUILIBRIUM (FULLY SYMBOLIC) |
% |                                         TO                                        |
% |           STATE SPACE REPRESENTATION AT ARBITRARY EQUILIBRIUM (PARTLY SYMBOLIC)   |
%  -----------------------------------------------------------------------------------


%--------------------------------PRELIM------------------------------------


% LOAD DATA
load('../../../General_TransFunc/data/ConstantSymbols.mat')
load('../../../General_TransFunc/data/A_fullsym.mat');
load('../../../General_TransFunc/data/B_fullsym.mat');
load('../../../General_TransFunc/data/C_fullsym.mat');
load('../../../General_TransFunc/data/D_fullsym.mat');

% GROUP CONSTANT SYMBOLS AND VALUES

r1syms = [k1R kd1R PtaseR]; 
r1vals = [0.5/60 , 0.5/60 , 1];

r2syms = [k2 K2 kd2 D2];
r2vals = [2/60 , 1 , 0.25/60 , 0.1];

r3asyms = [k3F K3 K3R kd3 D3 PtaseNFB];
r3avals = [0.0286/60 , 0.01 , 0.85 , 0.0057/60 , 0.5 , 1];

r4syms = [k4 K4 kd4 D4 PtaseMEK];
r4vals = [2/60 , 1 , 0.5/60 , 1 , 1];

r5syms = [k5 K5 kd5 D5 KNFB PtaseRaf];
r5vals = [10/60 , 1 , 3.75/60 , 1 , 0.05 , 1];

r5asyms = [kPFB KPFB];
r5avals = [0/60 , 0.01];

r6syms = [k6R K6 kd6 D6 GAP];
r6vals = [40/60 , 1 , 7.5/60 , 1 , 1];

r7asyms = [k7 K7 kd7 D7 PtasePFB];
r7avals = [0.1/60 , 0.1 , 0.005/60 , 0.1 , 1];

r8syms = [duspbasal duspind Kdusp];
r8vals = [1 , 6 , 0.1];

r8_9syms = [Tdusp];
r8_9vals = [90*60];

r10_11syms = [TDUSP];
r10_11vals = [90*60];

% FURTHER GROUP CONSTANT SYMBOLS AND VALUES INTO VECTORS FOR SUBSTITUTION
constsyms = [r1syms, r2syms, r3asyms, r4syms, r5syms, r5asyms, r6syms, r7asyms, r8syms, r8_9syms, r10_11syms];
constvals = [r1vals, r2vals, r3avals, r4vals, r5vals, r5avals, r6vals, r7avals, r8vals, r8_9vals, r10_11vals];


%---------------------------------MAIN-------------------------------------


% JACOBIAN MATRICES: NUMERIC CONSTANTS & SYMBOLIC EQUILIBRIUM COORDS

A_sub1 = subs(A, constsyms, constvals);
B_sub1 = subs(B, constsyms, constvals);
C_sub1 = subs(C, constsyms, constvals);
D_sub1 = subs(D, constsyms, constvals);


%---------------------------------SAVE-------------------------------------

save('../data/A_partsym','A_sub1');
save('../data/B_partsym','B_sub1');
save('../data/C_partsym','C_sub1');
save('../data/D_partsym','D_sub1');
