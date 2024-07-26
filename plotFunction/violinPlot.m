close all;
load('C:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\data\adEEG.mat');
load('C:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\data\msEEG.mat');

allEEG = adEEG;

%% Power label
deltaP = []; thetaP = []; alphaP = []; betaP  = [];
for i = 1:146
    cur = allEEG(i).PSD(1:19,:);
    curPSD = mean(cur);
    
    delta = curPSD(1, 1:9);
    theta = curPSD(1, 10:17);
    alpha = curPSD(1, 18:30);
    beta  = curPSD(1, 31:62);
    
    deltaP(i,:) = sum(delta(:));
    thetaP(i,:) = sum(theta(:));
    alphaP(i,:) = sum(alpha(:));
    betaP(i,:)  = sum(beta(:));
    
end
fullPAD = [deltaP, thetaP, alphaP, betaP]; 


% 1-129: decre; 130-307: intact
% 1-55: AD; 56-95: HC

band = deltaP;
MSd = band(56:95, :);
MSi = band(1:55,:);
[h,p] = ttest2(MSd, MSi)


