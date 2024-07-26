close all;

%% load spectral data
channelToExamine = 18;

load('allPowerSpectraAD.mat', 'allPowerSpectraAD');
sp.AD=allPowerSpectraAD(channelToExamine).AD;
sp.HC=allPowerSpectraAD(channelToExamine).HC;
sp.FT=allPowerSpectraAD(channelToExamine).FT;
load('allPowerSpectraMS.mat', 'allPowerSpectraMS');
sp.DMS=allPowerSpectraMS(channelToExamine).dMS;
sp.IMS=allPowerSpectraMS(channelToExamine).iMS;
load('freqsAll.mat');

sp.AD([37], :) =[];
sp.FT([16 36], :) =[];
sp.DMS([14], :) =[];

range=40:80; colorRange=[1 10]; rangeLabel=range/2;

% Create an index for sorting
sortingIndex = {};
[~, sortingIndex{1}] = sort(mean(sp.AD(:,range), 2)); 
[~, sortingIndex{2}] = sort(mean(sp.HC(:,range), 2)); 
[~, sortingIndex{3}] = sort(mean(sp.FT(:,range), 2)); 
[~, sortingIndex{4}] = sort(mean(sp.DMS(:,range), 2)); 
[~, sortingIndex{5}] = sort(mean(sp.IMS(:,range), 2)); 
% draw figure
ha=figure; set(ha,'position',[300,500,1200, 600]);
% sgtitle(channelLabel{channelToExamine});
colormap autumn;

hs(1) = subplot (2,3,1); 
Z = (sp.AD(sortingIndex{1}, range));
[X, Y] = meshgrid(rangeLabel, 1:size(Z, 1));
surf(X, Y, Z);
title('AD');

hs(2) = subplot (2,3,2);
Z = (sp.HC(sortingIndex{2}, range));
[X, Y] = meshgrid(rangeLabel, 1:size(Z, 1));
surf(X, Y, Z);
title('HC');

hs(3) = subplot (2,3,3); 
Z = (sp.FT(sortingIndex{3}, range));
[X, Y] = meshgrid(rangeLabel, 1:size(Z, 1));
surf(X, Y, Z);
title('FT');

hs(4) = subplot (2,3,4); 
Z = (sp.DMS(sortingIndex{4}, range));
[X, Y] = meshgrid(rangeLabel, 1:size(Z, 1));
surf(X, Y, Z);
title('MSci');

hs(5) = subplot (2,3,5); 
Z = (sp.IMS(sortingIndex{5}, range));
[X, Y] = meshgrid(rangeLabel, 1:size(Z, 1));
surf(X, Y, Z);
title('MSdc');

for i=1:5; 
    subplot(hs(i)); 
    zlim([0 5]); 
    xlabel('frequency (Hz)', 'Rotation', 15)
    ylabel('subject number', 'Rotation', -30)
end
