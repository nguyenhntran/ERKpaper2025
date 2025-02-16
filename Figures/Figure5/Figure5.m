% SUMMARY:
% PLOTS ERK* OUTPUTS DUE TO RECTANGULAR EGF PULSING


% ---------------------------- Load functions ----------------------------

% ERK* due to rectangular low EGF pulsing at 3mins on 20 mins off
load('OutputFourierExpansion_Case7.mat')
case7 = newexpansion;
% ERK* due to rectangular low EGF pulsing at 3mins on 10 mins off
load('OutputFourierExpansion_Case6.mat')
case6 = newexpansion;
% ERK* due to rectangular low EGF pulsing at 3mins on 3 mins off
load('OutputFourierExpansion_Case5.mat')
case5 = newexpansion;


% ---------------------------- Create figure ----------------------------

h = figure();
tl = tiledlayout(3, 1, 'TileSpacing', 'compact', 'Padding', 'none'); 
title(tl, 'Simulated ERK* Output Kinetics for Periodic Rectangular EGF Input Pulses of 0.08 Kd', 'Interpreter', 'latex')
xlabel(tl, 'Time (s)', 'Interpreter', 'latex')
ylabel(tl, 'Concentration (dimensionless)', 'Interpreter', 'latex')

% ----------------------------

% Time axis
t_i = 0;
t_f = 3600;

% Define pulse train sizes
amplitude = 1; % Extra tall to fill vertical height of plot
pulseduration = 3*60; % seconds

% Colors for legend
colors = lines(3); 

% ---------------------------- First subplot ----------------------------

ax1 = nexttile;
hold on;
f1 = fplot(case7, [t_i, t_f], 'Color', colors(1,:), 'LineWidth', 1.5);
ylim([-0.03 0.3]);
yline(0.0698,'--k','mean = 0.07', 'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'top')
yline(0.26,'--k','max = 0.26', 'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'bottom')
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
f2 = fplot(case6, [t_i, t_f], 'Color', colors(2,:), 'LineWidth', 1.5);
ylim([-0.03 0.3]);
yline(0.1068,'--k','mean = 0.11', 'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'bottom')
yline(0.23,'--k','max = 0.23', 'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'top')
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
f3 = fplot(case5, [t_i, t_f], 'Color', colors(3,:), 'LineWidth', 1.5);
ylim([-0.03 0.3]);
yline(0.1637,'--k','mean = 0.16', 'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'bottom')
yline(0.2,'--k','max = 0.2', 'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'top')
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