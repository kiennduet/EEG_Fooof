
close all;
load('E:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\result\Intact_Out03.mat');
load('E:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\result\Decre_Out03.mat');

% Step 1: Create dataset
xI = []; xD = [];
% P [14,15,16,18,19] % F [1, 2, 4, 5, 6]
% L [3, 8, 9, 13] % R [7, 11, 12, 17]
% All [1:19]
for i =  [1:19]
curI  = Intact_Out(i).All_Parameters;
xI = [xI; curI];

curD  = Decre_Out(i).All_Parameters;
xD = [xD; curD];
end;
X = [xI ; xD];

Y = cell(size(X,1),1);
for i = 1:(size(X,1)/2)
        Y{i} = 'intact';
end
for i = (size(X,1)/2 + 1):(size(X,1))
        Y{i} = 'decreased';
end

% Perform Leave-One-Out Cross-Validation
numDataPoints = size(X, 1);
accuracies = zeros(numDataPoints, 1);

for i = 1:numDataPoints
    % Get the current training and testing sets (leave out data point i)
    Xtrain = X([1:i-1, i+1:end], :);
    Ytrain = Y([1:i-1, i+1:end]);
    Xtest = X(i, :);
    Ytest = Y(i);

    % Create and train the Random Forest model using TreeBagger
    numTrees = 500; % You can adjust this number based on your needs
    randomForestModel = TreeBagger(numTrees, Xtrain, Ytrain, 'Method', 'classification');

    % Make predictions using the trained Random Forest model
    Ypred = predict(randomForestModel, Xtest);

    % Evaluate the model for the current data point
    accuracy = strcmp(Ytest, Ypred);
    accuracies(i) = accuracy;
end

% Calculate the average accuracy across all data points
averageAccuracy = mean(accuracies);

disp(['Average Accuracy: ', num2str(averageAccuracy)]);