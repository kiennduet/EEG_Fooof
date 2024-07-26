
close all;
load('adEEG');

labelChannels = {'Fp1','Fp2','F7','F3','Fz','F4','F8','T3','C3',...
                'Cz','C4','T4','T5','P3','Pz','P4','T6','O1','O2'};
            
% Import EEG data
EEG = adEEG(1);
nbchan = 1:19;
% Plot Mode Settings
plotPSD = 'off'; 
psdRange = 1:140;
plotFitChannel = 'on';

pxxs = EEG.PSD; freqs = EEG.Freqs;

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
                'max_n_peaks', 2, ... 
                'min_peak_height', 0.05, ...
                'peak_threshold', -10, ...
                'aperiodic_mode', 'fixed', ...
                'verbose', false);    

h = figure; h.Color = [1,1,1]; set(h,'position',[200,200,500,320]);

%%% Run FOOOF
Result = [];
for i = 18     
    curR2 = fooof(freqs, pxxs(i,:), [0.5, 40], apeSettings, true);

    fooof_plotV2(curR2, plotFitChannel, 'plotMode', 'off', 'on');
    grid off;

end

% set(gca, 'XTickLabel', []);
set(gca, 'XTick', 0:10:40);
set(gca, 'YTickLabel', []);
legend('hide')
xlabel('Frequency[Hz]', 'FontName', 'Arial')
ylabel('log(Power)')



