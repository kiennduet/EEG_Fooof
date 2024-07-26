% close all;

% dataType = input('Data Type ? [MS/AD/FTLD]: ','s');
dataType = 'MS';

load('pgrAD146.mat');
load('pgrMS307.mat');

switch dataType
    case 'AD'
        pgr = pgrAD146;
        titleText = 'Aperiodic parameters for AD patients and Controls';
        titleText2 = 'Periodic parameters for AD patients and Controls';
        iG = 'HC'; dG = 'AD';
    case 'FT'
        pgr = pgrAD146;
        titleText = 'Aperiodic parameters for FTLD patients and Controls';
        titleText2 = 'Periodic parameters for FTLD patients and Controls';
        iG = 'HC'; dG = 'FT';
    case 'MS'       
        pgr = pgrMS307;
        titleText = 'Aperiodic parameters for MS cog+ and MS cog- patients';
        titleText2 = 'Periodic parameters for MS cog+ and MS cog- patients';
        iG = 'Cog+'; dG = 'Cog-';
    otherwise,
        disp('None Data Type'); 
end

channelLabel = {'Fp1';'Fp2';'F7';'F3';'Fz';'F4';'F8';'T3';'C3';...
                'Cz';'C4';'T4';'T5';'P3';'Pz';'P4';'T6';'O1';'O2'};

channelsToUse = [3 4 5 6 7 8 9 10 11 12 18 14 15 16 19];
%% Aperiodic Plot
h=figure('visible', 'off'); h.Color = [1, 1, 1];
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
    disPlot(osI, expI, osD, expD, char(channelLabel(channelsToUse(i))));
    grid on; box on; grid minor;
    xlim([-2 10]); ylim([-2 5]);

end
legend(iG, dG, 'Location','SouthEast');
ax = axes('Position', [0, 0, 1, 1], 'Visible', 'off');
text(0.5, 0.98, titleText, 'FontSize', 18, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');

for i = [1 6 11]; ylabel(hsubplot(i), 'Exponent','FontSize', 15); end
for i = [11 12 13 14 15]; xlabel(hsubplot(i), 'Offset','FontSize', 15); end

%% Periodic Plot
h=figure('visible', 'off'); h.Color = [1, 1, 1];
set(h,'position',[200,300,800,800]);
for i = 1:15
    dataToExamine = pgr.channelGroupTable(channelsToUse(i));
    
    cfI  = dataToExamine.AllParametersIntact(:,1);
    bwI = dataToExamine.AllParametersIntact(:,2);
    
    switch dataType
        case 'MS'
            cfD = dataToExamine.AllParametersDecre(:,1);
            bwD = dataToExamine.AllParametersDecre(:,2);
        case 'AD'
            cfD = dataToExamine.AllParametersAD(:,1);
            bwD = dataToExamine.AllParametersAD(:,2);
        case 'FT'
            cfD = dataToExamine.AllParametersFTLD(:,1);
            bwD = dataToExamine.AllParametersFTLD(:,2);
    end
    
    hsubplot(i) = subplot(3,5,i);
    disPlot(cfI, bwI, cfD, bwD, char(channelLabel(channelsToUse(i))));
    grid on; box on; grid minor;
    xlim([0 20]); ylim([0 2]);

end
legend(iG, dG, 'Location','SouthEast');
ax = axes('Position', [0, 0, 1, 1], 'Visible', 'off');
text(0.5, 0.98, titleText2, 'FontSize', 18, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');

for i = [1 6 11]; ylabel(hsubplot(i), 'log(Power)','FontSize', 15); end
for i = [11 13 15]; xlabel(hsubplot(i), 'Frequency[Hz]','FontSize', 15); end

%% Periodic & Ape Plot
h=figure('visible', 'on'); h.Color = [1, 1, 1];
set(h,'position',[200,200,800,800]);
for i = 1:15
    dataToExamine = pgr.channelGroupTable(channelsToUse(i));
    
    cfI  = dataToExamine.AllParametersIntact(:,1);
    bwI = dataToExamine.AllParametersIntact(:,2);
    expI = dataToExamine.AllParametersIntact(:,5);
    
    switch dataType
        case 'MS'
            cfD = dataToExamine.AllParametersDecre(:,1);
            bwD = dataToExamine.AllParametersDecre(:,2);
            expD = dataToExamine.AllParametersDecre(:,5);
        case 'AD'
            cfD = dataToExamine.AllParametersAD(:,1);
            bwD = dataToExamine.AllParametersAD(:,2);
            expD = dataToExamine.AllParametersAD(:,5);
        case 'FT'
            cfD = dataToExamine.AllParametersFTLD(:,1);
            bwD = dataToExamine.AllParametersFTLD(:,2);
            expD = dataToExamine.AllParametersFTLD(:,5);
    end
    
    hsubplot(i) = subplot(3,5,i);
    disPlot(cfI, expI, cfD, expD, char(channelLabel(channelsToUse(i))));
    grid on; box on; grid minor;
    xlim([0 20]); ylim([0 2]);

end
legend(iG, dG, 'Location','SouthEast');
ax = axes('Position', [0, 0, 1, 1], 'Visible', 'off');
text(0.5, 0.98, ['Exp & Cf'], 'FontSize', 18, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');

for i = [1 6 11]; ylabel(hsubplot(i), 'Exponent','FontSize', 15); end
for i = [11 13 15]; xlabel(hsubplot(i), 'Frequency[Hz]','FontSize', 15); end

