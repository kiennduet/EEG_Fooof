close all;
load('E:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\result\Intact_Out04.mat');
load('E:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\result\Decre_Out04.mat');

%% Step 1: Create dataset
xI = []; xD = [];
% P [14,15,16,18,19]
% F [1, 2, 4, 5, 6]
% L [3, 8, 9, 13]
% R [7, 11, 12, 17]
% All [1:19]
for i =  [14,15,16,18,19]
curI  = Intact_Out(i).All_Parameters;
xI = [xI, curI];

curD  = Decre_Out(i).All_Parameters;
xD = [xD, curD];
end;
X = [xI ; xD];

Y = cell(size(X,1),1);
for i = 1:(size(X,1)/2)
        Y{i} = 'intact';
end
for i = (size(X,1)/2 + 1):(size(X,1))
        Y{i} = 'decreased';
end

% Create Z
Y_numeric = zeros(size(Y));
Y_numeric(strcmp(Y, 'decreased')) = 1;
Z = [X, Y_numeric];

%% Step 2: Split the data into training and testing sets
rng('default'); % For reproducibility
cv = cvpartition(size(X, 1), 'HoldOut', 0.3);
Xtrain = X(training(cv), :);
Ytrain = Y(training(cv));
Xtest = X(test(cv), :);
Ytest = Y(test(cv));

%% Step 3 and 4: Create and train the Random Forest model using TreeBagger
numTrees = 500;
randomForestModel = TreeBagger(numTrees, Xtrain, Ytrain, 'Method', 'classification', 'OOBPrediction','on');

% Plot Example
% plot(oobError(randomForestModel))
% xlabel('number of grown trees')
% ylabel('out-of-bag classification error')
% view(randomForestModel.Trees{1}, 'mode', 'graph');

%% Step 5: Make predictions using the trained Random Forest model
Ypred = predict(randomForestModel, Xtest);
                               
%% Evaluate the model (you can use different metrics based on your problem)
accuracy = sum(strcmp(Ytest, Ypred)) / numel(Ytest);
disp(['Accuracy: ', num2str(accuracy)]);
