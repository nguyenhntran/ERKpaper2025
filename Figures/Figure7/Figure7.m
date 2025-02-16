% LOAD TRANSFER FUNCTION
load('TransFuncCase1_ClassTf.mat');

% BODE MAG PLOT OPTIONS
opts1 = bodeoptions('cstprefs');
opts1.grid = 'on';
opts1.MagUnits = 'abs';
opts1.MagScale = 'linear';
opts1.YLim={[0 0.017]};
opts1.PhaseVisible = 'off';
opts1.XLabel.FontSize = 11;
opts1.XLabel.Interpreter = 'latex';
opts1.YLabel.FontSize = 11;
opts1.YLabel.Interpreter = 'latex';
opts1.Title.FontSize = 11;
opts1.Title.Interpreter = 'latex';

% BODE PHASE PLOT OPTIONS
opts2 = bodeoptions('cstprefs');
opts2.grid = 'on';
opts2.YLim={[-460 190]};
opts2.MagVisible = 'off';
opts2.XLabel.FontSize = 11;
opts2.XLabel.Interpreter = 'latex';
opts2.YLabel.FontSize = 11;
opts2.YLabel.Interpreter = 'latex';
opts2.Title.FontSize = 11;
opts2.Title.Interpreter = 'latex';

% Make figure
h = figure();
set(h,'units','centimeters','position',[0,0,20,13])

% bode mag plot
subplot(2,1,1)
opts1.Title.String = 'Bode Magnitude Plot';
h_mag = bodeplot(TF, opts1);
% Manually adjust the Y-axis ticks
ax = getaxes(h_mag);
set(ax, 'YTick', [0 0.005 0.01 0.015 0.017]);

% bode phase plot
subplot(2,1,2)
opts2.Title.String = 'Bode Phase Plot';
h_pha = bodeplot(TF,opts2);
% Manually adjust the Y-axis ticks
ax = getaxes(h_pha);
set(ax, 'YTick', [-450 -360 -180 0 180]);

% Set line width manually
lines = findall(h, 'Type', 'line'); % Find all line objects in the figure
set(lines, 'LineWidth', 1.5); % Set line width to 1.5

% Overall figure title
sgtitle('Bode Plots for Mean EGF Concentration of 2.1 Kd', 'FontSize', 12, 'Interpreter', 'latex');