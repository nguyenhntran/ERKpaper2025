% Load your transfer functions
load('TransFuncCase2_ClassTf.mat');
TFcase2 = TF;  % High mean [EGF]
load('TransFuncCase7_ClassTf.mat');
TFcase7 = TF;  % Low mean [EGF]

minw = 10E-6;
maxw = 10E+1;
w = linspace(minw, maxw, maxw/minw);  % Corrected to have appropriate number of points

% Get the Bode data for both transfer functions
[mag1, phase1] = bode(TFcase2, w);  % mag1 and phase1 for TFcase2
[mag2, phase2] = bode(TFcase7, w);  % mag2 and phase2 for TFcase7

% Squeeze the data to convert them into 1D vectors
mag1 = squeeze(mag1(1,1,:));  % Magnitude for TFcase2
phase1 = squeeze(phase1(1,1,:));  % Phase for TFcase2
mag2 = squeeze(mag2(1,1,:));  % Magnitude for TFcase7
phase2 = squeeze(phase2(1,1,:));  % Phase for TFcase7

% --- Magnitude Plot ---
figure;

subplot(2, 1, 1);  % Top panel for magnitude

yyaxis left;  % Left y-axis for TFcase7
semilogx(w, mag2, 'LineWidth', 1.5);  % No DisplayName here
ylabel('Magnitude (abs)', 'FontSize', 11, 'Interpreter', 'latex');
hold on;

yyaxis right;  % Right y-axis for TFcase2
semilogx(w, mag1, 'LineWidth', 1.5);  % No DisplayName here
ylabel('Magnitude (abs)', 'FontSize', 11, 'Interpreter', 'latex');

title('Bode Magnitude Plot', 'FontSize', 11, 'Interpreter', 'latex');
xlabel('Frequency (rad/s)', 'FontSize', 11, 'Interpreter', 'latex');  % Add x-axis label
grid on;

% Add legend with specific labels
% legend({'Mean [EGF] = 0.0108696' , 'Mean [EGF] = 0.480769'}, 'Location', 'best');
legend({'Low occupancy' , 'Moderate occupancy'}, 'Location', 'northeast');

% --- Phase Plot ---
subplot(2, 1, 2);  % Bottom panel for phase

semilogx(w, phase2, 'LineWidth', 1.5);  % No DisplayName here
hold on;

semilogx(w, phase1, 'LineWidth', 1.5);  % No DisplayName here

ylabel('Phase (deg)', 'FontSize', 11, 'Interpreter', 'latex');

xlabel('Frequency (rad/s)', 'FontSize', 11, 'Interpreter', 'latex');  % Add x-axis label for phase plot
title('Bode Phase Plot', 'FontSize', 11, 'Interpreter', 'latex');
grid on;

% y axis customisation

% Define y-axis tick positions at π/2 intervals
yticks(-450:90:180);
% Define corresponding tick labels in LaTeX notation
yticklabels({'$-450$', '$-360$', '$-270$', '$-180$', '$-90$', '$0$', '$90$', '$180$'});
% Enable LaTeX interpreter for tick labels
set(gca, 'TickLabelInterpreter', 'latex');
ylim([-460,190])

% Add legend with specific labels
% legend({'Mean [EGF] = 0.0108696' , 'Mean [EGF] = 0.480769'}, 'Location', 'best');
legend({'Low occupancy' , 'Moderate occupancy'}, 'Location', 'northeast');

% Overall figure title
sgtitle('Bode Plots of Low and Moderate EGFR Occupancies', 'FontSize', 12, 'Interpreter', 'latex');