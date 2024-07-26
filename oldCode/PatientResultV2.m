% EEG = pop_loadset('D:\1_Course\6_Course_1_2023\Week7\EEG_Data\P0001800.set');
% patient_result = PatientResultV2(EEG, channelIndex, varargin)
%       EEG: Input data
%       channelIndex: Sequence number of input channel (0 = All)

% Case 1: With default settings
% 
% patient_result = PatientResultV2(EEG, 0)

%--------------------------------------------------------------------------
% Case 2: With custom settings
% peSettings = struct(...
%                 'freqsRangePe',[0.1, 18] ,...
%                 'peak_width_limits', [1.0, 5], ... 
%                 'max_n_peaks', 1, ... 
%                 'min_peak_height', 0.5, ...
%                 'peak_threshold', 0.5, ...
%                 'aperiodic_mode', 'fixed', ...
%                 'verbose', false); 
% apeSettings = struct(...
%                 'freqsRangeApe',[18, 30] ,...
%                 'peak_width_limits', [0.0, 5], ... 
%                 'max_n_peaks', Inf, ... 
%                 'min_peak_height', 0.0, ...
%                 'peak_threshold', -1, ...
%                 'aperiodic_mode', 'fixed', ...
%                 'verbose', false);
%
% patient_result = PatientResultV2(EEG, channelIndex, 'settings', peSettings, apeSettings)
% PatientResultV2(EEG, channel, prMode, 'settings', peSettings, apeSettings);

function patient_result = PatientResultV2(EEG, channelIndex, varargin)

if any(strcmp('psdMode', varargin))
    patientName = EEG.patientName;
    pxxs = EEG.PSD;
    freqs = EEG.Freqs;
    nChannel = size(pxxs,1);
    patientCog = EEG.cognition;
else
    eegData = EEG.data';
    patientName = strrep(EEG.filename, '.set', '');
    nChannel = size(eegData, 2);
    %% Caculate & Plot Power Spectra Density
    nfft = 512; window = hamming(nfft); overlap = 0;
    [pxxs,freqs] = pwelch(eegData, window, overlap, nfft, EEG.srate);
    freqs = freqs'; pxxs = pxxs';
    patientCog = 'NaN';
end

meanPSD = mean(pxxs);

%% Setting FOOOF-tool with 2 types
if any(strcmp('settings', varargin))
    peSettings = varargin{find(strcmp(varargin,'settings'))+1};
    apeSettings = varargin{find(strcmp(varargin,'settings'))+2};
    settingsFull = struct('peSettings', peSettings, 'apeSettings', apeSettings);
    
    frequencyRangePeriodic =  peSettings.freqsRangePe;
    frequencyRangeAperiodic =  apeSettings.freqsRangeApe;
    peSettings = struct(...
            'peak_width_limits', peSettings.peak_width_limits, ...
            'max_n_peaks', peSettings.max_n_peaks, ... 
            'min_peak_height', peSettings.min_peak_height, ... 
            'peak_threshold', peSettings.peak_threshold, ...
            'aperiodic_mode', peSettings.aperiodic_mode, ...
            'verbose', peSettings.verbose);
    apeSettings = struct(...
            'peak_width_limits', apeSettings.peak_width_limits, ...
            'max_n_peaks', apeSettings.max_n_peaks, ... 
            'min_peak_height', apeSettings.min_peak_height, ... 
            'peak_threshold', apeSettings.peak_threshold, ...
            'aperiodic_mode', apeSettings.aperiodic_mode, ...
            'verbose', apeSettings.verbose); 
    
else   
    % SETTING 4
    peSettings = struct(...
            'peak_width_limits', [1.0, 5], ... %bandwidth
            'max_n_peaks', 1, ... %number of peaks
            'min_peak_height', 0.5, ... %minimum of the power of the peak, over the aperiodic component
            'peak_threshold', 0.0, ...
            'aperiodic_mode', 'fixed', ...
            'verbose', false); 
    apeSettings = struct(...
            'peak_width_limits', [1.0, 5], ... %bandwidth
            'max_n_peaks', 1, ... %number of peaks
            'min_peak_height', 0.5, ... %minimum of the power of the peak, over the aperiodic component
            'peak_threshold', 0.0, ...
            'aperiodic_mode', 'fixed', ...
            'verbose', false);     
    frequencyRangePeriodic = [0.1, 20];
    frequencyRangeAperiodic = [20, 40];
    
    settingsFull = 'default settings';
