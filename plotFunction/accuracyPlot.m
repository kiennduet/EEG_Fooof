close all;

lineColorR = hex2rgb('#ef476f'); shapeColorR = hex2rgb('#f4ccd5');
lineColorO = hex2rgb('#d99c0e'); shapeColorO = hex2rgb('#f2e1b8');
lineColorG = hex2rgb('#04a97e'); shapeColorG = hex2rgb('#bfded6');

%  Plot Accuracies across intervals

load('C:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\PGR_Result\PGR_AD\accuraciesAD');
load('C:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\PGR_Result\PGR_MS\accuraciesMS');
load('C:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\PGR_Result\PGR_FT\accuraciesFT');

accuraciesAD = accuraciesAD'*100;
accuraciesMS = accuraciesMS'*100;
accuraciesFT = accuraciesFT'*100;

freqsLower = [0, 1:30];

h = figure; h.Color = [1,1,1]; set(h,'position',[200,300,800,300]);

mean_dataAD = accuraciesAD(1,:); std_dataAD = accuraciesAD(2,:);
mean_dataMS = accuraciesMS(1,:); std_dataMS = accuraciesMS(2,:);
mean_dataFT = accuraciesFT(1,:); std_dataFT = accuraciesFT(2,:);


fill([freqsLower, fliplr(freqsLower)], [mean_dataAD - std_dataAD, fliplr(mean_dataAD + std_dataAD)], shapeColorR , 'EdgeColor', 'none', 'FaceAlpha', 0.6);
hold on; h1 = plot(freqsLower, mean_dataAD, '-', 'LineWidth', 1.5, 'Color', lineColorR); 
hold on; plot(0, mean_dataAD(1,1), 'x', 'LineWidth', 1.5, 'Color', lineColorR)

% fill([freqsLower, fliplr(freqsLower)], [mean_dataMS - std_dataMS, fliplr(mean_dataMS + std_dataMS)], shapeColorO , 'EdgeColor', 'none', 'FaceAlpha', 0.6);
% hold on; h2 = plot(freqsLower, mean_dataMS, '-', 'LineWidth', 1.5, 'Color', lineColorO); 
% hold on; plot(2, mean_dataMS(1,3), 'o', 'LineWidth', 1.5, 'Color', lineColorO)

% fill([freqsLower, fliplr(freqsLower)], [mean_dataFT - std_dataFT, fliplr(mean_dataFT + std_dataFT)], shapeColorG , 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% hold on; h3 = plot(freqsLower, mean_dataFT, '-', 'LineWidth', 1.5, 'Color', lineColorG); 
grid on; grid minor;

xlabel('Lower Cutoff [Hz]', 'FontSize', 15, 'FontName', 'Arial');
ylabel('Accuracy [%]', 'FontSize', 15, 'FontName', 'Arial');
% legend([h1,h2,h3], 'AD','MS', 'FT', 'FontName', 'Arial')
% legend([h1,h2], 'Cohort 1','Cohort 2', 'FontSize', 15, 'FontName', 'Arial')
legend([h1], 'AD vs Controls', 'FontSize', 20, 'FontName', 'Arial')

% print(h,'C:\Users\Admin\Pictures\EUSIPCO\accuPlot.png','-dpng','-r300');

