% Load data and extract the numeric array
dataEGF = load('y_norm_HighEGFStep.mat');
dataNGF = load('y_norm_LowNGFStep.mat');

% Extract the only variable in the .mat files
fieldEGF = fieldnames(dataEGF);
fieldNGF = fieldnames(dataNGF);
dataEGF = dataEGF.(fieldEGF{1});
dataNGF = dataNGF.(fieldNGF{1});

% Define time vector that matches data length
t = 0:1:3600;

% Plot results
figure;
hold on;
plot(t, dataEGF, 'r', 'LineWidth', 1.5);
plot(t, dataNGF, 'b', 'LineWidth', 1.5);

% Labels and formatting
title('Simulated ERK* Output From Growth Factor Step Input', 'Interpreter', 'latex')
xlabel('Time (s)', 'Interpreter', 'latex')
ylabel('Concentration (normalised)', 'Interpreter', 'latex')
xlim([0, 3600])
ylim([0, 1])
grid on;
legend({'EGF Response', 'NGF Response'}, 'Location', 'best', 'Interpreter', 'latex');
hold off;