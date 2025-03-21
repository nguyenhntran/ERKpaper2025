% Define state space model
load('TransferFunction/data/A_fullnum.mat');
load('TransferFunction/data/B_fullnum.mat');
load('TransferFunction/data/C_fullnum.mat');
load('TransferFunction/data/D_fullnum.mat');

% Create the state-space system
sys = ss(A_sub2, B_sub2, C_sub2, D_sub2);

% Define the time vector
t = 0:1:3600; % Time steps of 1 second

% Define the input rectangular pulse
u = zeros(size(t)); % Initialize input signal
u(t >= 0 & t < 3600) = 2/26; % Set pulse height

% Initial state (if any)
x0 = [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1];

% Simulate system response
[y, t, x] = lsim(sys, u, t, x0);

% Normalize input and output
u_norm = u / max(abs(u)); % Normalize input
y_norm = y / max(abs(y)); % Normalize output

% Save data
save('y_norm_LowNGFStep.mat', 'y_norm');

% Plot results
figure;
hold on;

plot(t, y_norm, 'r', 'LineWidth', 1.5);
title('Simulated ERK* Output for Low NGF Step Input', 'Interpreter', 'latex')
xlabel('Time (s)', 'Interpreter', 'latex')
ylabel('Concentration (normalised)', 'Interpreter', 'latex')
xlim([0, 3600])
ylim([0, 1])
grid on;

% Define the shaded region for the pulse ON duration
% fill([0 3600 3600 0], [0 0 1 1], [0.7, 0.7, 0.7], 'FaceAlpha', 0.5, 'EdgeColor', 'none');