end

%% Extract Channel Results
%--------------------------------------------------------------------------
channelResultsPe = [];  % Channel Results with "Periodic Setting"
channelResultsApe = []; % Channel Results with "Aperiodic Setting"

if channelIndex ~= 0
    for i = channelIndex
        try
            curResultPe = fooof(freqs, pxxs(i,:), frequencyRangePeriodic, peSettings, true);
            channelResultsPe = [channelResultsPe, curResultPe];
        catch
            disp(['Periodic Settings Error in: <Channel ', num2str(i), ' - Patient ', patientName,'>']);
            disp(exception.message);
            continue;
        end    
        try
            curResultApe = fooof(freqs, pxxs(i,:), frequencyRangeAperiodic, apeSettings, true);
            channelResultsApe = [channelResultsApe, curResultApe];
        catch exception
            disp(['Aperiodic Settings Error in: <Channel ', num2str(i), ' - Patient ', patientName,'>']);
            disp(exception.message);
            continue;
        end
    end
elseif channelIndex == 0 

    for i = 1:19
        try
        % Extract FOOOF result for Periodic Component
        curResultPe = fooof(freqs, pxxs(i,:), frequencyRangePeriodic, peSettings, true);
        channelResultsPe = [channelResultsPe, curResultPe];
        
        catch exception
            disp(['Periodic Settings Error in: <Channel ', num2str(i), ' - Patient ', patientName,'>']);
            disp(exception.message);
            continue;
        end
        
        try    
        % Extract FOOOF result for Aperiodic Component
        curResultApe = fooof(freqs, pxxs(i,:), frequencyRangeAperiodic, apeSettings, true);
        channelResultsApe = [channelResultsApe, curResultApe];
        
        catch exception
            disp(['Aperiodic Settings Error in: <Channel ', num2str(i), ' - Patient ', patientName,'>']);
            disp(exception.message);
            continue;
        end
    end
end

%% Extract All Periodic and All Aperiodic
allPeriodic = []; % [Center Frequency, Power, Bandwidth]
allAperiodic = []; % [Offset, (Knee), Exponent]
numChannelwPeaks = zeros(1,4); % number of channel with 0/1/2/3/4 peaks

for i = 1:size(channelResultsPe,2)
    try
    % Extract All Periodic
    % If there are no peaks, import zeros(1,3)
    if size(channelResultsPe(i).peak_params,1) ~= 0
        cur_pe = channelResultsPe(i).peak_params;
        allPeriodic = [allPeriodic; cur_pe];
    else
        cur_pe = zeros(1,3);
        allPeriodic = [allPeriodic; cur_pe];
    end
    % Extract All Aperiodic
        cur_ape = channelResultsApe(i).aperiodic_params;
        allAperiodic = [allAperiodic; cur_ape];
    
    numChannelwPeaks( 1, size(channelResultsPe(i).peak_params, 1)+1 ) = ...
    numChannelwPeaks( 1, size(channelResultsPe(i).peak_params, 1)+1 ) + 1;

    catch exception
        disp(exception.message);
        continue;
    end
end

allParameters = [allPeriodic, allAperiodic];
meanAllParameters = mean(allParameters);

%% Output:
patient_result = struct(...
    'patientName',patientName,...
    'cognition', patientCog,...
    'powerSpectras', pxxs,...
    'Frequency', freqs, ...
    'meanPSD', meanPSD, ...
    'numChannelwPeaks', numChannelwPeaks, ... 
    'allParameters', allParameters, ...
    'meanAllParameters', meanAllParameters, ...
    'settingsFull', settingsFull);

end



