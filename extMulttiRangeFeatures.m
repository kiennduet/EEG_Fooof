%% Extract Features

featuresX = zeros(30, 307, 95); %adjust

pgr_cell = cell(1, 30);

for i = 1:30 %adjuts
    pgr_index = ['pgrMS_', num2str(i), '.mat']; %adjuts
    
    file_path = '/home/kiennd/Documents/2_Works/EEG_analysis/data/PGR_Result/PGR_MS/'; %adjust
    file_name = [file_path, pgr_index]; load(file_name);
    
    variable_name = ['pgrMS_', num2str(i)]; %adjust

    j=i; 
    pgr_cell{j} = eval(variable_name);
    
    pgr = pgr_cell{j}.channelGroupTable;
     
    featuresX(j,:,:) = ExtractFeaturesF(pgr, 'MS', [1:19], [1:5]); %adjust
end

file_path = '/home/kiennd/Documents/2_Works/EEG_analysis/data/PGR_Result/PGR_MS';
file_name = 'MS307.mat'; %adjust
save(fullfile(file_path, file_name), 'featuresX');

clear('pgrMS_*'); %adjust

