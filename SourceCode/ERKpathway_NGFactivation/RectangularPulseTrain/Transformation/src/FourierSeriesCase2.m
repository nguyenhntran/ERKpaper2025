%  ---------------------------------------------------------------------
% | SUMMARY:                                                            |  %(Lines may need to edit for each case):
% | PLOTS PERTZ2015 PULSE TRAIN INPUT.                                  |
% | PLOTS FOURIER SERIES OF THIS PULSE TRAIN INPUT.                     |
% | PLOTS OUTPUT AFTER INPUT HAS BEEN TRANSFORMED BY TRANSFER FUNCTION. |
% | RECORDS STATS OF INTEREST FOR OUTPUT.                               |
% |                                                                     |
% | Inputs:                                                             |
% | TF_Case2.mat                                                        |  %<--- filename
% |                                                                     |
% | Outputs:                                                            |
% | Transformation_Case2.pdf                                            |  %<--- filename
% | OutputStats_Case2.txt                                               |  %<--- filename
%  ---------------------------------------------------------------------


%--------------------------------PRELIM------------------------------------


% Create figure for plotting
h1 = figure('Visible','off');
set(h1,'units','centimeters','position',[0,0,20,10])
tl = tiledlayout(2,1);
title(tl,'Input-output transformation: High amplitude pulses at frequency $8.055\times10^{-3}$ (rad/s)', 'Interpreter','latex') %<--- title case number
xlabel(tl,'Time (s)', 'Interpreter','latex')
ylabel(tl,'Concentration (unitless)', 'Interpreter','latex')


%----------------------SECTION 1: PLOTTING INPUT---------------------------


% Define symbols
syms A tau T t n

