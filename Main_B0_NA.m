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



Floor_train = Data1.location_train_df(Data1.location_train_df(:, 316) == 2, :);
Floor_test  = Data1.location_test_df(Data1.location_test_df(:, 316) == 2, :);
Floor_train = Floor_train(Floor_train(:, 315) < 2, :);
Floor_test  = Floor_test(Floor_test(:, 315) < 2, :);
Floor_train(:,315) = (Floor_train(:,315)==1);
Floor_test(:,315)  = (Floor_test(:,315) ==1);

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

[CNN_Floor_Prediction] = CNN_Floor_Prediction_1209(Floor_train,Floor_test);
CNN_Accuracy(s) = Classification_Accuracy(CNN_Floor_Prediction, Floor_test(:, size(Floor_test,2)-1))

end

%% 
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


%Using Building 2 Floors 0 & 1
Loc_train = Data1.location_train_df(Data1.location_train_df(:, 316) == 2, :);
Loc_test  = Data1.location_test_df(Data1.location_test_df(:, 316) == 2, :);
Loc_train = Loc_train(Loc_train(:, 315) < 2, :);
Loc_test  = Loc_test(Loc_test(:, 315) < 2, :);
Loc_train(:,315) = (Loc_train(:,315)==1);
Loc_test(:,315)  = (Loc_test(:,315) ==1);

n =length(Loc_train);
rand_index  = randsample(n,n);
Loc_train = Loc_train(rand_index,:);



% trimming out signals that does not work
se_train = std(Loc_train(:,1:312));
tau=-1;
Loc_train = [Loc_train(:,se_train>tau), Loc_train(:, 313:316)];
Loc_test  = [Loc_test(:,se_train>tau),  Loc_test(:,313:316)];
se_train    = se_train(1,se_train>tau);


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


histogram(test_index0)
hold on
histogram(test_index1)
hold off


Loc_train = [Loc_train(:,test_index1<50), Loc_train(:,m2-3:m2)];
Loc_test  = [Loc_test(:,test_index1<50),  Loc_test(:,m2-3:m2)];

[CNN_Longitude_Prediction, CNN_Latitude_Prediction] = CNN_Loc_Prediction_1209(Loc_train,Loc_test);

%[Mean, Median, STD, Min, Max, Quartiles] = 
[Mean(s), Median(s), STD(s), Min(s), Max(s), Quartiles(s:s+2)] = Regression_Accuracy([CNN_Longitude_Prediction, CNN_Latitude_Prediction], [Loc_test(:, size(Loc_test,2)-3), Loc_test(:, size(Loc_test,2)-2)])


end


