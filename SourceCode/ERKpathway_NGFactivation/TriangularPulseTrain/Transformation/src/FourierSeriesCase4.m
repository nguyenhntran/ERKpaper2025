%  ---------------------------------------------------------------------
% | SUMMARY:                                                            |  %(Lines may need to edit for each case):
% | NINGSIH USES TRAINGULAR PULSE TRAIN INPUT.                          |
% | PLOTS FOURIER SERIES OF THIS PULSE TRAIN INPUT.                     |
% | PLOTS OUTPUT AFTER INPUT HAS BEEN TRANSFORMED BY TRANSFER FUNCTION. |
% |                                                                     |
% | Inputs:                                                             |
% | TransFuncCase1_ClassTf.mat                                          |  %don't need to change
% |                                                                     |
% | Outputs:                                                            |
% | Transformation_Case4.pdf                                            |  %<--- filename
% | OutputFourierExpansion_Case4.mat                                    |  %<--- filename
%  ---------------------------------------------------------------------


%--------------------------------PRELIM------------------------------------


% Create figure for plotting
h1 = figure('Visible','off');
set(h1,'units','centimeters','position',[0,0,20,10])
tl = tiledlayout(2,1);
title(tl,'Input-output transformation: Triangular pulses at frequency $8.727\times10^{-4}$ (rad/s)', 'Interpreter','latex') %<--- title case number
xlabel(tl,'Time (s)', 'Interpreter','latex')
ylabel(tl,'Concentration (unitless)', 'Interpreter','latex')


%----------------------SECTION 1: PLOTTING INPUT---------------------------


% Define symbols
syms A T t n

% Define function for fourier series of triangular pulse train starting at t=0
terms = 200; %number of terms we want in the fourier series
a_0      (A      ) = A/2;
a_n      (A,    n) = - (4*A) / ( (2*n-1)^2 * pi^2 );
costerm  (  T,t,n) = a_n * cos( (2*n-1) * 2*pi/T * t );
expansion(A,T,t  ) = a_0 + symsum(costerm(T,t,n), n, 1, terms);

%----------------------

% Define pulse train parameters
amplitude = 300/26; %unitless concentration
periodduration = 7200; %seconds                                            %<--- pulse period

% Plot fourier series approximation of pulse train
nexttile
fplot(expansion(amplitude,periodduration,t),[0,120*60])
ylim([-0.1 12])
title('NGF input', 'Interpreter','latex')
grid on


%---------------------SECTION 2: PLOTTING OUTPUT---------------------------


% OBTAIN DATA FOR INPUT TO OUTPUT TRANSFORMATION

% get angular frequencies (rad/s) of interest
angfreq(n) = (2*n-1) * 2*pi/periodduration;
angfreqs = [];
for index1 = 1:terms
    dummy1 = angfreq(index1);
    angfreqs = [angfreqs ; dummy1];
end
angfreqs = double(angfreqs);

% get Bode mag and phase data at those frequencies
load('../../TransferFunction/data/TransFuncCase1_ClassTf.mat') %don't need to change
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
    dummy2 = a_n(amplitude,index2);
    a_nterms = [a_nterms ; dummy2];
end

% obtain new cosine terms after transformation
newcosterms = magdata .* a_nterms .* cos(angfreqs * t + phadata);

%sum cosine terms
newcosterms_sum = sum(newcosterms);

%----------------------

% TRANSFORMED FOURIER SERIES

% Define output
ERKstar_equilibrium = 0.197910721928509; %don't need to change
newexpansion(t) = ERKstar_equilibrium + newcosterms_sum;

% Save output function
save('../data/OutputFourierExpansion_Case4.mat','newexpansion')            %<--- filename

% Plot output
nexttile
fplot(newexpansion,[0,120*60])
ylim([0.196 0.2])                                                          %<--- y axis limits
title('ERK* output', 'Interpreter','latex')
grid on

%----------------------

% EXPORT PLOT

exportgraphics(h1,'../plots/Transformation_Case4.pdf','BackgroundColor','none'); %<--- filename
close(h1);