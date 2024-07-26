
%{
% pgr = PatientGroupResult(allEEG, varargin)
% - allEEG = group of EEG signal
% - varargin: 
%     1. settings:
%     settings = struct(...
%             'peak_width_limits', [1.0, 5], ... 
%             'max_n_peaks', 1, ...
%             'min_peak_height', 0.5, ...
%             'peak_threshold', 0.0, ...
%             'aperiodic_mode', 'knee', ...
%             'verbose', false); 
%     frequencyRangePeriodic = [0.1, 18];
%     frequencyRangeAperiodic = [18, 30];
% 
%     pgr = PatientGroupResult(allEEG, 'settings', frequencyRangePeriodic, frequencyRangeAperiodic );
% 
%     2. pGT: create Patient Group Result Table, which contains freqs, power
%     spectra density, periodic and aperiodic component, ...
% 
%     pgr = PatientGroupResult(allEEG, 'pGT');
% 
%     3. pCT: create P-value Channel Table, which contains p-Value of the
%     each channel in the 2 groups
% 
%     pgr = PatientGroupResult(allEEG, 'pCT');

%}
function pgr = PatientGroupResult(allEEG, varargin)

    if isempty(find(strcmp(varargin,'dataType')))==0
        dataType = varargin{find(strcmp(varargin,'dataType'))+1};
    end

    numPatients = size(allEEG,2);
    numChannels = 19;
    channelArray = (arrayfun(@(x) ['channel_', num2str(x)], 1:numChannels, 'UniformOutput', false))';
    prMode = 'psdMode';
    
    %% Setting PatientResultV2
    if isempty(find(strcmp(varargin,'settings')))==0
        peSettings = varargin{find(strcmp(varargin,'settings'))+1};
        apeSettings = varargin{find(strcmp(varargin,'settings'))+2};        
%         frequencyRangePeriodic = varargin{find(strcmp(varargin,'settings'))+3};
%         frequencyRangeAperiodic = varargin{find(strcmp(varargin,'settings'))+4};

    else   
        % SETTING 4
        peSettings = struct(...
                'freqsRangePe', [0.1, 20], ...
                'peak_width_limits', [1.0, 5], ... %bandwidth
                'max_n_peaks', 1, ... %number of peaks
                'min_peak_height', 0.5, ... %minimum of the power of the peak, over the aperiodic component
                'peak_threshold', 0.0, ...
                'aperiodic_mode', 'fixed', ...
                'verbose', false); 
        apeSettings = struct(...
                'freqsRangeApe', [20, 40], ...
                'peak_width_limits', [1.0, 5], ... %bandwidth
                'max_n_peaks', 1, ... %number of peaks
                'min_peak_height', 0.5, ... %minimum of the power of the peak, over the aperiodic component
                'peak_threshold', 0.0, ...
                'aperiodic_mode', 'fixed', ...
                'verbose', false); 
%         frequencyRangePeriodic = [0.1, 20];
%         frequencyRangeAperiodic = [20, 40];
    end

    %% Table 1: Patient Group Result (pGT)
    patientGroupTable = [];
    
    if any(strcmp('pGT', varargin))    
        for i = 1 : numPatients
%             try    
                cur = PatientResultV2(allEEG(i) , 0, prMode, 'settings', peSettings, apeSettings);
                patientGroupTable = [patientGroupTable, cur];
