%  -------------------------------------------------------------------------------
% | PART 3: STATE SPACE REPRESENTATION AT ARBITRARY EQUILIBRIUM (PARTLY SYMBOLIC) |  
% |                                    TO                                         |
% |           TRANSFER FUNCTION AND BODE PLOT AT SPECIFIC EQUILIBRIUM             |
%  -------------------------------------------------------------------------------


%--------------------------------PRELIM------------------------------------


% LOAD PARTLY SYMBOLIC MATRICES
load('../data/A_partsym.mat');
load('../data/B_partsym.mat');
load('../data/C_partsym.mat');
load('../data/D_partsym.mat');

% LOAD EQILIBRIA COORDINATES
load('../../Equilibria/data/EquilibriaCoords.mat');

% Define symbols for equilibrium coordinate (x,u) = (x_e,u_e)
% Note: although we already defined these in PART1.m, 
%       it's easier to just redefine them here again 
%       rather than export them in PART1.m then load them here in PART3.m
syms x_1e x_2e x_3e x_4e x_5e x_6e x_7e x_8e x_9e x_10e x_11e x_12e x_13e x_14e x_15e x_16e u_1e
equilibrium = [x_1e x_2e x_3e x_4e x_5e x_6e x_7e x_8e x_9e x_10e x_11e x_12e x_13e x_14e x_15e x_16e u_1e];

% CREATE FILE FOR WRITING TRANSFER FUNCTIONS AT EACH SPECIFIC EQUILIBRIA INTO
fileID = fopen('../data/SpecificEquilibriaTFsLatex.txt','w');

% BODE MAG PLOT OPTIONS
opts1 = bodeoptions('cstprefs');
opts1.grid = 'on';
opts1.MagUnits = 'abs';
opts1.MagScale = 'linear';
% opts1.YLim={[10E-10 10E1]};
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
opts2.MagVisible = 'off';
opts2.XLabel.FontSize = 11;
opts2.XLabel.Interpreter = 'latex';
opts2.YLabel.FontSize = 11;
opts2.YLabel.Interpreter = 'latex';
opts2.Title.FontSize = 11;
opts2.Title.Interpreter = 'latex';


%---------------------------------MAIN-------------------------------------


% JACOBIAN MATRICES: NUMERIC CONSTANTS & NUMERIC EQUILIBRIUM COORDS

% get dimensions of matrix storing equilibrium coordinates
[R,C] = size(limx);

% loop over rows of matrix
for ind = 1:R
    % get row
    row = limx(ind,:);
    % sub equilibrium coordinate values into partly symbolic matrices
    A_sub2 = subs(A_sub1, equilibrium, row);
    B_sub2 = subs(B_sub1, equilibrium, row);
    C_sub2 = subs(C_sub1, equilibrium, row);
    D_sub2 = subs(D_sub1, equilibrium, row);
    % entries are class 'sym' so convert to numeric
    A_sub2 = double(A_sub2);
    B_sub2 = double(B_sub2);
    C_sub2 = double(C_sub2);
    D_sub2 = double(D_sub2);

    %----------------------------------------------------------------------
    % save full numerical matrices
    save('../data/A_fullnum','A_sub2');
    save('../data/B_fullnum','B_sub2');
    save('../data/C_fullnum','C_sub2');
    save('../data/D_fullnum','D_sub2');
    %----------------------------------------------------------------------

%--------------------

% TRANSFER FUNCTION AT SPECIFIC EQUILIBRIUM USING H = C * (sI-A)^-1 * B + D

    syms s                                 % complex frequency

    [m,n] = size(A_sub2);                  % size(I) must match size(A)
    M1 = s * eye(m,n) - A_sub2;            % M1 = sI-A
    M2 = inv(M1);                          % M2 = (sI-A)^-1
    H = (C_sub2 * M2 * B_sub2) + D_sub2;   % H  = (C * (sI-A)^-1 * B) + D
    
    H_simp = simplify(H);                  % simplify transfer function matrix H
    H_coll = collect(H_simp, s);           % collect terms in s
%   ^
%   |
%   |
%   Our specific equilibrium transfer function with class 'sym'. Save it:
    save(sprintf('../data/TransFuncCase%g_ClassSym.mat',ind),'H_coll')

%--------------------

