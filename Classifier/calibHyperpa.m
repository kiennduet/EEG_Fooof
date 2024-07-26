close all;
load('E:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\result\Intact_Out03.mat');
load('E:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\result\Decre_Out03.mat');

% Step 1: Create dataset
% P [14,15,16,18,19]
% F [1, 2, 4, 5, 6]
% L [3, 8, 9, 13]
% R [7, 11, 12, 17]
% All [1:19]
xI = []; xD = [];
for i =  [14,15,16,18,19]
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

% Define the hyperparameter search space
numTreesValues = [25, 50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600]; % Possible values for the number of trees
numFoldsValues = [5,8,10,12,15,17,20,23,25,27,30]; % Possible values for the number of folds

bestAccuracy = 0;
bestNumTrees = 0;
bestNumFolds = 0;
rng(1);

% Perform grid search to find the best combination of hyperparameters
for numTrees = numTreesValues
    for numFolds = numFoldsValues
        % Perform cross-validation with the current hyperparameters
        cv = cvpartition(size(X, 1), 'KFold', numFolds);
        accuracies = zeros(numFolds, 1);

        for fold = 1:numFolds
            % Get the current training and testing sets
            Xtrain = X(training(cv, fold), :);
            Ytrain = Y(training(cv, fold));
            Xtest = X(test(cv, fold), :);
            Ytest = Y(test(cv, fold));

            % Create and train the Random Forest model using TreeBagger
            randomForestModel = TreeBagger(numTrees, Xtrain, Ytrain, 'Method', 'classification');

            % Make predictions using the trained Random Forest model
            Ypred = predict(randomForestModel, Xtest);

            % Evaluate the model for the current fold
            accuracy = sum(strcmp(Ytest, Ypred)) / numel(Ytest);
            accuracies(fold) = accuracy;
        end

        % Calculate the average accuracy across all folds
        averageAccuracy = mean(accuracies);

        % Check if the current hyperparameters give better performance
        % If yes, update the best hyperparameters and best accuracy
        if averageAccuracy > bestAccuracy
            bestAccuracy = averageAccuracy;
            bestNumTrees = numTrees;
            bestNumFolds = numFolds;
        end
    end
end

% Train the final model using the best hyperparameters
% cvFinal = cvpartition(size(X, 1), 'KFold', bestNumFolds);
% randomForestModelFinal = TreeBagger(bestNumTrees, X(training(cvFinal, bestNumFolds), :), Y(training(cvFinal, bestNumFolds)), 'Method', 'classification');
% 
% % Test the final model on the testing set
% YpredFinal = predict(randomForestModelFinal, X(test(cvFinal, bestNumFolds), :));
% finalAccuracy = sum(strcmp(Y(test(cvFinal, bestNumFolds), :), YpredFinal)) / numel(Y(test(cvFinal,bestNumFolds), :));

disp(['Best Number of Trees: ', num2str(bestNumTrees)]);
disp(['Best Number of Folds: ', num2str(bestNumFolds)]);
% disp(['Final Accuracy: ', num2str(finalAccuracy)]);
