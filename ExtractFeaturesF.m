

%{
% exf = ExtractFeatures(channelGroupTable, channelIndex)
% Region:
%     P [14,15,16,18,19]
%     F [1, 2, 4, 5, 6]
%     L [3, 8, 9, 13]
%     R [7, 11, 12, 17]
%     All [1:19]
% 
% Example:
%     features = ExtractFeaturesF(pgr.channelGroupTable, 'AD', [1:19], [1:5])
%     features = ExtractFeaturesF(pgr.channelGroupTable, 'AD', [1:19], [1:5], 'writeCSV')
%}

function features = ExtractFeaturesF(channelGroupTable, dataType, channelIndex, featureIndex, varargin)
totalF = size(channelIndex,2) * size(featureIndex,2);
fprintf('Total Features: %d \n', totalF);
cgt = channelGroupTable;

if strcmp(dataType,'MS')
    xIntact = []; xDecre = [];
    for i =  channelIndex
        curI = [];
        for j = featureIndex
            cur = cgt(i).AllParametersIntact(:,j);
            curI = [curI, cur];
        end
        xIntact = [xIntact, curI];

        curD = [];
        for j = featureIndex
            cur  = cgt(i).AllParametersDecre(:,j);
            curD = [curD, cur];
        end
        xDecre = [xDecre, curD];
    end;
    X = [xIntact ; xDecre];

    intactCell = repmat({'intact'}, size(xIntact,1), 1);
    decreCell = repmat({'decre'}, size(xDecre,1), 1);
    Y = [intactCell; decreCell];
    % Create Y numeric
    Y_numeric = zeros(size(Y));
    Y_numeric(strcmp(Y, 'decre')) = 1;

elseif strcmp(dataType,'AD')
    xIntact = []; xAD = []; xFTLD = [];
    for i =  channelIndex
        curI = [];
        for j = featureIndex
            cur = cgt(i).AllParametersIntact(:,j);
            curI = [curI, cur];
        end
        xIntact = [xIntact, curI];

        curAD = [];
        for j = featureIndex
            cur  = cgt(i).AllParametersAD(:,j);
            curAD = [curAD, cur];
        end
        xAD = [xAD, curAD];
        
        curFTLD = [];
        for j = featureIndex
            cur  = cgt(i).AllParametersFTLD(:,j);
            curFTLD = [curFTLD, cur];
        end
        xFTLD = [xFTLD, curFTLD];
    end
    X = [xIntact ; xAD ; xFTLD ];
    
    % Create Y
    intactCell = repmat({'intact'}, size(xIntact,1), 1);
    adCell = repmat({'ad'}, size(xAD,1), 1);
    ftldCell = repmat({'ftld'}, size(xFTLD,1), 1);
    
    Y = [intactCell; adCell ; ftldCell];
    
    % Create Y numeric
    Y_numeric = zeros(size(Y,1), 1); 
    for i = 1:numel(Y)
        if strcmp(Y{i}, 'intact')
            Y_numeric(i) = 1;
        elseif strcmp(Y{i}, 'ad')
            Y_numeric(i) = 2;
        elseif strcmp(Y{i}, 'ftld')
            Y_numeric(i) = 3;
        end
    end
    
end

%% Use PCA
if isempty(find(strcmp(varargin, 'usePCA'))) == 0
    X = pcaFunction(X);
end

features = X;


%% Use PCA
if isempty(find(strcmp(varargin, 'writeCSV'))) == 0
    if strcmp(dataType,'AD')
        % 1:40 , 41:95 , 96:146
%         range = [41:95, 96:146];
        csvwrite('C:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\MachineLearningPython\X146.csv', X(: , :));
        csvwrite('C:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\MachineLearningPython\Y146.csv', Y_numeric);

    elseif strcmp(dataType,'MS')
        csvwrite('C:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\MachineLearningPython\X307.csv', X);
        csvwrite('C:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\MachineLearningPython\Y307.csv', Y_numeric);
        disp(size(X));
    end
end


end