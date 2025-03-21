%  ------------------------------------------------------------------
% |                            CODE #1                               |
% | SUMMARY:                                                         |
% | DEFINES DYNAMICAL EQUATIONS FOR ERK PATHWAY, TO BE SOLVED LATER. |
%  ------------------------------------------------------------------

function dxdt = ERKDynamEqu(t, x, u1, k1R, kd1R, PtaseR, k2, K2, kd2, D2, ...
    k3F, K3, K3R, kd3, D3, PtaseNFB, k4, K4, kd4, D4, PtaseMEK, k5, K5, ...
    kd5, D5, KNFB, PtaseRaf, kPFB, KPFB, k6R, K6, kd6, D6, GAP, k7, K7, ...
    kd7, D7, PtasePFB, duspbasal, duspind, Kdusp, Tdusp, TDUSP)

dxdt = zeros(16,1);

% Define reaction speeds
v1 = k1R * x(1) * u1 - kd1R * PtaseR * x(2);
v6 = k6R * x(2) * x(3)/(K6+x(3)) - kd6 * GAP * x(4)/(D6+x(4));
v5 = k5 * x(4) * x(5)/(K5+x(5)) * KNFB^2/(KNFB^2+x(12)^2) - kd5 * PtaseRaf * x(6)/(D5+x(6));
v5a = kPFB * x(14) * x(5)/(KPFB+x(5));
v4 = k4 * x(6) * x(7)/(K4+x(7)) - kd4 * PtaseMEK * x(8)/(D4+x(7));
v2 = k2 * x(8) * x(9)/(K2+x(9)) - kd2 * x(16) * x(10)/(D2+x(10));
v3a = k3F * x(10) * x(11)/(K3+x(11)) * x(2)^2/(K3R^2+x(2)^2) - kd3 * PtaseNFB * x(12)/(D3+x(12));
v7a = k7 * x(10) * x(2) * x(13)/(K7+x(13)) - kd7 * PtasePFB * x(14)/(D7+x(14));
v8 = duspbasal * ( 1 + duspind * x(10)^2/(Kdusp+x(10)^2) ) * log(2)/Tdusp;
v9 = x(15) * log(2)/Tdusp;
v10 = x(15) * log(2)/TDUSP;
v11 = x(16) * log(2)/TDUSP;

% Define ODEs
dxdt(1) = -v1; % dx1/dt
dxdt(2) = +v1; % dx2/dt
dxdt(3) = -v6; % dx3/dt
dxdt(4) = +v6; % dx4/dt
dxdt(5) = -v5 - v5a; % dx5/dt
dxdt(6) = +v5 + v5a; % dx6/dt
dxdt(7) = -v4; % dx7/dt
dxdt(8) = +v4; % dx8/dt
dxdt(9) = -v2; % dx9/dt
dxdt(10)= +v2; % dx10/dt
dxdt(11)= -v3a; % dx11/dt
dxdt(12)= +v3a; % dx12/dt
dxdt(13)= -v7a; % dx13/dt
dxdt(14)= +v7a; % dx14/dt
dxdt(15)= +v8 - v9; % dx15/dt
dxdt(16)= +v10 - v11; % dx16/dt