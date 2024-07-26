


function pgr = PatientGroupResultV3(allEEG, dataType, varargin)

% if isempty(find(strcmp(varargin,'dataType')))==0
%     dataType = varargin{find(strcmp(varargin,'dataType'))+1};
% end

numPatients = size(allEEG,2);
numChannels = 19;
% channelArray = (arrayfun(@(x) ['channel_', num2str(x)], 1:numChannels, 'UniformOutput', false))';
prMode = 'psdMode';

%% Setting PatientResultV3
if isempty(find(strcmp(varargin,'settings')))==0
    peSettings = varargin{find(strcmp(varargin,'settings'))+1};
    apeSettings = varargin{find(strcmp(varargin,'settings'))+2};   
 
else   
    % SETTING 4
    peSettings = struct(...
            'freqsRangePe',[4.0, 16] ,...
            'peak_width_limits', [0.01, 6], ... 
            'max_n_peaks', 1, ... 
            'min_peak_height', 0.01, ...
            'peak_threshold', -1, ...
            'aperiodic_mode', 'fixed', ...
            'verbose', false); 
    apeSettings = struct(...
            'freqsRangeApe',[20, 40] ,...
            'peak_width_limits', [0.01, 6], ... 
            'max_n_peaks', Inf, ... 
            'min_peak_height', 0.02, ...
            'peak_threshold', -10, ...
            'aperiodic_mode', 'fixed', ...
            'verbose', false); 
end
settingsFull = struct('peSettings', peSettings, 'apeSettings', apeSettings);

%% Table 1: Patient Group Result (pGT)
patientGroupTable = [];

if any(strcmp('pGT', varargin))    
    for i = 1 : numPatients
            cur = PatientResultV3(allEEG(i), 0, prMode, 'settings', peSettings, apeSettings);
            patientGroupTable = [patientGroupTable, cur];
    end
end


%% Table 2: Channel Group Result (cGT)
channelGroupTable = struct('AllParametersIntact', [], 'AllParametersAD', [], 'AllParametersFTLD', [],...
                           'AllParametersDecre', []);

if any(strcmp('cGT', varargin))

for c = 1:numChannels
    if isfield(allEEG(1) , 'cognition') == 0
        disp('Warning: There is no cognition field');
        break;  
    end
    if strcmp(dataType, 'AD')
        allIntact = [];
        allAD     = [];
        allFTLD   = [];
        for n = 1 : size(allEEG, 2) % number of patient
            curCognition = allEEG(n).cognition;
            curResult = PatientResultV3(allEEG(n), c, prMode, 'settings', peSettings, apeSettings);
            
            switch curCognition
                case 'Intact'
                    allIntact = [allIntact; curResult.allParameters];
                case 'AD'
                    allAD = [allAD; curResult.allParameters];
                case 'FTLD'
                    allFTLD = [allFTLD; curResult.allParameters];
            end
        end 
        channelGroupTable(c).AllParametersIntact = allIntact;
        channelGroupTable(c).AllParametersAD = allAD;     
        channelGroupTable(c).AllParametersFTLD = allFTLD;   
        
    end
    if strcmp(dataType, 'MS')
        allIntact = []; allNameI = cell(0,1);
        allDecre  = []; allNameD = cell(0,1);
        
        for n = 1 : size(allEEG, 2) % number of patient
            if strcmp(allEEG(n).cognition , 'intact')
                curResult = PatientResultV3(allEEG(n), c, prMode, 'settings', peSettings, apeSettings);
                allIntact = [allIntact; curResult.allParameters];
                allNameI  = [allNameI, curResult.patientName];
            end    
            if strcmp(allEEG(n).cognition , 'decre')
                curResult = PatientResultV3(allEEG(n), c, prMode, 'settings', peSettings, apeSettings);
                allDecre = [allDecre; curResult.allParameters];
                allNameD = [allNameD, curResult.patientName];
            end
        end 
        channelGroupTable(c).AllParametersIntact = allIntact;
        channelGroupTable(c).AllParametersDecre = allDecre; 
        channelGroupTable(c).AllParametersNameI = allNameI;
        channelGroupTable(c).AllParametersNameD = allNameD; 
        
    end    
end

end

%% Output
pgr = struct('patientGroupTable', patientGroupTable, 'channelGroupTable', channelGroupTable, 'settingsFull', settingsFull);
    
end