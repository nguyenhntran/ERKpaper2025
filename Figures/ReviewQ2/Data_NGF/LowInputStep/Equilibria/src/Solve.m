%  ----------------------------------------------------------------------
% |                              CODE #3                                 |
% | SUMMARY:                                                             |
% | SOLVES ERKDYNAMEQU.M FOR LONG TIME TO GET EQUILIBRIUM VALUES OF X_N. |
% | DOES THIS FOR CONSTANT NGF INPUT =                                   |
% | 2 (ng/ml)                                                            |
% |                                                                      |
% | Inputs:                                                              |
% | 1. Constants.mat                                                     |
% | 2. InitConds.mat                                                     |
% |                                                                      |
% | Outputs:                                                             |
% | 1. Timecourse.png                                                    |
% | 2. EquilibriaCoords.mat                                              |
%  ----------------------------------------------------------------------


% ---------------------------- PRELIMINARY --------------------------------

% Load constants
load('../data/Constants.mat');

% Load initial conditions
load('../data/InitConds.mat');

% Define integration timespan (units seconds)
tspan = linspace(0,1E5,1E5);

% Define NGF input values (units ng/ml)
NGFvals = [2];
% Convert NGF input values to dimensionless u values used in Pertz2015
NGFvals = NGFvals / (26); %26 kDa mol weight and 1nM binding affinity

% Define empty matrix to store equilibria values
limx = [];

%  -----------------------------------------------------------------
% |                  x1_lim  x2_lim  ...  x15_lim  x16_lim  u1_lim  |
% |         NGFval1 [                                             ] |
% |         NGFval2 [                                             ] |
% |  limx = NGFval3 [                                             ] |
% |            .    [                                             ] |
% |            .    [                                             ] |
% |            .    [                                             ] |
% |         NGFvaln [                                             ] |
%  -----------------------------------------------------------------


% ------------------------ SOLVING AND PLOTTING ---------------------------

