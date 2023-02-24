%File Name: Main_B0_longitude_0118
%Description: This file is for identifying the longitude and latitude of all the 536 observations
%in Building 0 in the validation sample by: (1) using a neural network to determine 
%whether observations belong to up/lower level floors and then 
%(2) using a neural network to identify longitude and latitude.
%(1) calls CNN_Floor_Prediction_1211.m and
%(2) calls CNN_Loc_Prediction_1226.m for network training and prediction.
%Inputs: None
%Outputs: None
%File Created By: Dr. Haiqing Xu

clc;
clear;

seed = 1048;
jump = 12;

ss=5;

for s =1 : ss
    s

stream = RandStream('mt19937ar','Seed',seed+jump*(s-1));
RandStream.setGlobalStream(stream);

Data1 = Data("trainingData.csv", "validationData.csv");

Loc_train = Data1.location_train_df(Data1.location_train_df(:, 316) == 0, :);
n =length(Loc_train);
rand_index  = randsample(n,n);
Loc_train = Loc_train(rand_index,:);



Loc_train_20 = Loc_train(Loc_train(:, 315) < 3, :);
Loc_train_21 = Loc_train(Loc_train(:, 315) >= 1, :);

Floor_train = Loc_train;
Floor_train(:,315) = (Floor_train(:,315)>=2);

Floor_test  = Data1.location_test_df(Data1.location_test_df(:, 316) == 0, :);
Floor_test(:,315)  = (Floor_test(:,315)>=2);


Floor_train0 = Floor_train(1:307,:);

[m1,m2]= size(Floor_test);


%use bootstrap obtaining CI
repetition = 5000;
Floor_train_sub = zeros (m1,m2-4);
Var_matrix_sub  = zeros (m2-4,m2-4,repetition);
for j=1: repetition
    rand_indexj  = randsample(n,n);
    Floor_train_resample = Floor_train(rand_indexj,:);
    Floor_train_sub = Floor_train_resample(1:m1,:);
    Ind_Floor_train_sub = (Floor_train_sub>-105);
    Var_matrix_sub(:,:,j) = cov(Floor_train_sub(:,1:m2-4)); 
end

for k=1:m2-4
    for l=1:m2-4
        CI_low(k,l) = quantile(Var_matrix_sub(k,l,:),0.000001);
        CI_up(k,l)  = quantile(Var_matrix_sub(k,l,:),0.999999);
    end
end


Var_matrix0 = cov(Floor_train0(:,1:m2-4));
Var_matrix1 = cov(Floor_test(:,1:m2-4));

Ind_CI0 = (Var_matrix0>CI_low)&(Var_matrix0<CI_up);
Ind_CI1 = (Var_matrix1>CI_low)&(Var_matrix1<CI_up);

test_index0 =sum(Ind_CI0==0,1);
test_index1 =sum(Ind_CI1==0,1);

count1 = sum(Floor_test(:,1:m2-4)>-105,1);
test_index1 = test_index1.*(count1<15);

n_trim=1;

Floor_train = [Floor_train(:,test_index1<n_trim), Floor_train(:,m2-3:m2)];
Floor_test  = [Floor_test(:,test_index1<n_trim),  Floor_test(:,m2-3:m2)];
Loc_train_21= [Loc_train_21(:,test_index1<n_trim),  Loc_train_21(:,m2-3:m2)];
Loc_train_20= [Loc_train_20(:,test_index1<n_trim),  Loc_train_20(:,m2-3:m2)];

[CNN_Floor_Prediction] = CNN_Floor_Prediction_1211(Floor_train,Floor_test);
CNN_Accuracy(s) = Classification_Accuracy(CNN_Floor_Prediction, Floor_test(:, size(Floor_test,2)-1));

% save("Workspace_1226");
% 
% 
% load("Workspace_1226");


Loc_test_21  = Floor_test(CNN_Floor_Prediction==1,:);
Loc_test_20  = Floor_test(CNN_Floor_Prediction==0,:);


[CNN_Loc_Prediction_20] = CNN_Loc_Prediction_1226(Loc_train_20, Loc_test_20);
[CNN_Loc_Prediction_21] = CNN_Loc_Prediction_1226(Loc_train_21, Loc_test_21);

CNN_Loc_Prediction_2 = [CNN_Loc_Prediction_21;CNN_Loc_Prediction_20];
%CNN_Loc_Prediction_2 = [CNN_Loc_Prediction_2(:, 1), -1*CNN_Loc_Prediction_2(:, 2)]; 
Loc_test_2 = [Loc_test_21;Loc_test_20];
True_vals =  [Loc_test_2(:, size(Loc_test_2,2)-3), Loc_test_2(:, size(Loc_test_2,2)-2)];
[Mean(s), Median(s) , STD(s), Min(s), Max(s), Quartiles(s:s+2)] = Regression_Accuracy(CNN_Loc_Prediction_2, True_vals);

True_vals_20 =  [Loc_test_20(:, size(Loc_test_2,2)-3), Loc_test_20(:, size(Loc_test_2,2)-2)];
[Mean20(s), Median20(s) , STD20(s), Min20(s), Max20(s), Quartiles20(s:s+2)] = Regression_Accuracy(CNN_Loc_Prediction_20, True_vals_20);

True_vals_21 =  [Loc_test_21(:, size(Loc_test_2,2)-3), Loc_test_21(:, size(Loc_test_2,2)-2)];
[Mean21(s), Median21(s) , STD21(s), Min21(s), Max21(s), Quartiles21(s:s+2)] = Regression_Accuracy(CNN_Loc_Prediction_21, True_vals_21);



end