%             catch exception
%                 disp(['Error in patient ', num2str(i)]);
%                 disp(exception.message)
%                 continue;
%             end
        end
    end

    

    %% Table 2: Channel Group Result (cGT)
    channelGroupTable = struct('Channel', channelArray,'AllParametersIntact', [], 'AllParametersDecre', []);
    
    if any(strcmp('cGT', varargin))  
        
    for c = 1:numChannels
        peIntact = []; apeIntact = [];
        peDecre = []; apeDecre = [];
        flag = [];
          
        for n = 1 : size(allEEG, 2) % 1 to 60
            if isfield(allEEG(n) , 'cognition') == 0
                disp('Warning: There is no cognition field');
                flag = 1;
                break;    
                
            elseif strcmp(dataType, 'MS')
                if strcmp(allEEG(n).cognition , 'intact')
                    curResult = PatientResultV2(allEEG(n), c , prMode, 'settings', peSettings, apeSettings);
                    peIntact = [peIntact; curResult.allPeriodic];
                    apeIntact = [apeIntact; curResult.allAperiodic]; 
                end    
                if strcmp(allEEG(n).cognition , 'decre')
                    curResult = PatientResultV2(allEEG(n), c, prMode, 'settings', peSettings, apeSettings);
                    peDecre = [peDecre; curResult.allPeriodic];
                    apeDecre = [apeDecre; curResult.allAperiodic]; 
                end
                
            else strcmp(dataType, 'AD')
                if strcmp(allEEG(n).cognition , 'Intact')
                    curResult = PatientResultV2(allEEG(n), c , prMode, 'settings', peSettings, apeSettings);
                    peIntact = [peIntact; curResult.allPeriodic];
                    apeIntact = [apeIntact; curResult.allAperiodic]; 
                end    
                if strcmp(allEEG(n).cognition , 'FTLD')
                    curResult = PatientResultV2(allEEG(n), c, prMode, 'settings', peSettings, apeSettings);
                    peDecre = [peDecre; curResult.allPeriodic];
                    apeDecre = [apeDecre; curResult.allAperiodic]; 
                end
            end           
        end 
        channelGroupTable(c).AllParametersIntact =  [peIntact, apeIntact];
        channelGroupTable(c).AllParametersDecre =  [peDecre, apeDecre];
        
        if flag == 1
            break;
        end
    end
    
    end
    
    %% Table 3: P-value Channel (pCT)
    pValueChannelTable = [];
    if isempty(find(strcmp(varargin,'pCT')))==0
        subset = zeros(numChannels, numPatients/2);
        
        if size(channelGroupTable(1).AllParametersIntact,2) ~= size(channelGroupTable(1).AllParametersDecre,2)
            disp(' Error in pValueChannelTable   ');
            disp(' Please give the same number of patients in 2 groups');
        end
        
        
        nFeatures = size(channelGroupTable(1).AllParametersIntact,2);
        if nFeatures == 6 % 6 Features (includes Knee)
            for i = 1:numChannels
            cur = channelGroupTable(i);
                for j = 1:nFeatures
                    subset(i, 1 + (j-1)*5 ) = mean( cur.AllParametersIntact(:,j) );
                    subset(i, 2 + (j-1)*5 ) = std( cur.AllParametersIntact(:,j) );
                    subset(i, 3 + (j-1)*5 ) = mean( cur.AllParametersDecre(:,j) );
                    subset(i, 4 + (j-1)*5 ) = std( cur.AllParametersDecre(:,j) );
                    [H, P] = ttest2(cur.AllParametersIntact(:,j), cur.AllParametersDecre(:,j));
                    subset(i, 5 + (j-1)*5 ) = P;
                end
            end

            cfIntact=subset(:,1:2) ; cfDecre= subset(:,3:4); pValue1= subset(:,5);
            pwIntact=subset(:,6:7);pwDecre= subset(:,8:9); pValue2=subset(:,10);
            bwIntact=subset(:,11:12); bwDecre= subset(:,13:14); pValue3= subset(:,15);
            osIntact=subset(:,16:17); osDecre= subset(:,18:19); pValue4= subset(:,20);
            kneeIntact=subset(:,21:22);kneeDecre= subset(:,23:24); pValue5= subset(:,25);
            expIntact=subset(:,26:27);expDecre= subset(:,28:29); pValue6= subset(:,30);

            pValueChannelTable = table(channelArray, cfIntact, cfDecre, pValue1,pwIntact,pwDecre,pValue2,bwIntact,bwDecre,pValue3,...
                                       osIntact,osDecre,pValue4,kneeIntact,kneeDecre,pValue5,expIntact,expDecre,pValue6);
        
        elseif nFeatures == 5 % 5 Features (not includes Knee)
            for i = 1:numChannels
            cur = channelGroupTable(i);
                for j = 1:nFeatures
                    subset(i, 1 + (j-1)*5 ) = mean( cur.AllParametersIntact(:,j) );
                    subset(i, 2 + (j-1)*5 ) = std( cur.AllParametersIntact(:,j) );
                    subset(i, 3 + (j-1)*5 ) = mean( cur.AllParametersDecre(:,j) );
                    subset(i, 4 + (j-1)*5 ) = std( cur.AllParametersDecre(:,j) );
                    [H, P] = ttest2(cur.AllParametersIntact(:,j), cur.AllParametersDecre(:,j));
                    subset(i, 5 + (j-1)*5 ) = P;
                end
            end

            cfIntact=subset(:,1:2) ; cfDecre= subset(:,3:4); pValue1= subset(:,5);
            pwIntact=subset(:,6:7);pwDecre= subset(:,8:9); pValue2=subset(:,10);
            bwIntact=subset(:,11:12); bwDecre= subset(:,13:14); pValue3= subset(:,15);
            osIntact=subset(:,16:17); osDecre= subset(:,18:19); pValue4= subset(:,20);
            expIntact=subset(:,21:22);expDecre= subset(:,23:24); pValue5= subset(:,25);

            pValueChannelTable = table(channelArray, cfIntact, cfDecre, pValue1,pwIntact,pwDecre,pValue2,bwIntact,bwDecre,pValue3,...
                                       osIntact,osDecre,pValue4,expIntact,expDecre,pValue5);
            
        end
    end
    
    %% Output
    pgr = struct('patientGroupTable', patientGroupTable, 'channelGroupTable', channelGroupTable, 'pValueChannelTable', pValueChannelTable);
    
end