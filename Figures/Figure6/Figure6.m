% SUMMARY:
% PLOTS ERK* OUTPUTS DUE TO RECTANGULAR EGF PULSING


% ---------------------------- Load functions ----------------------------

% ERK* due to rectangular low EGF pulsing at 3mins on 20 mins off
load('OutputFourierExpansion_Case3.mat')
case3 = newexpansion;
% ERK* due to rectangular low EGF pulsing at 3mins on 10 mins off
load('OutputFourierExpansion_Case2.mat')
case2 = newexpansion;
% ERK* due to rectangular low EGF pulsing at 3mins on 3 mins off
load('OutputFourierExpansion_Case1.mat')
case1 = newexpansion;


% ---------------------------- Create figure ----------------------------

h = figure();
tl = tiledlayout(3, 1, 'TileSpacing', 'compact', 'Padding', 'none'); 
title(tl, 'Simulated ERK* Output Kinetics for Periodic Rectangular EGF Input Pulses of 2.1 Kd', 'Interpreter', 'latex')
xlabel(tl, 'Time (s)', 'Interpreter', 'latex')
ylabel(tl, 'Concentration (dimensionless)', 'Interpreter', 'latex')

% ----------------------------

% Time axis
t_i = 0;
t_f = 3600;

% Define pulse train sizes
amplitude = 1; % Extra tall to fill vertical height of plot
pulseduration = 3*60; % seconds

% Define colors manually
colors = [0 0.447 0.741; % Blue
          0.850 0.325 0.098; % Red-Orange
          0.929 0.694 0.125]; % Yellow

% ---------------------------- First subplot ----------------------------

ax1 = nexttile;
hold on;
f1 = fplot(case3, [t_i, t_f], 'Color', colors(1,:), 'LineWidth', 1.5);
ylim([0 0.55]);
yline(0.240199766152701,'--k','mean = 0.24', 'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'top')
yline(0.515744, '--k', 'max = 0.52', 'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'bottom')
grid on;
grid minor;

% Define pause duration
pauseduration = 20*60; % seconds
periodduration = pulseduration + pauseduration; % seconds
num_pulses = floor(t_f/periodduration); % Number of pulses

% Shade the pulse train regions
for n = 0:num_pulses
    start_t = n * periodduration;
    end_t = start_t + pulseduration;
    fill([start_t end_t end_t start_t], [-amplitude -amplitude amplitude amplitude], ...
        [0.7, 0.7, 0.7], 'FaceAlpha', 0.5, 'EdgeColor', 'none');
end

set(gca, 'XTickLabel', []); % Hide x-axis labels

% ---------------------------- Second subplot ----------------------------

ax2 = nexttile;
hold on;
f2 = fplot(case2, [t_i, t_f], 'Color', colors(2,:), 'LineWidth', 1.5);
ylim([0 0.55]);
yline(0.209511208901993,'--k','mean = 0.21', 'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'bottom')
yline(0.302596, '--k', 'max = 0.30', 'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'top')
grid on;
grid minor;

% Define pause duration
pauseduration = 10*60; % seconds
periodduration = pulseduration + pauseduration; % seconds
num_pulses = floor(t_f/periodduration); % Number of pulses

% Shade the pulse train regions
for n = 0:num_pulses
    start_t = n * periodduration;
    end_t = start_t + pulseduration;
    fill([start_t end_t end_t start_t], [-amplitude -amplitude amplitude amplitude], ...
        [0.7, 0.7, 0.7], 'FaceAlpha', 0.5, 'EdgeColor', 'none');
end

set(gca, 'XTickLabel', []); % Hide x-axis labels

% ---------------------------- Third subplot ----------------------------

ax3 = nexttile;
hold on;
f3 = fplot(case1, [t_i t_f], 'Color', colors(3,:), 'LineWidth', 1.5);
ylim([0.150 0.165]) 
yline(0.157556940592814,'--k','mean = 0.16', 'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'bottom')
yline(0.164083, '--k', 'max = 0.16', 'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'bottom')
grid on;
grid minor;

% Define pause duration
pauseduration = 3*60; % seconds
periodduration = pulseduration + pauseduration; % seconds
num_pulses = floor(t_f/periodduration); % Number of pulses

% Shade the pulse train regions
for n = 0:num_pulses
    start_t = n * periodduration;
    end_t = start_t + pulseduration;
    fill([start_t end_t end_t start_t], [-amplitude -amplitude amplitude amplitude], ...
        [0.7, 0.7, 0.7], 'FaceAlpha', 0.5, 'EdgeColor', 'none');
end

% ---------------------------- Formatting ----------------------------

% Share x-axis but only show x-ticks on the last subplot
linkaxes([ax1, ax2, ax3], 'x'); 
xlim([t_i t_f]);

% Create legend in the last subplot
legend([f1, f2, f3], {'3 pulses/hr', '5 pulses/hr', '10 pulses/hr'}, ...
    'Location', 'northoutside', 'Interpreter', 'latex', 'Orientation', 'Horizontal');