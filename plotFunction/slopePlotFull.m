

% dataType = input('FData Type ? [MS/AD/FT]: ','s');
dataType = 'AD';
xRange = 'auto';
yRange = 'auto';

load('pgrAD146.mat'); load('pgrMS307.mat'); load('freqsAll.mat');
switch dataType
    case 'AD'
        pgr = pgrAD146;
        titleText = 'Average 1/f slope for AD and Controls';
        iG = 'HC'; dG = 'AD';
    case 'FT'
        pgr = pgrAD146;
        titleText = 'Average 1/f slope for FTLD and Controls';
        iG = 'HC'; dG = 'FT';        
    case 'MS'       
        pgr = pgrMS307;
        titleText = 'Average 1/f slope for MS cog+ and MS cog- patients';
        iG = 'Cog+'; dG = 'Cog-';
    otherwise,
        disp('None Data Type');
end

channelLabel = {'Fp1';'Fp2';'F7';'F3';'Fz';'F4';'F8';'T3';'C3';...
                'Cz';'C4';'T4';'T5';'P3';'Pz';'P4';'T6';'O1';'O2'};
channelsToUse = [3 4 5 6 7 8 9 10 11 12 18 14 15 16 19];
h=figure; h.Color = [1, 1, 1];
set(h,'position',[1000,200,800,800]);

for i = 1:15
    dataToExamine = pgr.channelGroupTable(channelsToUse(i));
    
    osI  = dataToExamine.AllParametersIntact(:,4);
    expI = dataToExamine.AllParametersIntact(:,5);
    
    switch dataType
        case 'MS'
            osD = dataToExamine.AllParametersDecre(:,4);
            expD = dataToExamine.AllParametersDecre(:,5);
        case 'AD'
            osD = dataToExamine.AllParametersAD(:,4);
            expD = dataToExamine.AllParametersAD(:,5);
        case 'FT'
            osD = dataToExamine.AllParametersFTLD(:,4);
            expD = dataToExamine.AllParametersFTLD(:,5);
    end
    
    hsubplot(i) = subplot(3,5,i);
    slopePlot(osI, expI, osD, expD, freqsAll, char(channelLabel(channelsToUse(i))));
    grid on; box on; grid minor;
    xlim(xRange); ylim(yRange);
    
%     [h1, p1] = ttest2(expI, expD);
%     [h2, p2] = ttest2(osI, osD);
%     disp(char(channelLabel(channelsToUse(i))));
%     disp(['pValue exp: ', num2str(p1)]);
%     disp(['pValue os: ', num2str(p2)]);

end
legend(iG, dG, 'Location','SouthEast');
ax = axes('Position', [0, 0, 1, 1], 'Visible', 'off');
text(0.5, 0.98, titleText, 'FontSize', 18, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');

for i = [1 6 11]; ylabel(hsubplot(i), 'log(Power)','FontSize', 15); end
for i = [11 13 15]; xlabel(hsubplot(i), 'log(Frequency)','FontSize', 15); end

% set(hFig, 'PaperPositionMode', 'Auto');
% print('multiple_subplots.png', '-dpng', '-r600'); 


