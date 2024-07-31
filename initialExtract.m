clear;
close all;

% Import EEG data
EEG = pop_loadset();

% Plot Mode Settings
plotPSD = 'on';
plotFitChannel = 'off';
plotClorMap = 'off';
plotApe = 'off';
plotPe = 'off';

% Transpose, to make inputs column vectors
data = EEG.data';
%------------------------------------------------------------
%% Caculate & Plot Power Spectra Density
nfft = 512;
window = hamming(nfft);
overlap = 0;
[pxxs,freqs] = pwelch(data, window, overlap, nfft, EEG.srate);

% Plot Power Spectra Density
figure('visible', plotPSD); grid on;
plot(freqs, 10*log10(pxxs),'LineWidth',1.2);
title('Welch Power Spectra Density Estimate');
xlabel('Frequency(Hz)');
ylabel('Log Power Spectra Density');


% Transpose, to make inputs row vectors
pxxs = pxxs';
freqs = freqs';

% FOOOF settings
settings = struct(...
        'peak_width_limits', [0.01, 6], ... %bandwidth
        'max_n_peaks', 1, ... %number of peaks
        'min_peak_height', 0.02 , ... %minimum of the power of the peak, over the aperiodic component
        'peak_threshold', -10, ...
        'aperiodic_mode', 'fixed', ...
        'verbose', false);  % Use defaults
f_range = [0.1, 20];

% Run FOOOF
Result = struct('data_channel',{});
num_channel_peaks = [0, 0, 0, 0, 0, 0]; % number of channel with 0, 1, 2, 3, 4 or >4 peaks
num_peaks = 0;

% nbchan = [1:size(EEG.data,1)];
nbchan = 1:21;
for i = nbchan
     Result(i).data_channel = fooof(freqs, pxxs(i,:), f_range, settings, true);
     num_peaks = num_peaks + size(Result(i).data_channel.peak_params,1);

     % Print peak parameters
      disp(['Channel ' num2str(i) '-' EEG.chanlocs(i).labels ': Central Frequency - Power - Bandwidth ' ]);
         
      if (size(Result(i).data_channel.peak_params,1) == 0)
        disp('No Peak');
        fooof_plot(Result(i).data_channel, plotFitChannel);
        title(['Channel ',num2str(i), ': ', num2str(size(Result(i).data_channel.peak_params,1)), ' peaks ' ]);
        num_channel_peaks(1,1) = (num_channel_peaks(1,1)) + 1;
      end
      if (size(Result(i).data_channel.peak_params,1) == 1)
        disp(Result(i).data_channel.peak_params);
        num_channel_peaks(1,2) = (num_channel_peaks(1,2)) + 1;
        fooof_plot(Result(i).data_channel, plotFitChannel );                              
        title(['Channel ',num2str(i), ': ', num2str(size(Result(i).data_channel.peak_params,1)), ' peaks: ' ,... 
                                                 num2str(Result(i).data_channel.peak_params(1,1))]);
        hold on;
        plot(Result(i).data_channel.peak_params(:, 1), 0, 'ro');
      end
      
      if (size(Result(i).data_channel.peak_params,1) == 2)
        disp(Result(i).data_channel.peak_params);
        
        fooof_plot(Result(i).data_channel, plotFitChannel);
        title(['Channel ',num2str(i), ': ', num2str(size(Result(i).data_channel.peak_params,1)), ' peaks:' ,... 
                                                 num2str(Result(i).data_channel.peak_params(1,1)),' ',...
                                                num2str(Result(i).data_channel.peak_params(2,1))]);
        hold on;
        plot(Result(i).data_channel.peak_params(:, 1),[0,0], 'ro');

        num_channel_peaks(1,3) = (num_channel_peaks(1,3)) + 1;
      end      
      
      if (size(Result(i).data_channel.peak_params,1) == 3)
          disp(Result(i).data_channel.peak_params);
          title_3 = ['Channel ',num2str(i), ': ', num2str(size(Result(i).data_channel.peak_params,1)), ' peaks:' ,... 
                                                num2str(Result(i).data_channel.peak_params(1,1)),' ',...
                                                num2str(Result(i).data_channel.peak_params(2,1)),' ',...
                                                num2str(Result(i).data_channel.peak_params(3,1))];
          title(title_3);
          num_channel_peaks(1,4) = (num_channel_peaks(1,4)) + 1;
      end      
      
      if (size(Result(i).data_channel.peak_params,1) == 4)
          disp(Result(i).data_channel.peak_params);
          title_4 = ['Channel ',num2str(i), ': ', num2str(size(Result(i).data_channel.peak_params,1)),' peaks' ];
          title(title_4);
          num_channel_peaks(1,5) = (num_channel_peaks(1,5)) + 1;
      end  
      if (size(Result(i).data_channel.peak_params,1) > 4)
          disp(Result(i).data_channel.peak_params);
          fooof_plot(Result(i).data_channel, plotFitChannel);
          title_5 = ['Channel ',num2str(i), ': ', num2str(size(Result(i).data_channel.peak_params,1)), ' peaks' ];
          title(title_5);          
          num_channel_peaks(1,6) = (num_channel_peaks(1,6)) + 1;
      end
end


%%Plot distribution of peaks
distribution_peaks = [];
for i = nbchan
    cur = Result(i).data_channel.peak_params;
    distribution_peaks = [distribution_peaks; cur];
end
distribution_peaks = distribution_peaks';
CenterFreqs = distribution_peaks(:,1);
Powers = distribution_peaks(:,2);

figure('visible', plotPe); grid on;
plot(CenterFreqs,Powers,'ro'); grid;
title('Distribution of Peaks');
xlabel('Center Frequency');
ylabel('Power');

%----------------------------------------------
%% Plotting Aperiodic Component
distribution_ape = [];
for i = nbchan
    cur_a = Result(i).data_channel.aperiodic_params;
    distribution_ape = [distribution_ape; cur_a];
end
Offset = distribution_ape(:, 1);
Exp = distribution_ape(:, 2);

figure('visible', plotApe) ; grid on;
plot(Offset, Exp, 'mx');
title('Aperiodic Component');
xlabel('Offset');
ylabel('Exponent');

%--------------------------------------------
%% Plotting Color Map
temp = pxxs(:, 15:50);
figure('visible', plotClorMap); 
imagesc(temp);
title(EEG.filename);
ylabel('Channel');
colorbar;

