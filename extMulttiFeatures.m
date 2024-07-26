%% Extract Features

featuresX = zeros(30,91,38); %adjust

pgr_cell = cell(1, 30);

for i = 1:30

pgr_index = ['pgrFT_', num2str(i), '.mat']; %adjuts

file_path = 'C:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\PGR_Result\PGR_FT\'; %adjust
file_name = [file_path, pgr_index]; load(file_name);

variable_name = ['pgrFT_', num2str(i)]; %adjust

j=i;
pgr_cell{j} = eval(variable_name);

pgr = pgr_cell{j}.channelGroupTable;
 
featuresX(j,:,:) = ExtractFeaturesF(pgr, 'AD', [1:19], [4,5]);
end

file_path = 'C:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\MachineLearningPython';
file_name = 'FT91.mat'; %adjust
save(fullfile(file_path, file_name), 'featuresX');

clear('pgrFT_*');

%% Calculated Sample Size
% for i = [1]
%     disp(['Aperiodic Fitting: ', num2str(i), '-40 Hz']);
%     result = featuresX(i,:,:);
%     result = squeeze(result);
% 
%     HC = result(1:40,:);
%     AD = result(41:95,:);
% 
%     expHC = []; expAD = [];
%     for i = 2:2:38
%         expHC = [expHC, HC(i)];
%         expAD = [expAD, AD(i)];
%     end
% 
%     disp(['mean exp HC: ',num2str(mean(expHC)) ]);
%     disp(['mean exp AD: ',num2str(mean(expAD)) ]);
% 
%     disp(['Var exp HC: ',num2str(var(expHC)) ]);
%     disp(['Var exp AD: ',num2str(var(expAD)) ]);
% end
% 
% 
% % Given values
% S1_sq = 0.4807;
% S2_sq = 0.29847;
% n1 = 40;
% n2 = 55;
% alpha = 0.05; % Significance level
% beta = 0.2;   % Power
% 
% % Calculate mean estimated variance (s^2)
% s_sq = ((n1 - 1) * S1_sq + (n2 - 1) * S2_sq) / (n1 + n2 - 2);
% 
% % Values associated with type I and type II errors
% t_alpha = norminv(1 - alpha/2);
% t_beta = norminv(1 - beta);
% 
% % Calculate final sample size
% x1_bar = 1.1737; % This is just a placeholder, as the actual values are not provided
% x2_bar = 1.7105; % Similarly, this is a placeholder
% 
% final_sample_size = (2 * s_sq * (t_alpha + t_beta)^2) / ((x1_bar - x2_bar)^2);
% 
% % Display the result
% disp(['The final sample size is: ', num2str(final_sample_size)]);
% 
% % Range of sample sizes
% sample_sizes = 20:5:60;
% 
% % Initialize arrays to store results
% powers = zeros(size(sample_sizes));
% 
% % Loop through different sample sizes
% for i = 1:length(sample_sizes)
%     n1 = sample_sizes(i);
%     n2 = sample_sizes(i);
%     s_sq = ((n1 - 1) * S1_sq + (n2 - 1) * S2_sq) / (n1 + n2 - 2);
%     power = 1 - ncx2cdf(final_sample_size * s_sq / S1_sq, n1 + n2 - 2, (t_alpha + t_beta)^2);
%     powers(i) = power;
% end
% 
% close all;
% h = figure; h.Color = [1,1,1];
% plot(sample_sizes, powers, '-');
% title(''); xlabel('Sample Size[n]'); ylabel('Power[%]');
% grid on; grid minor;
% 
% effectSize_d = abs((mean(expHC) - mean(expAD))) / sqrt((std(expHC)^2 + std(expAD)^2) / 2);
% disp(['Effect Size: ', num2str(effectSize_d)]);

