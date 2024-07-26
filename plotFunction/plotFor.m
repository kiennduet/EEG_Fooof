% close all;
% % load('msEEG.mat')
% % size(msEEG,2)
% % size(psdG,2)
% for i = 1:size(psdG,2)
%     EEG = psdG(i);
%     patientName = strrep(EEG.patientName,'file0','');
%     cogPatient = EEG.cognition;
% %     agePatient = round(str2double(EEG.Age)/365, 2);
% %     onsetPatient = round(str2double(EEG.Onset)/365,2);
% %     schPatient = str2double(EEG.Schooling);
% %     sexPatient = EEG.Sex;
%     pxxs = EEG.PSD;
%     freqs = EEG.Freqs;
%     nChannel = size(pxxs,1);
%     
%     figure('visible', 'off'); grid on;
%     plot(freqs, 10*log10(pxxs(1:19,:)),'LineWidth',0.8);
% %     title(['Patient',patientName,sexPatient,': age ',num2str(agePatient),' - onset ',num2str(onsetPatient),' - sch ',num2str(schPatient),' - ',cogPatient ]);
%     title(['Patient',patientName, ': ',cogPatient]);
%     xlabel('Frequency(Hz)');
%     ylabel('Log Power Spectra Density');
%     legend('show');
%     
%     % Save figure
%     filename = sprintf('patient_%d.png', i); 
%     savePath = fullfile('E:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\PSD_146AD',filename);
%     saveas(gcf, savePath); % L?u hình ?nh v?i tên file fileclname
%     close(gcf);
% end



% load('allEEG.mat');
% for i = 1:60 
%     
%     figure; 
% %     patient_result = PatientResult(allEEG(i), 0 , 'plotPSD');
%     
%     % Save figure
%     filename = sprintf('patient_%d.png', i); 
%     saveas(gcf, filename); % L?u hình ?nh v?i tên file fileclname
%     
%     close(gcf);
% end

% V? distribution 
labelChannels = {'Fp1';'Fp2';'F7';'F3';'Fz';'F4';'F8';'T3';'C3';...
                'Cz';'C4';'T4';'T5';'P3';'Pz';'P4';'T6';'O1';'O2'};
   
load('psdGroupAD.mat')
freqs = psdG(1).Freqs;            
                  
for i = 1:19
%     Figure1
    offsetI = pgr.channelGroupTable(i).AllParametersIntact(:,4);
    expI = pgr.channelGroupTable(i).AllParametersIntact(:,5);
    offsetD = pgr.channelGroupTable(i).AllParametersDecre(:,4);
    expD = pgr.channelGroupTable(i).AllParametersDecre(:,5);
    
    figure('visible', 'off') ; grid on;
    plot(offsetI, expI, 'r.', 'MarkerSize', 10);
    hold on;
    plot(offsetD, expD, 'b.', 'MarkerSize', 10);
    title(['Channel ' num2str(i) ' <' char(labelChannels(i)) '>']);
    xlabel('Offset');
    ylabel('Exponent');
    legend('Cog-','Cog+','Location','SouthEast')
    
%     Save figure
    filename = sprintf('Intercept_%d.png', i); 
    savePath = fullfile('C:\Users\Admin\Pictures\distributionFigAD',filename);
    saveas(gcf, savePath);
    close(gcf);
    
%     Figure 1/f
    slopeI = -(mean(expI)).*(log10(freqs)) + mean(offsetI);
    slopeD = -(mean(expD)).*(log10(freqs)) + mean(offsetD);
    figure('visible', 'off') ; grid on;
    plot(log10(freqs(41:83)), slopeI(41:83), 'r-', 'LineWidth' , 1.2);   
    hold on;
    plot(log10(freqs(41:83)), slopeD(41:83), 'b-', 'LineWidth' , 1.2); 
    
    title(['Channel ' num2str(i) ' <' char(labelChannels(i)) '>']);
    xlabel('Log Frequency');
    ylabel('Log Power Spectra Density');
    legend( ['Cog-: ' num2str(mean(expI))] ,['Cog+: ' num2str(mean(expD))],'Location','NorthEast');

%     Save figure2
    filename = sprintf('1fslope_%d.png', i); 
    savePath = fullfile('C:\Users\Admin\Pictures\distributionFigAD',filename);
    saveas(gcf, savePath);
    close(gcf);
    
end

%% G?p nhi?u ?nh
% ???ng d?n ??n th? m?c ch?a các t?p ?nh
folder_path = 'C:\Users\Admin\Pictures\distributionFigAD\';
% S? l??ng ?nh
num_images = 19;

% S? d?ng cell array ?? l?u tr? các ?nh
images = cell(1, num_images);

% ??c t?ng t?p ?nh và l?u vào cell array
for i = 1:num_images
    image_name = fullfile(folder_path, sprintf('Intercept_%d.png', i));
    images{i} = imread(image_name);
end

% T?o hình ?nh k?t h?p v?i kích th??c phù h?p v?i l??i 5x4
combined_image = uint8(zeros(size(images{1}, 1) * 5, size(images{1}, 2) * 4, 3));

% L?u tr? hàng và c?t hi?n t?i
current_row = 1;
current_col = 1;

% S?p x?p các ?nh vào hình ?nh l?n
for i = 1:num_images
    combined_image(current_row:current_row + size(images{i}, 1) - 1, current_col:current_col + size(images{i}, 2) - 1, :) = images{i};
    current_col = current_col + size(images{i}, 2);
    if current_col > size(combined_image, 2)
        current_row = current_row + size(images{i}, 1);
        current_col = 1;
    end
end

% Hi?n th? hình ?nh k?t h?p
figure;
imshow(combined_image);
imwrite(combined_image, 'C:\Users\Admin\Pictures\distributionFigAD\Intercept_image.png');