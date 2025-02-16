% SUMMARY:
% PLOTS ERK* OUTPUTS DUE TO RECTANGULAR EGF PULSING WITH VARYING DARKNESS


% ---------------------------- Load functions ----------------------------

% ERK* due to triangular EGF pulsing at 0.5 cycles/hour
load('OutputFourierExpansion_Case4.mat')
case4 = newexpansion;
% ERK* due to triangular EGF pulsing at 1 cycle/hour
load('OutputFourierExpansion_Case3.mat')
case3 = newexpansion;
% ERK* due to triangular EGF pulsing at 4 cycles/hour
load('OutputFourierExpansion_Case1.mat')
case1 = newexpansion;


% ---------------------------- Create figure ----------------------------

h = figure();
tl = tiledlayout(3, 1, 'TileSpacing', 'compact', 'Padding', 'compact'); 

title(tl, 'Simulated ERK* Output Kinetics for Periodic Triangular EGF Input Pulses of 4.2 Kd', 'Interpreter', 'latex')
xlabel(tl, 'Time (s)', 'Interpreter', 'latex')
ylabel(tl, 'Concentration (dimensionless)', 'Interpreter', 'latex')

% ----------------------------

% Time axis
t_i = 0;
t_f = 7200;

% Define pulse train sizes
amplitude = 5; % Extra tall to fill vertical height of plot

% Define colors manually
colors = [0 0.447 0.741; % Blue
          0.850 0.325 0.098; % Red-Orange
          0.929 0.694 0.125]; % Yellow

% Define grayscale colormap from white to light gray
colormap(linspace(0.5, 1, 256)' * [1 1 1]);

% ---------------------------- First subplot ----------------------------

ax1 = nexttile;
hold on;

% Define pulse duration
pulseduration = 7200;
num_pulses = floor(t_f / pulseduration);

% Shade the pulse train regions first and add peak indicators
for n = 0:num_pulses
    start_t = n * pulseduration;
    mid_t = start_t + pulseduration / 2;
    end_t = start_t + pulseduration;
    
    t_vals = [linspace(start_t, mid_t, 50), linspace(mid_t, end_t, 50)];
    alpha_vals = [linspace(0, 1, 50), linspace(1, 0, 50)]; % White to light gray
    gray_intensity_vals = 1 - alpha_vals;
    
    fill([t_vals fliplr(t_vals)], [-amplitude * ones(1, 100) amplitude * ones(1, 100)], ...
        [gray_intensity_vals fliplr(gray_intensity_vals)], 'EdgeColor', 'none');
    
    % Add vertical dashed line at peak
    xline(mid_t, '--k', 'LineWidth', 1.5);
end

% Now plot fplot() so it appears on top
f1 = fplot(case4, [t_i, t_f], 'Color', colors(1,:), 'LineWidth', 1);
ylim([0.105 0.155]);
yline(0.129790358588905,'--k','mean = 0.130', 'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'top')
yline(0.148, '--k', 'max = 0.148', 'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'bottom')
grid on;
grid minor;
set(gca, 'XTickLabel', []);

% ---------------------------- Second subplot ----------------------------

ax2 = nexttile;
hold on;

% Define pulse duration
pulseduration = 3600;
num_pulses = floor(t_f / (2 * pulseduration));

% Shade the pulse train regions first and add peak indicators
for n = 0:num_pulses
    start_t = n * pulseduration;
    mid_t = start_t + pulseduration / 2;
    end_t = start_t + pulseduration;
    
    t_vals = [linspace(start_t, mid_t, 50), linspace(mid_t, end_t, 50)];
    alpha_vals = [linspace(0, 1, 50), linspace(1, 0, 50)]; % White to light gray
    gray_intensity_vals = 1 - alpha_vals;
    
    fill([t_vals fliplr(t_vals)], [-amplitude * ones(1, 100) amplitude * ones(1, 100)], ...
        [gray_intensity_vals fliplr(gray_intensity_vals)], 'EdgeColor', 'none');
    
    % Add vertical dashed line at peak
    xline(mid_t, '--k', 'LineWidth', 1);
end

% Now plot fplot() so it appears on top
f2 = fplot(case3, [t_i, t_f], 'Color', colors(2,:), 'LineWidth', 1.5);
ylim([0.105 0.155]);
yline(0.129790358588905,'--k','mean = 0.130', 'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'bottom')
yline(0.141, '--k', 'max = 0.141', 'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'top')
grid on;
grid minor;
set(gca, 'XTickLabel', []);

% ---------------------------- Third subplot ----------------------------

ax3 = nexttile;
hold on;

% Define pulse duration
pulseduration = 900;
num_pulses = floor(t_f / pulseduration);

% Shade the pulse train regions first and add peak indicators
for n = 0:num_pulses
    start_t = n * pulseduration;
    mid_t = start_t + pulseduration / 2;
    end_t = start_t + pulseduration;
    
    t_vals = [linspace(start_t, mid_t, 50), linspace(mid_t, end_t, 50)];
    alpha_vals = [linspace(0, 1, 50), linspace(1, 0, 50)]; % White to light gray
    gray_intensity_vals = 1 - alpha_vals;
    
    fill([t_vals fliplr(t_vals)], [-amplitude * ones(1, 100) amplitude * ones(1, 100)], ...
        [gray_intensity_vals fliplr(gray_intensity_vals)], 'EdgeColor', 'none');
    
    % Add vertical dashed line at peak
    xline(mid_t, '--k', 'LineWidth', 1);
end

% Now plot fplot() so it appears on top
f3 = fplot(case1, [t_i, t_f], 'Color', colors(3,:), 'LineWidth', 1.5);
ylim([0.105 0.155]);
yline(0.129790358588905,'--k','mean = 0.130', 'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'bottom')
yline(0.135, '--k', 'max = 0.135', 'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'top')
grid on;
grid minor;

% ---------------------------- Formatting ----------------------------

linkaxes([ax1, ax2, ax3], 'x'); 
xlim([t_i t_f]);

legend([f1, f2, f3], {'0.5 cycles/hr', '1 cycle/hr', '4 cycles/hr'}, ...
    'Location', 'northoutside', 'Interpreter', 'latex', 'Orientation', 'Horizontal');