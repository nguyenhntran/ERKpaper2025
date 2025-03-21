% ------------------------------------------------------------------------
%|SUMMARY:                                                                |
%|                                                                        |
%|Compare ERK* outputs for all cases of EGF triangular pulse train inputs.|
% ------------------------------------------------------------------------


% ---------------------------- Create figure ----------------------------

h = figure('Visible','off');
set(h,'units','centimeters','position',[0,0,20,10])

% ----- Plot responses due to high EGF rectangular pulse train input -----

load('../data/OutputFourierExpansion_Case1.mat')
fplot(newexpansion,[0,120*60])
hold on

load('../data/OutputFourierExpansion_Case2.mat')
fplot(newexpansion,[0,120*60])

load('../data/OutputFourierExpansion_Case3.mat')
fplot(newexpansion,[0,120*60])

load('../data/OutputFourierExpansion_Case4.mat')
fplot(newexpansion,[0,120*60])

legend('Case 1: 4 cycles/hr','Case 2: 2 cycles/hr','Case 3: 1 cycles/hr','Case 4: 1/2 cycles/hr' , 'Location','southoutside' , 'Orientation','horizontal')
grid on
hold off

title('ERK* Output Responses to EGF Triangular Pulse Train Inputs', 'Interpreter','latex')
xlabel('Time (s)', 'Interpreter','latex')
ylabel('Concentration (unitless)', 'Interpreter','latex')
ylim([0.11 0.15])

% --------------------------------- Save ---------------------------------

exportgraphics(h,'../plots/TransformationOutputCompare.pdf','BackgroundColor','none');
close(h);