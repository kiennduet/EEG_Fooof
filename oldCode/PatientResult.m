

% patient_result = PatientResult(EEG, channelIndex , varargin)
% EEG: Input data
% channelIndex: Sequence number of input channel ( 0 = All)
% varagin: Choose kind of plot (plotPSD, plotPe, plotApe, plotCLM, plotR2, plotEr)
% Output:
% patient_result = struct(...
%     'patientName',patientName,...
%     'powerSpectras', pxxs,...
%     'Frequency', freqs, ...
%     'allPeriodic', allPeriodic,...
%     'allAperiodic', allAperiodic,...
%     'numChannelwPeaks', numChannelwPeaks, ...
%     'channelResults', channelResults);      

function patient_result = PatientResult(EEG, channelIndex , varargin)
patientName = EEG.filename;
patientName = strrep(patientName, '.set', '');

if isfield(EEG, 'cognition')
    cognition = EEG.cognition;
else
    cognition = 'NA';
end

% Transpose, to make inputs column vectors
data = EEG.data';

nfft = 512;
window = hamming(nfft);
overlap = 0;

% Caculate & Plot Power Spectra Density
[pxxs,freqs] = pwelch(data, window, overlap, nfft, EEG.srate);

% Transpose, to make inputs row vectors
freqs = freqs';

%------------------------------------------------------
% SETTING 4
if isempty(find(strcmp(varargin,'settings')))==0
    settings = varargin{find(strcmp(varargin,'settings'))+1};
else   
    settings = struct(...
            'peak_width_limits', [1.0, 5], ... %bandwidth
            'max_n_peaks', 1, ... %number of peaks
            'min_peak_height', 0.5, ... %minimum of the power of the peak, over the aperiodic component
            'peak_threshold', 0.0, ...
            'aperiodic_mode', 'fixed', ...
            'verbose', false); 
end
        
frequencyRange = [0.1, 45];

channelResults = [];

if channelIndex == 0
    for pxx = pxxs
        curResult = fooof(freqs, pxx', frequencyRange, settings, true);
        channelResults = [channelResults, curResult];
    end
else
    pxxs = pxxs';
    for i = channelIndex
        curResult = fooof(freqs, pxxs(i,:), frequencyRange, settings, true);
        channelResults = [channelResults, curResult];
    end
end

%% Extract All Parameters
%--------------------------------------------------------------------------
allAperiodic = []; % [Offset, (Knee), Exponent]
allPeriodic = []; % [Center Frequency, Power, Bandwidth]
allError = []; % the error of the model, as compared to the original data
allR2 = []; % the r-squared of the model, as compared to the original data
numChannelwPeaks = zeros(1,5); % number of channel with 0/1/2/3/4 peaks

for i = 1:size(channelResults,2)
    cur_ape = channelResults(i).aperiodic_params;
    allAperiodic = [allAperiodic; cur_ape];
    
    % if there are no peaks, import zeros(1,3)
    if size(channelResults(i).peak_params,1) ~= 0
        cur_pe = channelResults(i).peak_params;
        allPeriodic = [allPeriodic; cur_pe];
    else
        cur_pe = zeros(1,3);
        allPeriodic = [allPeriodic; cur_pe];
    end
    
    cur_er = channelResults(i).error;
    allError = [allError; cur_er];
    
    cur_r = channelResults(i).r_squared;
    allR2 = [allR2; cur_r];
    
    numChannelwPeaks( 1, size(channelResults(i).peak_params, 1)+1 ) = ...
       numChannelwPeaks( 1, size(channelResults(i).peak_params, 1)+1 ) + 1;
end

%% Plotting Parameters & Components
% ---------------------------------------------------------------

% Plot Power Spectra Density
if isempty(find(strcmp(varargin,'plotPSD')))==0
    figure; grid on;
    plot(freqs(1:125)', 10*log10(pxxs),'LineWidth',1.2);
    title([patientName, ': ', cognition ]);
    xlabel('Frequency(Hz)');
    ylabel('Log Power Spectra Density');
end


if isempty(find(strcmp(varargin,'plotPe')))==0
    figure;
%     subplot(1,2,1);
    plot((allPeriodic(:, 1)), (allPeriodic(:, 2)), 'ro');
    grid on;
    title('Distribution of Peaks');
    xlabel('Center Frequency');
    ylabel('log(Power)');
end    


% Plot Gaussian Peaks
% if strcmp(plotP, 'True2')    
% %     figure; grid on;
%     for i = 1:size(all_periodic,1)
%         c = all_periodic(i,1);
%         a = all_periodic(i,2);
%         w = all_periodic(i,3);
%     
%         G = a*exp((-(freqs(1:50) - c).^2) ./ (2*w^2));
%         hold on;
%         grid on;
%         plot(G);
%         xlabel('Frequency');
%         ylabel('log(Power)');
%     end
% end
 
%Plot Color Map
if isempty(find(strcmp(varargin,'plotCLM')))==0
    pxxs = pxxs';
    temp = pxxs(:, 10:50);
    figure;
    imagesc(temp);
    colorbar;
end
  
%------------------------------------------------------------
if isempty(find(strcmp(varargin,'plotApe')))==0
    figure; grid on;
    Exponent = size(allAperiodic, 2);
    plot(allAperiodic(:, 1), allAperiodic(:, Exponent), 'mx');
    title('Aperiodic Component');
    xlabel('Offset');
    ylabel('Exponent');
end

if isempty(find(strcmp(varargin,'plotEr')))==0
    figure; grid on;
    plotSpread(allError,'distributionColors','r','yLabel','Error');
    title('Goodness of Fit: Error');
end

if isempty(find(strcmp(varargin,'plotR2')))==0
    figure; grid on;
    plotSpread(allR2,'distributionColors','r','yLabel','R Squared');
    title('Goodness of Fit: R^2');
end




%% Output:
patient_result = struct(...
    'patientName',patientName,...
    'cognition', cognition, ...
    'powerSpectras', pxxs,...
    'Frequency', freqs, ...
    'allPeriodic', allPeriodic,...
    'allAperiodic', allAperiodic,...
    'numChannelwPeaks', numChannelwPeaks, ...
    'channelResults', channelResults);      
end



