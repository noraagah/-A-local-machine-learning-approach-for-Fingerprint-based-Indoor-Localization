%File Name: Main_B0__01vs23
%Description: This file is for identifying upper (2,3) or lower (0,1) floor
%of all 536 observations in Building 0 in the validation sample by using a 
%neural network algorithm. This file calls CNN_Floor_Prediction_1211.m
%for network training and prediction..
%Inputs: None
%Outputs: None
%File Created By: Dr. Haiqing Xu

clc;
clear;

% rs = rng;
% rng(rs)

seed = 1000;
jump = 12;



ss=5;

for s =1 : ss
    s

stream = RandStream('mt19937ar','Seed',seed+jump*(s-1));
RandStream.setGlobalStream(stream);

Data1 = Data("trainingData.csv", "validationData.csv");



Floor_train = Data1.location_train_df(Data1.location_train_df(:, 316) == 0, :);
Floor_test  = Data1.location_test_df(Data1.location_test_df(:, 316) == 0, :);
Floor_train(:,315) = (Floor_train(:,315)>1);
Floor_test(:,315)  = (Floor_test(:,315) >1);

n =length(Floor_train);
rand_index  = randsample(n,n);
Floor_train = Floor_train(rand_index,:);



% trimming out signals that does not work
se_train = std(Floor_train(:,1:312));
tau=-1;
Floor_train = [Floor_train(:,se_train>tau), Floor_train(:, 313:316)];
Floor_test  = [Floor_test(:,se_train>tau),  Floor_test(:,313:316)];
se_train    = se_train(1,se_train>tau);


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


histogram(test_index0)
hold on
histogram(test_index1)
hold off


Floor_train = [Floor_train(:,test_index1<50), Floor_train(:,m2-3:m2)];
Floor_test  = [Floor_test(:,test_index1<50),  Floor_test(:,m2-3:m2)];

[CNN_Floor_Prediction] = CNN_Floor_Prediction_1211(Floor_train,Floor_test);
CNN_Accuracy(s) = Classification_Accuracy(CNN_Floor_Prediction, Floor_test(:, size(Floor_test,2)-1))

end
