
close all;

%% load spectral data
channelToExamine = 18;
labelChannels = {'Fp1';'Fp2';'F7';'F3';'Fz';'F4';'F8';'T3';'C3';...
                'Cz';'C4';'T4';'T5';'P3';'Pz';'P4';'T6';'O1';'O2'};

load('allPowerSpectraAD.mat', 'allPowerSpectraAD'); load('freqsAll.mat');
load('allPowerSpectraMS.mat', 'allPowerSpectraMS');

sp.AD=allPowerSpectraAD(channelToExamine).AD;
sp.HC=allPowerSpectraAD(channelToExamine).HC;
sp.FT=allPowerSpectraAD(channelToExamine).FT;
sp.DMS=allPowerSpectraMS(channelToExamine).dMS;
sp.IMS=allPowerSpectraMS(channelToExamine).iMS;


sp.AD([37], :) =[];
sp.FT([16 36], :) =[];
sp.DMS([14], :) =[];

sortedAD = sortrows(sp.AD, 1);
sortedHC = sortrows(sp.HC, 1);
sortedFT = sortrows(sp.FT, 1);
sortedDMS = sortrows(sp.DMS, 1);
sortedIMS = sortrows(sp.IMS, 1);

%% plot all spectra for this frequency
% limited version %%%%%%%%%%%%%%%%%%%%%
range= 1:63;

%% plot all spectra for this frequency
hs=[];
ha = figure('visible', 'on'); ha.Color = [1, 1, 1];
set(ha,'position',[300,200, 800, 1000]);
hs(1) = subplot (3,2,1); imagesc( sortedAD(:, range) ); title('AD','FontSize', 12);
hs(2) = subplot (3,2,2); imagesc( sortedFT(:, range)); title('FTLD','FontSize', 12);
hs(3) = subplot (3,2,3); imagesc( sortedHC(:, range)); title('HC','FontSize', 12);
hs(4) = subplot (3,2,5); imagesc( sortedDMS(:, range)); title('MS cog+','FontSize', 12);
hs(5) = subplot (3,2,6); imagesc( sortedIMS(:, range)); title('MS cog-','FontSize', 12);

colormap(parula);
xTicks = 1:10:60; xTickLabels = 1:5:30;
for i = 1:5;
    subplot(hs(i));
    colorbar;
    caxis([1 20]);
    set(gca, 'XTick', xTicks, 'XTickLabel', xTickLabels);
end

%% Set labels
for i=[1 3 4]; subplot(hs(i)); ylabel('Subject Number', 'FontSize', 15); end
for i=[2 4 5]; subplot(hs(i)); xlabel('Frequency[Hz]', 'FontSize', 15); end
ax = axes('Position', [0, 0, 1, 1], 'Visible', 'off');
text(0.5, 0.98, ['Power Spectra Colormap: Channel ' char(labelChannels(18))], 'FontSize', 18, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
text(0.1, 0.33, 'b', 'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
text(0.1, 0.93, 'a', 'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');






