
%{
% Example
% Result = TreeBaggerKF(X, Y, 10, 100, 'rng_type', 'default');
%}

function Result = TreeBaggerKF(X, Y, numFolds, numTrees, varargin)

% Get additional input parameters (varargin)
if isempty(find(strcmp(varargin,'rng_type')))==0
    rng_type = varargin{find(strcmp(varargin,'rng_type'))+1};
    rng(rng_type);
end

%% Split the data into training and testing sets
cv = cvpartition(size(X, 1), 'KFold', numFolds);

% Initialize an array to store the average feature importance scores
numFeatures = size(X, 2);
averageFeatureImportance = zeros(numFeatures, 1);

% Initialize variables to store confusion matrix values
numClasses = numel(unique(Y));
confusionMatrix = zeros(numClasses, numClasses);

% Initialize an array to store the accuracy for each fold
accuracies = zeros(numFolds, 1);

%% Loop for Calculate
for fold = 1:numFolds
    % Get the current training and testing sets
    Xtrain = X(training(cv, fold), :);
    Ytrain = Y(training(cv, fold));
    Xtest = X(test(cv, fold), :);
    Ytest = Y(test(cv, fold));

    % Create and train the Random Forest model using TreeBagger

    randomForestModel = TreeBagger(numTrees, Xtrain, Ytrain, 'Method', 'classification', 'OOBPredictorImportance', 'on');
%     randomForestModel = fitensemble(Xtrain, Ytrain, 'AdaBoostM1', 100, 'Tree');
%     randomForestModel = fitcensemble(Xtrain, Ytrain, 'Method', 'Bag', 'Learners', 'Tree', 'NLearn', 100);
    
    % Accumulate feature importance scores for the current fold
%     foldFeatureImportance = randomForestModel.OOBPermutedPredictorDeltaError;
%     averageFeatureImportance = averageFeatureImportance + foldFeatureImportance';
    
    % Make predictions using the trained Random Forest model
    Ypred = predict(randomForestModel, Xtest);

    % Evaluate the model for the current fold
    accuracy = sum(strcmp(Ytest, Ypred)) / numel(Ytest);
    accuracies(fold) = accuracy;
    
    % Calculate confusion matrix for the current fold
%     currentConfusion = confusionmat(Ytest, Ypred);
%     confusionMatrix = confusionMatrix + currentConfusion;
    
%     disp(accuracy);
    
end

% Calculate the average accuracy across all folds
averageAccuracy = mean(accuracies);

% Calculate the average feature importance scores across all folds
averageFeatureImportance = averageFeatureImportance / numFolds;

%% Display Average accuracy
% disp(['Average Accuracy: ', num2str(averageAccuracy)])
fprintf('\nAverage Accuracy: %.4f \n', (averageAccuracy))

% Display feature importance scores
[sortedImportance, featureIndices] = sort(averageFeatureImportance, 'descend');
% fprintf('Feature Importance Scores:\n');
% for i = 1:numFeatures
%     fprintf('Feature %d: %.4f\n', featureIndices(i), sortedImportance(i));
% end

% Display confusion matrix
% fprintf('\n Confusion Matrix: \n');
% disp(confusionMatrix);


Result = struct('averageAccuracy', averageAccuracy, 'accuracies', accuracies, 'featureIndices', featureIndices,'sortedImportance', sortedImportance);

end