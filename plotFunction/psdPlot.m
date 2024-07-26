
close all;

%% load spectral data
channelToExamine = 18;
labelChannels = {'Fp1';'Fp2';'F7';'F3';'Fz';'F4';'F8';'T3';'C3';...
                'Cz';'C4';'T4';'T5';'P3';'Pz';'P4';'T6';'O1';'O2'};

load('allPowerSpectraAD.mat', 'allPowerSpectraAD');
load('allPowerSpectraMS.mat', 'allPowerSpectraMS');

sp.AD=allPowerSpectraAD(channelToExamine).AD;
sp.HC=allPowerSpectraAD(channelToExamine).HC;
sp.FT=allPowerSpectraAD(channelToExamine).FT;
sp.DMS=allPowerSpectraMS(channelToExamine).dMS;
sp.IMS=allPowerSpectraMS(channelToExamine).iMS;
load('freqsAll.mat');
% Remove noise
sp.AD([37], :) =[];
sp.FT([16 36], :) =[];
sp.DMS([14], :) =[];

%% (Avarage Power) Figure

lineWidth = 2.8;
lineColorR = hex2rgb('#ef476f'); shapeColorR = hex2rgb('#f4ccd5');
lineColorO = hex2rgb('#d99c0e'); shapeColorO = hex2rgb('#f2e1b8');
lineColorG = hex2rgb('#04a97e'); shapeColorG = hex2rgb('#bfded6');

rangeAP = 1:100;
hb = figure('visible', 'on'); hb.Color = [1,1,1];
set(hb,'position',[800,50,800,1000]); 
freqsAll = freqsAll(rangeAP);
hs(6) = subplot(3,2,1);
    mean_data = mean(sp.AD(:, rangeAP)); std_data = std(sp.AD(:, rangeAP)); 
    fill([freqsAll, fliplr(freqsAll)], [mean_data - std_data, fliplr(mean_data + std_data)], shapeColorR , 'EdgeColor', 'none');
    hold on; plot(freqsAll, mean_data, 'Color', lineColorR ,'LineWidth', lineWidth); 
    title('AD', 'FontSize', 12);
    
hs(7) = subplot(3,2,2);
    mean_data = mean(sp.FT(:, rangeAP)); std_data = std(sp.FT(:, rangeAP));
    fill([freqsAll, fliplr(freqsAll)], [mean_data - std_data, fliplr(mean_data + std_data)], shapeColorO, 'EdgeColor', 'none');
    hold on; plot(freqsAll, mean_data, 'Color', lineColorO , 'LineWidth', lineWidth); hold off;
    title('FTLD', 'FontSize', 12);
    
hs(8) = subplot(3,2,3);
    mean_data = mean(sp.HC(:, rangeAP)); std_data = std(sp.HC(:, rangeAP));
    fill([freqsAll, fliplr(freqsAll)], [mean_data - std_data, fliplr(mean_data + std_data)], shapeColorG , 'EdgeColor', 'none');
    hold on; plot(freqsAll, mean_data, 'Color', lineColorG, 'LineWidth', lineWidth); hold off;
    title('HC', 'FontSize', 12);


hs(9) = subplot(3,2,5);
    mean_data = mean(sp.IMS(:, rangeAP)); std_data = std(sp.IMS(:, rangeAP));
    fill([freqsAll, fliplr(freqsAll)], [mean_data - std_data, fliplr(mean_data + std_data)], shapeColorG , 'EdgeColor', 'none');
    hold on; plot(freqsAll, mean_data, 'Color', lineColorG, 'LineWidth', lineWidth); hold on;
    title('MS cog+', 'FontSize', 12);

hs(10) = subplot(3,2,6);
    mean_data = mean(sp.DMS(:, rangeAP)); std_data = std(sp.DMS(:, rangeAP));
    fill([freqsAll, fliplr(freqsAll)], [mean_data - std_data, fliplr(mean_data + std_data)], shapeColorR , 'EdgeColor', 'none');
    hold on; plot(freqsAll, mean_data, 'Color', lineColorR, 'LineWidth', lineWidth); hold off;
    title('MS cog-', 'FontSize', 12);
    
% % set labels
for i=[ 6 8 9]; subplot(hs(i)); ylabel('log(Power)','FontSize', 15); end
for i=[ 7 9 10]; subplot(hs(i)); xlabel('Frequency[Hz]', 'FontSize', 15); end
for i=6:8; subplot(hs(i)); 
%     ylim([-0.5 3]); 
    ylim([-1 60]); 
    xlim([1 30]); 
    grid on; box on;
end

for i=9:10; subplot(hs(i)); 
%     ylim([-0.5 1.5]); 
    ylim([-1 60]); 
    xlim([1 30]); 
    grid on; box on;
end

ax = axes('Position', [0, 0, 1, 1], 'Visible', 'off');
text(0.5, 0.98, ['Average Power Spectra (1-30Hz): Channel ' char(labelChannels(18))], 'FontSize', 18, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
text(0.08, 0.33, 'b', 'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
text(0.08, 0.93, 'a', 'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');


