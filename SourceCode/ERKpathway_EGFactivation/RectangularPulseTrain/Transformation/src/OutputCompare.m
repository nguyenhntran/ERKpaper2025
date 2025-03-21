% ------------------------------------------------------------------------
%|SUMMARY:                                                                |
%|                                                                        |
%|Compare ERK* outputs for all cases of EGF rectangular pulse train       |
%|inputs.                                                                 |
% ------------------------------------------------------------------------


% ---------------------------- Create figure ----------------------------

h = figure('Visible','off');
set(h,'units','centimeters','position',[0,0,20,15])
tl = tiledlayout(2,1);
title(tl,'ERK* Output Responses to EGF Rectangular Pulse Train Inputs', 'Interpreter','latex')
xlabel(tl,'Time (s)', 'Interpreter','latex')
ylabel(tl,'Concentration (unitless)', 'Interpreter','latex')

% ----- Plot responses due to high EGF rectangular pulse train input -----

nexttile

load('../data/OutputFourierExpansion_Case1.mat')
fplot(newexpansion,[0,150*60])
hold on

load('../data/OutputFourierExpansion_Case2.mat')
fplot(newexpansion,[0,150*60])

load('../data/OutputFourierExpansion_Case3.mat')
fplot(newexpansion,[0,150*60])

load('../data/OutputFourierExpansion_Case4.mat')
fplot(newexpansion,[0,150*60])

title('High EGF' ,'Interpreter','latex')
legend('Case 1: 3''/3''','Case 2: 3''/10''','Case 3: 3''/20''','Case 4: 3''/60''' , 'Location','southoutside' , 'Orientation','horizontal')
grid on
hold off

% ------ Plot responses due to low EGF rectangular pulse train input ------

nexttile

load('../data/OutputFourierExpansion_Case5.mat')
fplot(newexpansion,[0,150*60])
hold on

load('../data/OutputFourierExpansion_Case6.mat')
fplot(newexpansion,[0,150*60])

load('../data/OutputFourierExpansion_Case7.mat')
fplot(newexpansion,[0,150*60])

load('../data/OutputFourierExpansion_Case8.mat')
fplot(newexpansion,[0,150*60])

title('Low EGF' ,'Interpreter','latex')
legend('Case 5: 3''/3''' , 'Case 6: 3''/10''' , 'Case 7: 3''/20''' , 'Case 8: 3''/60''' , 'Location','southoutside' , 'Orientation','horizontal')
grid on
hold off

% --------------------------------- Save ---------------------------------

exportgraphics(h,'../plots/TransformationOutputCompare.pdf','BackgroundColor','none');
close(h);