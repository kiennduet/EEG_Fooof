% close all;
load('pgrAD146.mat');
load('pgrMS307.mat');

%% Setting
% dataType = input('Data Type ? [MS/AD/FTLD]: ','s');
dataType = 'AD';
paramsType = 'Center Frequency'; % Offset/Exponent/

xRange = 'auto';
yRange = 'auto';

%%
switch dataType
    case 'AD'
        pgr = pgrAD146;
        titleText = [ paramsType ' distributions for AD, FTLD patients and Controls'];

    case 'MS'       
        pgr = pgrMS307;
        titleText = [paramsType ' distributions for MS cog+ and MS cog- patients'];
    otherwise,
        disp('None Data Type');
end

switch paramsType
    case 'Center Frequency', 
        paramsNum = 1; xLabel = 'Frequency[Hz]';
        xRange = [-3 19]; yRange = 'auto';
    case 'Offset', 
        paramsNum = 4; xLabel = 'Offset';
        xRange = [-1 7]; yRange = 'auto';
    case 'Exponent', 
        paramsNum = 5; xLabel = 'Exponent';
        xRange = [-1 4]; yRange = 'auto';
    otherwise, disp('None Data Type'); 
end

%% Plot
channelLabel = {'Fp1';'Fp2';'F7';'F3';'Fz';'F4';'F8';'T3';'C3';...
                'Cz';'C4';'T4';'T5';'P3';'Pz';'P4';'T6';'O1';'O2'};
channelsToUse = [3 4 5 6 7 8 9 10 11 12 18 14 15 16 19];

h=figure;
h.Color = [1, 1, 1];
set(h,'position',[1000,300,800,800]);
for i = 1:15
    dataToExamine = pgr.channelGroupTable(channelsToUse(i));
    
    switch dataType
        case 'MS'
            
            paramsI = dataToExamine.AllParametersIntact(:,paramsNum);
            paramsD = dataToExamine.AllParametersDecre(:,paramsNum);
            
            % Estimate PDFs using kernel smoothing
            [f1, x1] = ksdensity(paramsI);
            [f2, x2] = ksdensity(paramsD);

            % Plot PDFs
            hsubplot(i) = subplot(3,5,i);

            plot(x1, f1, 'Color', hex2rgb('#04a97e'), 'LineWidth', 2, 'DisplayName', 'CO');
            hold on;
            plot(x2, f2, 'Color',hex2rgb('#ef476f'), 'LineWidth', 2, 'DisplayName', 'MS');
            title(channelLabel(channelsToUse(i)),'FontSize', 14);

            grid on; box on; grid minor;
            xlim(xRange); 
            ylim(yRange);

            if i == 15
                legend('Cog+', 'Cog-', 'Location', 'SouthEast');
            end
            
        case 'AD'
            
            
            paramsI = dataToExamine.AllParametersIntact(:,paramsNum);
            paramsAD = dataToExamine.AllParametersAD(:,paramsNum);
            paramsFT = dataToExamine.AllParametersFTLD(:,paramsNum);
            
            % Estimate PDFs using kernel smoothing
            [f1, x1] = ksdensity(paramsI);
            [f2, x2] = ksdensity(paramsAD);
            [f3, x3] = ksdensity(paramsFT);
            % Plot PDFs
            hsubplot(i) = subplot(3,5,i);

            plot(x1, f1, 'Color', hex2rgb('#04a97e'), 'LineWidth', 2, 'DisplayName', 'CO');
            hold on;
            plot(x2, f2, 'Color',hex2rgb('#ef476f'), 'LineWidth', 2, 'DisplayName', 'AD');
            hold on;
            plot(x3, f3,'Color',hex2rgb('#d99c0e'), 'LineWidth', 2, 'DisplayName', 'FT');
            title(channelLabel(channelsToUse(i)),'FontSize', 14);

            grid on; box on; grid minor;
            xlim(xRange); 
            ylim(yRange);
        
            if i == 15
                legend('HC', 'AD', 'FT', 'Location', 'SouthEast');
            end
                   
    end
    
end

ax = axes('Position', [0, 0, 1, 1], 'Visible', 'off');
text(0.5, 0.98, titleText, 'FontSize', 18, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');

for i = [1 6 11]; ylabel(hsubplot(i), 'Probability','FontSize', 15); end
for i = [11  13  15]; xlabel(hsubplot(i), xLabel ,'FontSize', 15); end


% set(hFig, 'PaperPositionMode', 'Auto');
% print('multiple_subplots.png', '-dpng', '-r600'); 

