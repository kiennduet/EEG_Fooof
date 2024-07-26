
%% Step 1: Import EEG data
% allEEG = createEEGGroup();
load('D:\1_Work\4_Work_2024\Data\msEEG02.mat');
% load('D:\1_Work\4_Work_2024\Data\adEEG02.mat');

allEEG = msEEG02;
dataType = 'MS';

%% Step 2: Extract Parameters, Chart and Table
peSettings = struct(...
                'freqsRangePe',[4.0, 16] ,...
                'peak_width_limits', [0.05, 20], ... 
                'max_n_peaks', 1, ... 
                'min_peak_height', 0.01, ...
                'peak_threshold', -5, ...
                'aperiodic_mode', 'fixed', ...
                'verbose', false); 

for i = [0.5, 1:30]
apeSettings = struct(...
                'freqsRangeApe', [i, 40], ...
                'peak_width_limits', [0.05, 20], ...
                'max_n_peaks', Inf, ...
                'min_peak_height', 0.1, ...
                'peak_threshold', -10, ...
                'aperiodic_mode', 'fixed', ...
                'verbose', false);            

pgr = PatientGroupResultV2(allEEG, dataType, 'cGT', 'settings', peSettings, apeSettings);

if i == 0.5
    i = 0;
end 

% Need to adjust
pgr_index = ['pgrMS_', num2str(i)]; eval([pgr_index, ' = pgr;']);

file_path = 'C:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\PGR_Result\PGR_MS';
file_name = [pgr_index, '.mat'];
save(fullfile(file_path, file_name), pgr_index);

end

clear('pgrMS_*');





