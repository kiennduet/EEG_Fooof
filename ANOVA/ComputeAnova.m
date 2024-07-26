
close all; clear;
load('E:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\result\Decre_Out07.mat')
load('E:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\result\Intact_Out07.mat')

input_param = input('Type kind of input (1 - CF, 2 - PW, 3 - BW, 4 - OS, 5 - (Knee), (6 - Exponent): ');
% Create Sample Data
pD = [];
pI = [];
for i = 1:19
curI  = Intact_Out(i).All_Parameters(:,input_param);
pI = [pI; curI];

curD  = Decre_Out(i).All_Parameters(:,input_param);
pD = [pD; curD];
end;
y = [pI' , pD'];

% Factor 1: 2 kinds of Patient
G1 = [zeros(1,size(pI,1)) , ones(1,size(pD,1))]; 

% Factor 2: 19 channels
G2 = [];
for j = 1:19
    n = size(Intact_Out(j).All_Parameters(:,input_param), 1);
    
    G2 = [G2, ones(1,n)*j];
end
G2 = [G2, G2];

pValue1 = anovan(y, {G1,G2}, 'model' , 'interaction')

% Sample data for two groups (Group A and Group B)
groupD_data = pD;
groupI_data = pI;

% Combine the data into a single cell array for violinplot function
combined_data = {groupD_data, groupI_data};

% Create a raincloud plot
switch input_param
    case 1
    tLable = 'Central Frequency';
    case 2
    tLable = 'Power';
    case 3
    tLable = 'Bandwidth';
    case 4
    tLable = 'Offset';
    case 5 
    tLable = 'Knee';
    case 6
    tLable = 'Exponent';
end
figure;
raincloud = violin(combined_data, 'ShowData', false,'xlabel', {'Decreased Group','Intact Group'});
title(tLable);

disp([num2str(mean(pD)) ,'+', num2str(std(pD))]);
disp([num2str(mean(pI)) ,'+', num2str(std(pI))]);