% For each case of input value in NGFvals
for ind = 1:length(NGFvals)
    
    % Set u1 equal to value
    u1 = NGFvals(ind);
    
    % Solve system of ODEs
    [t,x] = ode45(@(t,x) ERKDynamEqu(t, x, u1, k1R, kd1R, PtaseR, k2, K2, kd2, D2, ...
    k3F, K3, K3R, kd3, D3, PtaseNFB, k4, K4, kd4, D4, PtaseMEK, k5, K5, ...
    kd5, D5, KNFB, PtaseRaf, kPFB, KPFB, k6R, K6, kd6, D6, GAP, k7, K7, ...
    kd7, D7, PtasePFB, duspbasal, duspind, Kdusp, Tdusp, TDUSP), tspan, init);
    
    % Append limiting values of each x_n coordinate to empty matrix above
    limx = [limx ; x(end,:) , u1];
    
    % Plot time evolution of each x_n coordinate for current case

    h=figure('visible','off');
    set(h,'units','centimeters','position',[0,0,17,23])
    tl = tiledlayout('flow');
    tl.TileSpacing = 'compact';
    tl.Padding = 'compact';
    title(tl, sprintf('Pathway Concentration Timecourses for Case %g', ind)) 
    subtitle(tl,sprintf('Constant NGF input u(t) = %g (unitless)', u1))
    xlabel(tl,'t (sec)')
    ylabel(tl,'x_n(t) (unitless)')
    
    nexttile
    plot(t,x(:,1),'-.');
    hold on
    plot(t,x(:,2),'-.');
    plot(t , x(:,1)+x(:,2) , '-.'); %check conservation of mass
    hold off
    title('x_1(t) = [R] and x_2(t) = [R*]');
    ylim([-0.1 1.1]);
    legend('x_1(t)', 'x_2(t)', 'sum', 'Location','southeast');

    nexttile
    plot(t,x(:,3),'-.');
    hold on
    plot(t,x(:,4),'-.');
    plot(t , x(:,3)+x(:,4) , '-.'); %check conservation of mass
    hold off
    title('x_3(t) = [Ras] and x_4(t) = [Ras*]');
    ylim([-0.1 1.1]);
    legend('x_3(t)', 'x_4(t)', 'sum', 'Location','southeast');
    
    nexttile
    plot(t,x(:,5),'-.');
    hold on
    plot(t,x(:,6),'-.');
    plot(t , x(:,5)+x(:,6) , '-.'); %check conservation of mass
    hold off
    title('x_5(t) = [Raf] and x_6(t) = [Raf*]');
    ylim([-0.1 1.1]);
    legend('x_5(t)', 'x_6(t)', 'sum', 'Location','southeast');

    nexttile
    plot(t,x(:,7),'-.');
    hold on
    plot(t,x(:,8),'-.');
    plot(t , x(:,7)+x(:,8) , '-.'); %check conservation of mass
    hold off
    title('x_7(t) = [MEK] and x_8(t) = [MEK*]');
    ylim([-0.1 1.1]);
    legend('x_7(t)', 'x_8(t)', 'sum', 'Location','southeast');

    nexttile
    plot(t,x(:,9),'-.');
    hold on
    plot(t,x(:,10),'-.');
    plot(t , x(:,9)+x(:,10) , '-.'); %check conservation of mass
    hold off
    title('x_9(t) = [ERK] and x_{10}(t) = [ERK*]');
    ylim([-0.1 1.1]);
    legend('x_9(t)', 'x_{10}(t)', 'sum', 'Location','southeast');

    nexttile
    plot(t,x(:,11),'-.');
    hold on
    plot(t,x(:,12),'-.');
    plot(t , x(:,11)+x(:,12) , '-.'); %check conservation of mass
    hold off
    title('x_{11}(t) = [NFB] and x_{12}(t) = [NFB*]');
    ylim([-0.1 1.1]);
    legend('x_{11}(t)', 'x_{12}(t)', 'sum', 'Location','southeast');

    nexttile
    plot(t,x(:,13),'-.');
    hold on
    plot(t,x(:,14),'-.');
    plot(t , x(:,13)+x(:,14) , '-.'); %check conservation of mass
    hold off
    title('x_{13}(t) = [PFB] and x_{14}(t) = [PFB*]');
    ylim([-0.1 1.1]);
    legend('x_{13}(t)', 'x_{14}(t)', 'sum', 'Location','southeast');

    nexttile
    plot(t,x(:,15),'-.');
    hold on
    plot(t,x(:,16),'-.');
    plot(t , x(:,15)+x(:,16) , '-.'); %not conserved but sum anyway
    hold off
    title('x_{15}(t) = [dusp] and x_{16}(t) = [DUSP]');
    legend('x_{15}(t)', 'x_{16}(t)', 'sum', 'Location','southeast');


    % Plot separate interactive figure for [ERK] and [ERK*] timecourse
    h1=figure();
    plot(t,x(:,9),'-.');
    hold on
    plot(t,x(:,10),'-.');
    plot(t , x(:,9)+x(:,10) , '-.'); %check conservation of mass
    hold off
    title('x_9(t) = [ERK] and x_{10}(t) = [ERK*]');
    ylim([-0.1 1.1]);
    legend('x_9(t)', 'x_{10}(t)', 'sum', 'Location','southeast');

% ------------------------------ SAVING -----------------------------------

    % Save first timecourse plot with all species
    saveas(h,sprintf('../plots/TimecourseCase%g.png', ind));

    % Save second interactive timecourse plot with ERK and ERK*
    savefig(h1,sprintf('../plots/TimecourseCase%g_ERK.fig', ind),'compact');
    % Close figure h1 (we couldn't create h1 with visibility 'off' because that would make the saved fig files also have visibility off when opened later)
    close(h1)

end

% Save matrix of limiting x_n values
save('../data/EquilibriaCoords.mat','limx')