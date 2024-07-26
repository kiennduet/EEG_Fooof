

for i = 1:30
    %Load file       
    pgr_index = ['pgrMS_', num2str(i), '.mat'];
    file_path = 'C:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\PGR_Result\PGR_MS\';
    file_name = [file_path, pgr_index];
    load(file_name);

    %Creat variable
    variable_name = ['pgrMS_', num2str(i)];
    pgrAD_cell{i} = eval(variable_name);
    
    for nChannel = 1:19
        for nPatient = 1:129
            osE = pgrAD_cell{i}.channelGroupTable(nChannel).AllParametersDecre(nPatient,4);
            expE = pgrAD_cell{i}.channelGroupTable(nChannel).AllParametersDecre(nPatient,5);
            if osE == 0 && expE == 0
                disp(['Error in channel ', num2str(nChannel),' patient ', num2str(nPatient), ...
                    ' pgr from ', num2str(i) ' Hz']);
                break;
            end
        end
    end
end

% MS
% Decre
% Error in channel 18 patient 80 pgr from 4 Hz - MS258
% Error in channel 16 patient 113 pgr from 7 Hz - MS291
% Error in channel 9 patient 26 pgr from 11 Hz - MS204
% Error in channel 13 patient 66 pgr from 0.5 Hz - MS244
% Intact
% Error in channel 5 patient 77 pgr from 1 Hz - MS107
