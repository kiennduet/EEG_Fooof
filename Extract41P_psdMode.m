
close all;
% load('adEEG');

labelChannels = {'Fp1','Fp2','F7','F3','Fz','F4','F8','T3','C3',...
                'Cz','C4','T4','T5','P3','Pz','P4','T6','O1','O2'};
            
% Import EEG data
nbPatient = input('Number of Patient: ');
EEG = adEEG(nbPatient);
nbchan = input('Number of Channel: ');
lCutoff = input('Lower Cutoff: ');

%% Plot Mode Settings
plotPSD = 'on';
psdRange = 1:140;
plotFitChannel = 'on';

%% Plot PSD
pxxs = EEG.PSD; freqs = EEG.Freqs;
h = figure('visible', plotPSD); h.Color = [1, 1, 1]; set(h,'position',[20,30,800,600]);
plot(freqs(psdRange), 10*log10(pxxs(nbchan,psdRange)),'LineWidth',1.2);
title('Welch Power Spectra Density Estimate', 'FontSize', 18);
xlabel('Frequency[Hz]', 'FontSize', 15);
ylabel('log(Power)', 'FontSize', 15);
legend(labelChannels, 'Location', 'NorthEast', 'FontSize', 13 );
grid on; grid minor;

%% Plot FOOOF
% FOOOF settings
peSettings = struct(...
                'peak_width_limits', [0.05, 20], ... 
                'max_n_peaks', 1, ... 
                'min_peak_height', 0.01, ...
                'peak_threshold', -5, ...
                'aperiodic_mode', 'fixed', ...
                'verbose', false); 
            
apeSettings = struct(...
                'peak_width_limits', [0.05, 20], ... 
                'max_n_peaks', Inf, ... 
                'min_peak_height', 0.1, ...
                'peak_threshold', -10, ...
                'aperiodic_mode', 'fixed', ...
                'verbose', false); 

h = figure; h.Color = [1,1,1]; set(h,'position',[10,200,800,300]);
%%% Run FOOOF

for i = nbchan
     curR = fooof(freqs, pxxs(i,:), [4, 16], peSettings, true);
     subplot(1,2,1);
     fooof_plotV2(curR, plotFitChannel, 'plotMode', 'on', 'on');
     title(['Channel ',num2str(i), ': ' , char(labelChannels(i))]); 
     
     curR2 = fooof(freqs, pxxs(i,:), [lCutoff, 40], apeSettings, true);
     subplot(1,2,2);
     fooof_plotV2(curR2, plotFitChannel, 'plotMode', 'on', 'on');
     title(['Channel ',num2str(i), ': ' , char(labelChannels(i))]);
end

% Error in channel 18 patient 80 pgr from 4 Hz - MS258 [1.62129595256815,1.67566704008959]
% Error in channel 16 patient 113 pgr from 7 Hz - MS291 [1.11494724183589,1.58994660568573]
% Error in channel 9 patient 26 pgr from 11 Hz - MS204 [4.79970573514568,3.82796757632001]
% Error in channel 13 patient 66 pgr from 0.5 Hz - MS244 [0.848938066202588,1.15093253813305]
% Intact
% Error in channel 5 (patient 77) pgr from 1 Hz - [MS107 - 5 - 1] [1.21909222938838,1.76090794510016]



