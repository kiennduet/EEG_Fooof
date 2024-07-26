close all


load('C:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\PGR_Result\PGR_AD\pgrAD_1.mat');
load('C:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\PGR_Result\PGR_MS\pgrMS_1.mat');
load('C:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\PGR_Result\PGR_FT\pgrFT_1.mat');

load('freqsAll.mat');
% switch dataType
%     case 'AD'
%         pgr = pgrAD146;
%         titleText = 'Average 1/f slope for AD and Controls';
%         iG = 'HC'; dG = 'AD';
%     case 'FT'
%         pgr = pgrAD146;
%         titleText = 'Average 1/f slope for FTLD and Controls';
%         iG = 'HC'; dG = 'FT';        
%     case 'MS'       
%         pgr = pgrMS307;
%         titleText = 'Average 1/f slope for MS cog+ and MS cog- patients';
%         iG = 'Cog+'; dG = 'Cog-';
%     otherwise,
%         disp('None Data Type');
% end

pgr11 = pgrMS_1;
pgr22 = pgrAD_1;
pgr33 = pgrFT_1;

channelsToUse = [1:19];
meanExpI = []; meanExpD = []; meanExpAD = []; meanExpHC = []; meanExpFT = [];
meanCfI = []; meanCfD = []; meanCfAD = []; meanCfHC = []; meanCfFT = [];
for i = 1:19
    pgr1 = pgr11.channelGroupTable(channelsToUse(i));
    pgr2 = pgr22.channelGroupTable(channelsToUse(i));
    pgr3 = pgr33.channelGroupTable(channelsToUse(i));

    cfI  = pgr1.AllParametersIntact(:,1);
    pwI  = pgr1.AllParametersIntact(:,2);
    bwI  = pgr1.AllParametersIntact(:,3);
    osI  = pgr1.AllParametersIntact(:,4);
    expI = pgr1.AllParametersIntact(:,5);
    meanExpI = [meanExpI; mean(expI)];
    meanCfI  = [meanCfI; mean(cfI)];
    
    cfD  = pgr1.AllParametersDecre(:,1);
    pwD  = pgr1.AllParametersDecre(:,2);
    bwD  = pgr1.AllParametersDecre(:,3);
    osD  = pgr1.AllParametersDecre(:,4);
    expD = pgr1.AllParametersDecre(:,5);
    meanExpD = [meanExpD; mean(expD)];
    meanCfD  = [meanCfD; mean(cfD)];
    
    cfHC  = pgr2.AllParametersIntact(:,1);
    pwHC  = pgr2.AllParametersIntact(:,2);
    bwHC  = pgr2.AllParametersIntact(:,3);
    osHC  = pgr2.AllParametersIntact(:,4);
    expHC = pgr2.AllParametersIntact(:,5);
    meanExpHC = [meanExpHC; mean(expHC)];
    meanCfHC  = [meanCfHC; mean(cfHC)];
        
    cfAD  = pgr2.AllParametersAD(:,1);
    pwAD  = pgr2.AllParametersAD(:,2);
    bwAD  = pgr2.AllParametersAD(:,3);
    osAD  = pgr2.AllParametersAD(:,4);
    expAD = pgr2.AllParametersAD(:,5);
    meanExpAD = [meanExpAD; mean(expAD)];
    meanCfAD  = [meanCfAD; mean(cfAD)];
        
    cfFT  = pgr3.AllParametersFTLD(:,1);
    pwFT  = pgr3.AllParametersFTLD(:,2);
    bwFT  = pgr3.AllParametersFTLD(:,3);
    osFT  = pgr3.AllParametersFTLD(:,4);
    expFT = pgr3.AllParametersFTLD(:,5);
    meanExpFT = [meanExpFT; mean(expFT)];
    meanCfFT  = [meanCfFT; mean(cfFT)];
    
    [h1, p1] = ttest2(cfI, cfD);
    [h2, p2] = ttest2(pwI, pwD);
    [h3, p3] = ttest2(bwI, bwD);
    [h4, p4] = ttest2(osI, osD);
    [h5, p5] = ttest2(expI, expD);
    pValueMS(i,:) = [p1, p2, p3, p4, p5];
    
    [h1, p1] = ttest2(cfHC, cfAD);
    [h2, p2] = ttest2(pwHC, pwAD);
    [h3, p3] = ttest2(bwHC, bwAD);
    [h4, p4] = ttest2(osHC, osAD);
    [h5, p5] = ttest2(expHC, expAD);
    pValueAD(i,:) = [p1, p2, p3, p4, p5];

    [h1, p1] = ttest2(cfHC, cfFT);
    [h2, p2] = ttest2(pwHC, pwFT);
    [h3, p3] = ttest2(bwHC, bwFT);
    [h4, p4] = ttest2(osHC, osFT);
    [h5, p5] = ttest2(expHC, expFT);
    pValueFT(i,:) = [p1, p2, p3, p4, p5];
end

channelLabels = {'Fp1';'Fp2';'F7';'F3';'Fz';'F4';'F8';'T3';'C3';...
                'Cz';'C4';'T4';'T5';'P3';'Pz';'P4';'T6';'O1';'O2'};
conditions = {'CF', 'PW', 'BW', 'OS', 'EXP'};

nlpValueMS = -log10(pValueMS);
nlpValueAD = -log10(pValueAD);
nlpValueFT = -log10(pValueFT);

h = figure; h.Color = [1,1,1]; set(h,'position',[1000,300,800,700]);
hs(1) = subplot(2,2,1); 
imagesc(nlpValueMS); title('MS','FontSize', 12);

hs(2) = subplot(2,2,2);
imagesc(nlpValueAD); title('AD','FontSize', 12);

hs(3) = subplot(2,2,3);
imagesc(nlpValueFT); 
title('FTLD','FontSize', 12);


% xlabel('Feature');
% ylabel('Channels');

colormap(parula);

for i = 1:3;
    subplot(hs(i));
    colorbar;
    caxis([0 5]);
    set(gca, 'XTick', 1:5, 'XTickLabel', conditions);
    set(gca, 'YTick', 1:19, 'YTickLabel', channelLabels);
end
for i=[1 3]; subplot(hs(i)); ylabel('Channel', 'FontSize', 15); end
for i=[2 3]; subplot(hs(i)); xlabel('Feature', 'FontSize', 15); end

topoEXP = [meanExpI, meanExpD, nlpValueMS(:,5), meanExpHC, meanExpAD, nlpValueAD(:,5), meanExpHC, meanExpFT, nlpValueFT(:,5)];
topoCF  = [meanCfI, meanCfD, nlpValueMS(:,1), meanCfHC, meanCfAD, nlpValueAD(:,1), meanCfHC, meanCfFT, nlpValueFT(:,1)];

