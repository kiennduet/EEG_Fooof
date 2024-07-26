
close all;
load('E:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\result\Intact_Out07.mat');
load('E:\1_Matlab_function\fooof_mat-main\fooof_mat-main\ex\result\Decre_Out07.mat');

% Step 1: Create dataset
% P [14,15,16,18,19]
% F [1, 2, 4, 5, 6]
% L [3, 8, 9, 13]
% R [7, 11, 12, 17]
% All [1:19]
xI = []; xD = [];
for i =  [14,15,16,18,19]
curI  = Intact_Out(i).All_Parameters;
xI = [xI, curI];

curD  = Decre_Out(i).All_Parameters;
xD = [xD, curD];
end;
X = [xI ; xD];
% csvwrite('X6_P.csv', X)

Y = cell(size(X,1),1);
for i = 1:(size(X,1)/2)
        Y{i} = 'intact' ;
end
for i = (size(X,1)/2 + 1):(size(X,1))
        Y{i} = 'decreased' ;
end

Y_numeric = zeros(size(Y));
Y_numeric(strcmp(Y, 'decreased')) = 1;
Z = [X, Y_numeric];

% Result = TreeBaggerKF(X, Y, 5, 50, 'rng_type', 1);

