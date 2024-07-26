
% EEG = pop_loadset('D:\1_Course\6_Course_1_2023\Week10\Archive\intact_cognition\p2656.set');
% EEG = pop_loadset('D:\1_Course\6_Course_1_2023\Week7\EEG_Data\P0001800.set');
% Transpose, to make inputs column vectors

function scaler = MinMaxScaler(EEG, n_channel)

name_patient = EEG.filename;
data = EEG.data';

nfft = 512;
window = hamming(nfft);
overlap = 0;

% Caculate & Plot Power Spectra Density
[pxxs,freqs] = pwelch(data, window, overlap, nfft, EEG.srate);

freqs = freqs';

settings = struct(...
        'peak_width_limits', [1.0, 5], ... %bandwidth
        'max_n_peaks', 1, ... %number of peaks
        'min_peak_height', 0.5, ... %minimum of the power of the peak, over the aperiodic component
        'peak_threshold', 0.0, ...
        'aperiodic_mode', 'fixed', ...
        'verbose', false); 
f_range = [0.1, 45];

channel_result = [];

for pxx = pxxs
    cur_result = fooof(freqs, pxx', f_range, settings, true);
    channel_result = [channel_result, cur_result];
end

pxxs = pxxs';
    
    pxx_n = pxxs( n_channel , :); 
    %Standardization
    pxx_std = ( pxx_n - min(pxx_n) ) / ( max(pxx_n) - min(pxx_n) );

% if size(channel_result(n_channel).peak_params, 1) == 0
%     pxx_nor = zeros(1, size(pxxs(n_channel, :),2));
%     disp(name_patient);
% else
%     % normalize
% %     pxx_nor = pxxs(n_channel, :) ./  channel_result(n_channel).peak_params(1,2);
% end

cf = [];

if size(channel_result(n_channel).peak_params, 1) == 0
    cf = 0;
else
    cf = channel_result(n_channel).peak_params(1,1);
end

  scaler = struct( 'pxx_std' , pxx_std, 'center_freqs_peak' , ...
      cf );
    
end


    
    