% RECORD TRANSFER FUNCTION TO TEXT

    % get input value
    input = row(end);
    % print prompt
    fprintf(fileID, "CASE %g: \n\n",ind);
    fprintf(fileID, "When constant NGF input u = %g (unitless) \n\n",input);
    fprintf(fileID, "Equilibrium coordinate [x_1e x_2e ... x_15e x_16e u_1e] = [%g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g]", row);
    fprintf(fileID,"\n\nTransfer function is:\n\n");
    % print latex 
    fprintf(fileID, "%c", latex(vpa(H_coll,4)));
    % print new line
    fprintf(fileID,"\n\n____________________________________________\n\n");

%--------------------

% CONVERT TRANSFER FUNCTION FROM TYPE 'SYM' TO TYPE 'TF' FOR BODE PLOTTING

    % see https://au.mathworks.com/matlabcentral/answers/310042-how-to-convert-symbolic-expressions-to-transfer-functions
    sys(s) = H_coll;
    func = matlabFunction(sys);
    func = str2func(regexprep(func2str(func), '\.([/^\\*])', '$1'));
    TF = tf(func(tf('s'))); % by default, the time unit is 'seconds'
%   ^
%   |
%   |
%   The same transfer function as H_coll but now in class 'tf'. Save it:
    save(sprintf('../data/TransFuncCase%g_ClassTf.mat',ind),'TF')

 %--------------------

 % BODE PLOT
    
    % create figure
    h = figure();
    set(h,'units','centimeters','position',[0,0,20,13])

    % bode mag plot
    subplot(2,1,1)
    opts1.Title.String = sprintf('Bode magnitude plot | Constant [NGF] input u$_1$ = %g Kd' , input); %<-- Don't need to mention case no. in title because there is only one case
    bodeplot(TF,opts1);
    
    % bode phase plot
    subplot(2,1,2)
    opts2.Title.String = sprintf('Bode phase plot | Constant [NGF] input u$_1$ = %g Kd' , input); %<-- Don't need to mention case no. in title because there is only one case
    bodeplot(TF,opts2);

    % save plot
    exportgraphics(h,sprintf('../plots/BodePlot_Case%g.pdf', ind),'BackgroundColor','none')
%     close(h)

%--------------------

% PHASOR PROJECTIONS
    
    % get data
    minw = 10E-6;
    maxw = 10E+1;
    w = linspace(minw, maxw, 10E6);
    [mag,phase] = bode(TF,w);
    magdata = squeeze(mag(1,1,:));
    phasedata = squeeze(phase(1,1,:));
    
    % calculate real and imaginary components
    real = magdata .* cosd(phasedata);
    imag = magdata .* sind(phasedata);
    
    % create figure
    h1=figure();
    set(h1,'units','centimeters','position',[0,0,20,13])
    
    % plot real component
    subplot(2, 4, [1 2])
    semilogx(w,real)
    grid on
    title('Real component','interpreter','latex')
    xlabel('$\omega$ (rad/s)','interpreter','latex')
    ylabel('$M(\omega) \cos(\phi(\omega))$','interpreter','latex')
    xlim([minw maxw])
    gap1 = abs(min(real) + max(real)) / 10; %extra gap above and below max and min y-values
    ylim([min(real)-gap1 max(real)+gap1])
    
    % plot imaginary component
    subplot(2, 4, [5 6])
    semilogx(w,imag)
    grid on
    title('Imaginary component','interpreter','latex')
    xlabel('$\omega$ (rad/s)','interpreter','latex')
    ylabel('$M(\omega) \sin(\phi(\omega))$','interpreter','latex')
    xlim([minw maxw])
    gap2 = abs(min(imag) + max(imag)) / 10; %extra gap above and below max and min y-values
    ylim([min(imag)-gap2 max(imag)+gap2])
    
    % plot phasor trajectory
    subplot(2, 4, [3 4 7 8])
    plot(real,imag)
    ax3 = gca;
    ax3.YAxisLocation = 'right';
    grid on
    title('Phasor trajectory','interpreter','latex')
    xlabel('$M(\omega) \cos(\phi(\omega))$','interpreter','latex')
    ylabel('$M(\omega) \sin(\phi(\omega))$','interpreter','latex')
    xlim([min(real)-gap1 max(real)+gap1])
    ylim([min(imag)-gap2 max(imag)+gap2])
    
    % add global title
    sgtitle({'Phasor Trajectory' , sprintf('Constant [NGF] input u$_1$ = %g Kd', input)}, 'FontSize',11, 'interpreter','latex') %<-- Don't need to mention case no. in title because there is only one case

    % save plot
    exportgraphics(h1,sprintf('../plots/Phasor_Case%g.pdf', ind),'BackgroundColor','none')
%     close(h1)

end

%--------------------

% CLOSE ANY REAMINING OPENED FILES
fclose(fileID);