% Define function for general rectangular pulse train
pulses = 50;                                                               %<--- number of pulses we want in the pulse train (don't really need to change if looks good enough)
nthpulse  (A,tau,T,t,n) = A * ( heaviside(t - n*T) - heaviside(t - (n*T + tau)) );
pulsetrain(A,tau,T,t  ) = symsum(nthpulse(A,tau,T,t,n), n, 0, pulses);

% Define function for fourier series of general pulse train
terms = 200;                                                               %<--- number of terms we want in the fourier series (don't really need to change if looks good enough)
a_0      (A,tau,T    ) = A*tau/T;
a_n      (A,tau,T,  n) = A/pi/n * sin(2*pi*n*tau/T);
b_n      (A,tau,T,  n) = A/pi/n * (1 - cos(2*pi*n*tau/T));
costerm  (      T,t,n) = a_n * cos(2*pi*n*t/T);
sinterm  (      T,t,n) = b_n * sin(2*pi*n*t/T);
expansion(A,tau,T,t  ) = a_0 + symsum(costerm(T,t,n), n, 1, terms) + symsum(sinterm(T,t,n), n, 1, terms);

%----------------------

% Define pulse train parameters
amplitude = 50/26; %unitless concentration                                 %<--- pulse amplitude
pulseduration = 3*60; %seconds
pauseduration = 10*60; %seconds                                             %<--- pulse pause duration
periodduration = pulseduration + pauseduration; %seconds

% Plot pulse train
nexttile
fplot(pulsetrain(amplitude,pulseduration,periodduration,t),[0,150*60])
hold on

% Plot fourier series approximation of pulse train on top
fplot(expansion(amplitude,pulseduration,periodduration,t),[0,150*60])
title('NGF input', 'Interpreter','latex')
grid on
hold off


%---------------------SECTION 2: PLOTTING OUTPUT---------------------------


% OBTAIN DATA FOR INPUT TO OUTPUT TRANSFORMATION

% get angular frequencies (rad/s) of interest
angfreq(n) = 2*pi*n/periodduration;
angfreqs = [];
for index1 = 1:terms
    dummy1 = angfreq(index1);
    angfreqs = [angfreqs ; dummy1];
end
angfreqs = double(angfreqs);

% get Bode mag and phase data at those frequencies
load('../../TransferFunction/data/TransFuncCase2_ClassTf.mat')             %<--- filename
[mag, phase, wout] = bode(TF,angfreqs);
magdata = squeeze(mag(1,1,:)); %units: abs
phasedata = squeeze(phase(1,1,:)); %units: degrees
phadata = phasedata * pi / 180; %convert to radians

%----------------------

% COSINE TERMS TRANSFORMATIONS

%             our angular frequencies of interest angfreq(n)
%               |                                      |
% ----          |                    ----              |
% \             V             T      \                 V
% /     a_n cos(w_n * t)  -------->  /     M_n * a_n cos(w_n * t + phi_n)
% ----                               ----  ^                       ^
%                                          |                       |
%                                          |                       |
%                                       magdata                 phadata

% get original amplitude at those angular frequencies (ie. get a_n values)
a_nterms = [];
for index2 = 1:terms
    dummy2 = a_n(amplitude,pulseduration,periodduration,index2);
    a_nterms = [a_nterms ; dummy2];
end

% obtain new cosine terms after transformation
newcosterms = magdata .* a_nterms .* cos(angfreqs * t + phadata);

%sum cosine terms
newcosterms_sum = sum(newcosterms);

%----------------------

% SINE TERMS TRANSFORMATIONS

%             our angular frequencies of interest angfreq(n)
%               |                                      |
% ----          |                    ----              |
% \             V             T      \                 V
% /     b_n sin(w_n * t)  -------->  /     M_n * b_n sin(w_n * t + phi_n)
% ----                               ----  ^                       ^
%                                          |                       |
%                                          |                       |
%                                       magdata                 phadata

% get original amplitude at those angular frequencies (ie. get b_n values)
b_nterms = [];
for index3 = 1:terms
    dummy3 = b_n(amplitude,pulseduration,periodduration,index3);
    b_nterms = [b_nterms ; dummy3];
end

% obtain new sine terms after transformation
newsinterms = magdata .* b_nterms .* sin(angfreqs * t + phadata);

%sum sine terms
newsinterms_sum = sum(newsinterms);

%----------------------

% TRANSFORMED FOURIER SERIES

% Define output
ERKstar_equilibrium = 0.243566674413168;                                   %<--- equilibrium output obtained from timecourse similation of nonlinear model
newexpansion(t) = ERKstar_equilibrium + newcosterms_sum + newsinterms_sum;

% Save output function
save('../data/OutputFourierExpansion_Case2.mat','newexpansion')            %<--- filename

% Plot output
nexttile
fplot(newexpansion,[0,150*60])
ylim('auto')                                                               %<--- y axis limits
title('ERK* output', 'Interpreter','latex')
grid on

%----------------------

% EXPORT PLOT

exportgraphics(h1,'../plots/Transformation_Case2.pdf','BackgroundColor','none'); %<--- filename
close(h1);


%---------------------------GET OUTPUT STATS-------------------------------
% % 
% % 
% % % Pertz2015 Fig6B mentions integrated ERK activity being correlated with cell fate determination
% % % and presents plots for the 60' after first 90' of GF stimulation (ie. from 90mins to 150mins).
% % % Let us record the area under our ERK* curves between t=90mins to t=150mins.
% % 
% % % Calculate area from t=90 mins to t=150 mins 
% % Area_90_150 = int(newexpansion, 90*60, 150*60);
% % 
% % % Calculate average concentration from t=90 mins to t=150 mins 
% % AvgConc_90_150 = Area_90_150 / (60*60);
% % 
% % % Name text file to write into
% % fileID = fopen('../data/OutputStats_Case2.txt','w');                       %<--- case number
% % 
% % % Print stats
% % fprintf(fileID, "CASE 2 ERK* OUTPUT: \n\n");                               %<--- case number
% % fprintf(fileID, "Total area under curve from 90 mins to 150 mins = %g (units: (unitless concentration)*(s)) \n", Area_90_150);
% % fprintf(fileID, "Average concentration from 90 mins to 150 mins = = %g (units: unitless concentration) \n\n", AvgConc_90_150);
% % fprintf(fileID, "Equilibrium ERK* concentration from timecourse simulation (ie. DC output term) = %g (units: unitless concentration)",ERKstar_equilibrium);
% % 
% % % Close text file
% % fclose(fileID);