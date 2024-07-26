
%{
Steps:
    1. Import all .set files from the Decreased Cognition Group.
    2. Import all .set files from the Intact Cognition Group.
    3. Save the result and send it to me
%}

filename = readtable('subject_labels.csv');
filename = table2array(filename);
filepath = 'the_path_to_your_directory_with_.set_files';

allEEG = createEEGGroup(filename, filepath);
psdG = psdGroup(allEEG);

%% Save to the path
fullPath = fullfile('The_path_where_you_want_to_save_the_result_file', 'psdGroup');
save(fullPath, 'psdG');

% msLabels = readtable('subject_labels_312.csv');
% msLabels.age = cellstr(num2str(msLabels.age));
% msLabels.onset = cellstr(num2str(msLabels.onset));
% msLabels.pasat3 = cellstr(num2str(msLabels.pasat3));
% msLabels.pasat2 = cellstr(num2str(msLabels.pasat2));
% msLabels.RAO = cellstr(num2str(msLabels.RAO));
% msLabels.schooling = cellstr(num2str(msLabels.schooling));
% msLabels = table2array(msLabels);
% 
% 
% msEEG = struct('patientName', msLabels(:,1), 'Age', msLabels(:,2), 'Onset', msLabels(:,3),...
%                'Sex', msLabels(:,4), 'PASAT3', msLabels(:,5), 'PASAT2', msLabels(:,6), ...
%                'RAO', msLabels(:,7), 'Schooling', msLabels(:,8));
% 
% 
% for i = 1: size(psdG,2)
%     msEEG(i).Freqs = psdG(i).Freqs;
%     msEEG(i).PSD   = psdG(i).PSD;
%     
%     switch msEEG(i).RAO
%         case {'  0', '  1', '  2'}
%             msEEG(i).cognition = 'decre';
%         case {'  3', '  4'} 
%             msEEG(i).cognition = 'intact';
%         case 'NaN'
%             msEEG(i).cognition = 'NaN';
%     end
% 
% end
% msEEG = msEEG';

%%
% iAge = []; dAge = [];
% iMale = []; dMale = [];
% iFemale = []; dFemale = []; 
% iAgeO = []; dAgeO = [];
% for i = [1:312]
%     
%     age = str2num(msEEG(i).Age);
%     sex = msEEG(i).Sex;
%     ageOnset = str2num(msEEG(i).Onset);
% %     if ageOnset < 0 || age < 0
% %         break;
% %     end
%     if strcmp(msEEG(i).cognition , 'intact')
%         iAge = [iAge ; age];
%         iAgeO = [iAgeO ; ageOnset];
%         if strcmp(sex, 'M')
%             iMale = [iMale; sex];
%         else
%             iFemale = [iFemale; sex];
%         end
%     end
%     
%     if strcmp(msEEG(i).cognition , 'decre')
%         dAge = [dAge ; age];
%         dAgeO = [dAgeO ; ageOnset];
%         if strcmp(sex, 'M')
%             dMale = [dMale; sex];
%         else
%             dFemale = [dFemale; sex];
%         end
%     end
% end
