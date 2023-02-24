%File Name: Main_B2_overall_longitude_0123
%Description: This file is for identifying the longitude and latitude of all the 307 observations
%in Building 2 in the validation sample by using a neural network.
%The file calls CNN_Loc_Prediction_1226m for network training and prediction.
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

Loc_train = Data1.location_train_df(Data1.location_train_df(:, 316) == 2, :);
n =length(Loc_train);
rand_index  = randsample(n,n);
Loc_train = Loc_train(rand_index,:);

Loc_test  = Data1.location_test_df(Data1.location_test_df(:, 316) == 2, :);

Loc_train0 = Loc_train(1:307,:);

[m1,m2]= size(Loc_test);


%use bootstrap obtaining CI
repetition = 5000;
Loc_train_sub = zeros (m1,m2-4);
Var_matrix_sub  = zeros (m2-4,m2-4,repetition);
for j=1: repetition
    rand_indexj  = randsample(n,n);
    Loc_train_resample = Loc_train(rand_indexj,:);
    Loc_train_sub = Loc_train_resample(1:m1,:);
    Ind_Loc_train_sub = (Loc_train_sub>-105);
    Var_matrix_sub(:,:,j) = cov(Loc_train_sub(:,1:m2-4)); 
end

for k=1:m2-4
    for l=1:m2-4
        CI_low(k,l) = quantile(Var_matrix_sub(k,l,:),0.000001);
        CI_up(k,l)  = quantile(Var_matrix_sub(k,l,:),0.999999);
    end
end


Var_matrix0 = cov(Loc_train0(:,1:m2-4));
Var_matrix1 = cov(Loc_test(:,1:m2-4));

Ind_CI0 = (Var_matrix0>CI_low)&(Var_matrix0<CI_up);
Ind_CI1 = (Var_matrix1>CI_low)&(Var_matrix1<CI_up);

test_index0 =sum(Ind_CI0==0,1);
test_index1 =sum(Ind_CI1==0,1);

count1 = sum(Loc_test(:,1:m2-4)>-105,1);
test_index1 = test_index1.*(count1<15);

n_trim=1;

%Loc_train  =  Loc_train(Loc_train(:, 315) >= 0,:);
%Loc_test  =  Loc_test(Loc_test(:, 315) >= 2,:);

Loc_train = [Loc_train(:,test_index1<n_trim), Loc_train(:,m2-3:m2)];
Loc_test  = [Loc_test(:,test_index1<n_trim),  Loc_test(:,m2-3:m2)];



[CNN_Loc_Prediction] = CNN_Loc_Prediction_1226(Loc_train, Loc_test);
True_vals =  [Loc_test(:, size(Loc_test,2)-3), Loc_test(:, size(Loc_test,2)-2)];
[Mean(s), Median(s) , STD(s), Min(s), Max(s), Quartiles(s:s+2)] = Regression_Accuracy(CNN_Loc_Prediction, True_vals);



end
