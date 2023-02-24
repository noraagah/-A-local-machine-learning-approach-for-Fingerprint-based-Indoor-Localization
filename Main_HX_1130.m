%File name: Main
%Original Python code: building2binarysearch_IV 
%Section: None
%Research advisor: Brian Evans
%Description: This file calls all methods and functions related to the indoor
%location project as well as calculates all
%Inputs: None
%Outputs: None
%First created: 8/13/21
% %Last Modified: 11/9/22
%File Created By: Nora Agah; modified by hx

clc;
clear;



Data1 = Data("trainingData.csv", "validationData.csv");

Floor_train_overallsample = Data1.location_train_df(Data1.location_train_df(:, 316) == 1, :);
Floor_test_overallsample  = Data1.location_test_df(Data1.location_test_df(:, 316) == 1, :);

N =length(Floor_train_overallsample);
rand_index = randsample(N,N);
Floor_train_overallsample =Floor_train_overallsample(rand_index,:);
rand_index = randsample(N,N);
Floor_train_overallsample =Floor_train_overallsample(rand_index,:);


Std_Train = std(Floor_train_overallsample(:,1:312));
Std_Test  = std(Floor_test_overallsample(:,1:312));
Std_prod  = Std_Train.*Std_Test;
%Std_prod  = ones(1,312);
% 
Floor_Train = [Floor_train_overallsample(:, Std_prod>0.001), Floor_train_overallsample(:, 313:316)];
Floor_Test  = [Floor_test_overallsample(:, Std_prod>0.001), Floor_test_overallsample(:, 313:316)];



% N_train=4500;
%Floor_Train_Temp = Floor_train_overallsample (1:N_train, :);
%Floor_Test_Temp  = Floor_train_overallsample (N_train+1:N, :);
% 
% Floor_Train  = [Floor_train_overallsample(1:4500, Std_prod>0), Floor_train_overallsample(1:4500, 313:316)];
% Floor_Test  =  [Floor_train_overallsample(4501:5196, Std_prod>0), Floor_train_overallsample(4501:5196, 313:316)];

[n,m]= size(Floor_Train);
 

% 
% %%%%% Step 1 %%%%%
% 
% %Construct Wifi Access Points
Num_Floors = 5;
Num_Points = (50)^2;
%Hmap_matrix_size = [146,1,1];
%Hmap_Num_Points = Hmap_matrix_size(1)*Hmap_matrix_size(2)*Hmap_matrix_size(3);

Location_Matrix = ones(Num_Points*5, 3);



max_lo = -7300;
min_lo = -7700;

max_la = 4865020;
min_la = 4864720;

hmap = ones(2,2);

hmap(1,1) = -7700;
hmap(1,2) = 4864720;
hmap(2,1) = -7300;
hmap(2,2) = 4865020;



hmap_size = [12 13];






%Building 1%Longitude from min_lo to max_lo
%Latitude from 4864880 to 4865020
Lat_Increms  = (max_lo-min_lo)/sqrt(Num_Points);
Long_Increms = (max_la-min_la)/sqrt(Num_Points);

% Hmap_Lat_Increms  = (hmax_lo-hmin_lo)/Hmap_matrix_size(1);
% Hmap_Long_Increms = (hmax_la-hmin_la)/Hmap_matrix_size(2);
% 
% Hmap_Lat_Increms  = round(Hmap_Lat_Increms);
% Hmap_Long_Increms = round(Hmap_Long_Increms);


Longitude = min_la;
for j = 1:sqrt(Num_Points)
    Latitude = min_lo;
    for k = 1:sqrt(Num_Points)
        Location_Matrix((j-1)*sqrt(Num_Points)+k, 1) = Latitude;
        Location_Matrix((j-1)*sqrt(Num_Points)+k, 2) = Longitude;
        Location_Matrix((j-1)*sqrt(Num_Points)+k, 3) = 0;
        Latitude = Latitude + Lat_Increms;
    end
    Longitude = Longitude + Long_Increms;
end

for i=1:3;
    Location_Matrix(i*Num_Points+1:(i+1)*Num_Points,1:2)=Location_Matrix(1:Num_Points,1:2);
    Location_Matrix(i*Num_Points+1:(i+1)*Num_Points,3)=i;
end

Hmap_Location_Matrix = zeros(hmap_size(1)*hmap_size(2),3);


    for k = 1: hmap_size(2)
       Hmap_Location_Matrix(k,1)=k;
       Hmap_Location_Matrix(k,2)=1;
    end
    for j = 2:hmap_size(1)
       
        Hmap_Location_Matrix(1+(j-1)*hmap_size(2):j*hmap_size(2),1)=Hmap_Location_Matrix(1+(j-2)*hmap_size(2):(j-1)*hmap_size(2),1);
        Hmap_Location_Matrix(1+(j-1)*hmap_size(2):j*hmap_size(2),2)=j;
    end



% Hmap_Longitude = hmin_la;
% for j = 1:Hmap_matrix_size(1)
%     Hmap_Latitude = hmin_lo;
%     for k = 1:Hmap_matrix_size(2)
%         Hmap_Location_Matrix((j-1)*Hmap_matrix_size(2)+k, 1) = Hmap_Latitude;
%         Hmap_Location_Matrix((j-1)*Hmap_matrix_size(2)+k, 2) = Hmap_Longitude;
%         Hmap_Location_Matrix((j-1)*Hmap_matrix_size(2)+k, 3) = 0;
%         Hmap_Latitude = Hmap_Latitude + Hmap_Lat_Increms;
%     end
%     Hmap_Longitude = Hmap_Longitude + Hmap_Long_Increms;
% end

% for i=1:3
%     Hmap_Location_Matrix(i*Hmap_Num_Points+1:(i+1)*Hmap_Num_Points,1:2)=Hmap_Location_Matrix(1:Hmap_Num_Points,1:2);
%     Hmap_Location_Matrix(i*Hmap_Num_Points+1:(i+1)*Hmap_Num_Points,3)=i;
% end
% 


%Generate Predictions of RSSIs give a cell phone at a give location
[RSSI_Predictions] = RSSI_Prediction_Vectorized_1130(Data1, Location_Matrix);
%RSSI_Predictions = [RSSI_Predictions(:, Std_Train>0), Floor_train_overallsample(:, 313:315)];


[WAP_Predictions] = WAP_Locating_HX1130(RSSI_Predictions);
 WAP_Predictions  = WAP_Predictions(Std_prod'>0.001, :);


for i=1:length(WAP_Predictions)
 WAP_Predictions(i,4)=i;
end

% a1=9;
% b1=81;
% 
% Ind_Hmap=[1];
% for k=1:21
%     B0=Ind_Hmap+1;
%     C0=Ind_Hmap+a1;
%     D0=Ind_Hmap+b1;
%     Ind_Hmap =[Ind_Hmap; B0; C0; D0];
%     Ind_Hmap = Ind_Hmap(Ind_Hmap<=312); 
%     [Uni_Ind_Hmap,Index]=unique(Ind_Hmap);
%     DupIndex=setdiff(1:size(Ind_Hmap,1),Index)';
%     Ind_Hmap(DupIndex,:)=[];
%    
% end
  


% Construct the mapping between heatmap and WAP locations
WAP_Predictions_initial=WAP_Predictions;

for j =1:length(WAP_Predictions)
    aa = rem(j,4);
    bb = 2-rem(aa,2);
    cc = round((aa+1)/2);

    r0 = fix((j-1)/24);
    r1 = rem((j-1),24);
    if aa==1
        k = fix(r1/4)*13 + 1 + r0;
    elseif aa==2
        k = (12-fix(r1/4))*13 - r0;
    elseif aa==3
        k = (fix(r1/4)+1)*13  - r0;
    elseif aa==0
        k = (12-fix(r1/4)-1)*13 +1+r0;
    end
   
    %k=Ind_Hmap(j);
    %k=j;
    %WAP_Predictions_samefloor=WAP_Predictions_initial(WAP_Predictions_initial(:,3)==Hmap_Location_Matrix(k,3),:);          
    Idx = knnsearch(WAP_Predictions_initial(:,1:2), [hmap(bb,1),hmap(cc,2)] , 'k', 1);
    Hmap_Location_Matrix(k,3) = WAP_Predictions_initial(Idx,4);
    WAP_Predictions_initial(Idx,:)=[];
% 
%     scatter(Hmap_Location_Matrix(:,1), Hmap_Location_Matrix(:,2), 'b');
% hold on;
% scatter(Hmap_Location_Matrix(k,1), Hmap_Location_Matrix(k,2), 'r','d','filled');
% %hold off;
% pause;
end
%  

% for k=1:100;
% Idx=Hmap_Location_Matrix(k,3);
% % scatter(WAP_Predictions(:, 1), WAP_Predictions(:, 2), 'r', '+');
% % hold on;
% % scatter(WAP_Predictions(Idx, 1), WAP_Predictions(Idx,2), 'k','filled');
% % hold on;
% scatter(Hmap_Location_Matrix(:,1), Hmap_Location_Matrix(:,2), 'b');
% hold on;
% scatter(Hmap_Location_Matrix(Idx,1), Hmap_Location_Matrix(Idx,2), 'r','d','filled');
% hold off;
%  pause;
% end
% 






% 

% %Right now only training using building 1 for floor predictions
% %[RSSI_Image_Matrix_Temp] = RSSI_Image_Generation(Data1.location_train_df(:, 1:312), Location_Matrix, Image_numNeighbors, WAP_Predictions, Num_Points, "Training Images");
Floor_RSSI_Image_Generation_HX_1130(Floor_Train(:, 1:m-4), Hmap_Location_Matrix,  hmap_size, WAP_Predictions, "Floor Training Images");
% 
% %RSSI_Image_Generation(Data1.location_test_df(Data1.location_test_df(:, 316) == 1, 1:312), Location_Matrix, Image_numNeighbors, WAP_Predictions, Num_Points, "Floor Test Images");
Floor_RSSI_Image_Generation_HX_1130(Floor_Test(:, 1:m-4), Hmap_Location_Matrix,  hmap_size, WAP_Predictions, "Floor Test Images");
% Floor_RSSI_Image_Generation_HX_1011(Floor_Test_Temp(:, 1:312), Hmap_Location_Matrix, Image_numNeighbors, WAP_Predictions, "Floor Test Images");
% 
% %Right now only training using building 1 floor 1 for longitude and latitude predictions
% %[RSSI_Image_Matrix_Temp] = RSSI_Image_Generation(Data1.location_train_df(:, 1:312), Location_Matrix, Image_numNeighbors, WAP_Predictions, Num_Points, "Training Images");
% Loc_RSSI_Image_Generation(Loc_Train(:, 1:312), Hmap_Location_Matrix, Image_numNeighbors, WAP_Predictions, Hmap_Num_Points, "Long & Lat Training Images");
% 
% %RSSI_Image_Generation(Data1.location_test_df(Data1.location_test_df(:, 316) == 1, 1:312), Location_Matrix, Image_numNeighbors, WAP_Predictions, Num_Points, "Floor Test Images");
% Loc_RSSI_Image_Generation(Loc_Test(:, 1:312), Hmap_Location_Matrix, Image_numNeighbors, WAP_Predictions, Hmap_Num_Points, "Long & Lat Test Images");
% %% Start Running from Here

%save("Workspace");


%load("Workspace");

 %Generate WAP image predictions
scatter(WAP_Predictions(:, 1), WAP_Predictions(:, 2), 'r', '+');
hold on;
scatter(Data1.location_train_df(:, 313), Data1.location_train_df(:, 314), 'b');
hold off;


%Create RSSI Images Using a modified KNN
Image_numNeighbors = 1;

%Create heat map for building 1 floor 0 for the first image matrix
%Do Some manipulating required to fit heapmap documentation
% figure();
% RSSI_Image_Matrix = open("Training Images\1_1_0.mat");
% hinput = RSSI_Image_Matrix.RSSI_Image_Matrix(RSSI_Image_Matrix.RSSI_Image_Matrix(:, 4) == 0, 1:5);
% hinput_temp = hinput_temp(hinput_temp(:, 5) == 1, 1:5);
% 
% for i = 1:sqrt(Num_Points)
%     hinput(i, 1:sqrt(Num_Points)) = hinput_temp(((1+sqrt(Num_Points)*(i-1)) : (sqrt(Num_Points)+sqrt(Num_Points)*(i-1))), 1);
% end
% hinput = (RSSI_Image_Matrix.RSSI_Image_Matrix);
% h = heatmap(hmap_build1(:, 1), hmap_build1(:, 2), hinput);

%h = heatmap(Location_Matrix(:, 1), Location_Matrix(:, 2), RSSI_Image_Matrix(:, 1));

%%%%% Step 2 %%%%%
%Binary Split to narrow down neighborhood
%[Test_Data_Split] = NN_Binary_Split(Data1);

%%%%% Step 3 %%%%%
%Use Convolutional Neural Network to get location estimates




%      filePattern = fullfile ("Training Images",'**','*.mat');
%      imageFiles  = dir(filePattern); 
%      temp=load(fullfile(imageFiles(1).folder,imageFiles(1).name));
%      A = arrayDatastore(temp.RSSI_Image_Matrix);
% 

% Floor_Train = [];
% for i = 1:size(Floor_Train_Temp, 1)
%     %Floor_Train = [Floor_Train; Floor_Train_Temp(i, :); Floor_Train_Temp(i, :); Floor_Train_Temp(i, :); Floor_Train_Temp(i, :); Floor_Train_Temp(i, :)];
%     Floor_Train = [Floor_Train; Floor_Train_Temp(i, :)];
% end
% 
% Floor_Test = [];
% for i = 1:size(Floor_Test_Temp, 1)
%     %Floor_Test = [Floor_Test; Floor_Test_Temp(i, :); Floor_Test_Temp(i, :); Floor_Test_Temp(i, :); Floor_Test_Temp(i, :); Floor_Test_Temp(i, :)];
%     Floor_Test = [Floor_Test; Floor_Test_Temp(i, :)];
% end





%[CNN_Longitude_Prediction, CNN_Latitude_Prediction, CNN_Floor_Prediction] = CNN_Prediction_HX_1103("Long & Lat Training Images", "Long & Lat Test Images", "Floor Training Images", "Floor Test Images", Loc_Train, Loc_Test, Floor_Train, Floor_Test, Num_Points);
[CNN_Floor_Prediction] = CNN_Prediction_HX_1130("Long & Lat Training Images", "Long & Lat Test Images", "Floor Training Images", "Floor Test Images",Floor_Train, Floor_Test, Num_Points);
CNN_Accuracy = Classification_Accuracy(CNN_Floor_Prediction, Floor_Test(:, m-1));



%[CNN_Longitude_Prediction, CNN_Latitude_Prediction, CNN_Floor_Prediction] = CNN_Prediction("Long & Lat Training Images", "Long & Lat Test Images", "Floor Training Images", "Floor Test Images", Loc_Train, Loc_Test, Floor_Train, Floor_Test, Num_Points);

%     %Make response vector that has labels for all three buildings 
%     %(that's why we need 3 copies)
%     responses = Data1.location_train_df(1:45,313);


%%%%%%% the following block will be deleted

%     filePattern = fullfile ("Training Images",'**','*.mat');
%     
%     imageFiles  = dir(filePattern); 
%     
%        % arrds1 = load(fullfile(imageFiles(1).folder,imageFiles(1).name));
%        % A = arrayDatastore(arrds1.RSSI_Image_Matrix);
%     data0 = zeros(10,10,1,45);
%     %A = arrayDatastore(Training_Image_Folder);
%     for i = 1:length(imageFiles)
%         arrds = load(fullfile(imageFiles(i).folder,imageFiles(i).name));
%         data0(:,:,1,i)=arrds.RSSI_Image_Matrix;
%        % aa=arrds.RSSI_Image_Matrix;
%     end
%     


%     data0 = combine(A);
%%%%%%% the above block will be deleted

%Using KNN for prediction
%KNNnumNeighbors = 9;
% 
% [KNN_Building_prediction, KNN_Floor_prediction, KNN_Longitude_prediction, KNN_Latitude_prediction]=KNN_Prediction(Data1, KNNnumNeighbors);

%Using Random Forest for prediction
% numBags = 3;
% 
% [RF_Building_prediction, RF_Floor_prediction, RF_Longitude_prediction, RF_Latitude_prediction] = RF_Prediction(Data1, numBags);

%Using Feed Forward Neural Network for prediction
%[NN_Building_prediction, NN_Floor_prediction, NN_Longitude_prediction, NN_Latitude_prediction] = NN_Prediction(Data1);
%[Train_NN_Longitude_prediction, Train_NN_Latitude_prediction, Test_NN_Longitude_prediction, Test_NN_Latitude_prediction] = NN_Prediction(Data1);

%Use Feed Forward Neural Network and Binary Search for prediction
% [NN_Bin_Building_1_or_2_prediction, NN_Bin_Building_0_or_1_prediction, ...
%             NN_Bin_Building_0_Floor_1_or_2_prediction, NN_Bin_Building_0_Floor_0_or_1_prediction, ...
%             NN_Bin_Building_0_Floor_2_or_3_prediction, NN_Bin_Longitude_prediction,  NN_Bin_Latitude_prediction, ...
%             NN_Bin_Floor_2_Longitude_prediction, NN_Bin_Floor_2_Latitude_prediction, ...
%             NN_Bin_Building_0_section_prediction, NN_Bin_Building_1_section_prediction, ...
%             NN_Bin_Building_2_section_prediction, NN_Bin_Building_0_Section_0_Longitude_prediction, ...
%             NN_Bin_Building_0_Section_0_Latitude_prediction, NN_Bin_Building_0_Section_1_Longitude_prediction, ...
%             NN_Bin_Building_0_Section_1_Latitude_prediction, NN_Bin_Building_1_Section_0_Longitude_prediction, ...
%             NN_Bin_Building_1_Section_0_Latitude_prediction, NN_Bin_Building_1_Section_1_Longitude_prediction, ...
%             NN_Bin_Building_1_Section_1_Latitude_prediction, NN_Bin_Building_2_Section_0_Longitude_prediction, ...
%             NN_Bin_Building_2_Section_0_Latitude_prediction, NN_Bin_Building_2_Section_1_Longitude_prediction, ...
%             NN_Bin_Building_2_Section_1_Latitude_prediction] = NN_Binary_Prediction(Data1);
%Use Deep Learning Network for prediction
%[Train_NN_Longitude_prediction, Train_NN_Latitude_prediction, Test_NN_Longitude_prediction, Test_NN_Latitude_prediction] = Deep_Learning_Test(Data1); 

%Using linear regression for prediction
%[LIN_Longitude_prediction, LIN_Latitude_prediction] = Linear_Regression(Data1);

%Concatenate test data and prediction vectors for visual analysis
%KNN_Result_Matrix = [Data1.location_test_df  KNN_Longitude_prediction KNN_Latitude_prediction KNN_Building_prediction KNN_Floor_prediction];
%RF_Result_Matrix = [Data1.location_test_df  RF_Longitude_prediction RF_Latitude_prediction RF_Building_prediction RF_Floor_prediction];
%NN_Result_Matrix = [Data1.location_test_df  NN_Longitude_prediction NN_Latitude_prediction NN_Building_prediction NN_Floor_prediction];

%Calculate error for all 3 methods
%Training vs test set
%Establish comparison vectors
%True_Buildings = Data1.location_test_df(:, 316);
%True_Floors = Data1.location_test_df(:, 315);
%True_Position = [Data1.location_test_df(:, 313) Data1.location_test_df(:, 314)];

%Error for the KNN predicitons
% KNN_Building_Accuracy = Classification_Accuracy(KNN_Building_prediction, True_Buildings);
% KNN_Floor_Accuracy = Classification_Accuracy(KNN_Floor_prediction, True_Floors);
% [KNN_Pos_Mean, KNN_Pos_Median, KNN_Pos_STD, KNN_Pos_Min, KNN_Pos_Max, KNN_Pos_Quartiles] = Regression_Accuracy([KNN_Longitude_prediction KNN_Latitude_prediction], True_Position);

%Error for the RF predictions
% RF_Building_Accuracy = Classification_Accuracy(RF_Building_prediction, True_Buildings);
% RF_Floor_Accuracy = Classification_Accuracy(RF_Floor_prediction, True_Floors);
% [RF_Pos_Mean, RF_Pos_Median, RF_Pos_STD, RF_Pos_Min, RF_Pos_Max, RF_Pos_Quartiles] = Regression_Accuracy([RF_Longitude_prediction RF_Latitude_prediction], True_Position);

%Error for the NN predicitons
%NN_Building_Accuracy = Classification_Accuracy(NN_Building_prediction, True_Buildings);
%NN_Floor_Accuracy = Classification_Accuracy(NN_Floor_prediction, True_Floors);
%[NN_Pos_Mean, NN_Pos_Median, NN_Pos_STD, NN_Pos_Min, NN_Pos_Max, NN_Pos_Quartiles] = Regression_Accuracy([NN_Longitude_prediction NN_Latitude_prediction], True_Position);
%[Test_NN_Pos_Mean, Test_Pos_Median, Test_Pos_STD, Test_Pos_Min, Test_Pos_Max, Test_Pos_Quartiles] = Regression_Accuracy([Test_NN_Longitude_prediction Test_NN_Latitude_prediction], True_Position);
%True_Position = [Data1.location_train_df(:, 313) Data1.location_train_df(:, 314)];
%[Train_NN_Pos_Mean, Train_Pos_Median, Train_Pos_STD, Train_Pos_Min, Train_Pos_Max, Train_Pos_Quartiles] = Regression_Accuracy([Train_NN_Longitude_prediction Train_NN_Latitude_prediction], True_Position);

%Error for Binary NN Predictions
%Set data based on new dfs first
% NN_Bin_1_or_2_True_Buildings = Data1.binary_test_df(:, 317);
% NN_Bin_0_or_1_True_Buildings  = Data1.building_0_1_test_df(:, 316);
% 
% NN_Bin_1_or_2_True_Floor  = Data1.building_0_test_df(:, 317);
% NN_Bin_0_or_1_True_Floor  = Data1.floor_0_1_test_df(:, 315);
% NN_Bin_2_or_3_True_Floor  = Data1.floor_2_3_test_df(:, 315);
% 
% NN_Bin_Building_0_True_Section = Data1.building_0_test_df(:, 318);
% NN_Bin_Building_1_True_Section = Data1.building_1_test_df(:, 318);
% NN_Bin_Building_2_True_Section = Data1.building_2_test_df(:, 318);
% 
% NN_Bin_True_Position = [Data1.building_0_test_df(:, 313) Data1.building_0_test_df(:, 314)];
% NN_Bin_Floor_2_True_Position = [Data1.floor_2_test_df(:, 313) Data1.floor_2_test_df(:, 314)];
% 
% NN_Bin_Building_0_Section_0_True_Position = [Data1.building_0_section_0_test_df(:, 313) Data1.building_0_section_0_test_df(:, 314)];
% NN_Bin_Building_0_Section_1_True_Position = [Data1.building_0_section_1_test_df(:, 313) Data1.building_0_section_1_test_df(:, 314)];
% NN_Bin_Building_1_Section_0_True_Position = [Data1.building_1_section_0_test_df(:, 313) Data1.building_1_section_0_test_df(:, 314)];
% NN_Bin_Building_1_Section_1_True_Position = [Data1.building_1_section_1_test_df(:, 313) Data1.building_1_section_1_test_df(:, 314)];
% NN_Bin_Building_2_Section_0_True_Position = [Data1.building_2_section_0_test_df(:, 313) Data1.building_2_section_0_test_df(:, 314)];
% NN_Bin_Building_2_Section_1_True_Position = [Data1.building_2_section_1_test_df(:, 313) Data1.building_2_section_1_test_df(:, 314)];
% 
% 
% NN_Bin_Building_1_or_2_Accuracy = Classification_Accuracy(NN_Bin_Building_1_or_2_prediction, NN_Bin_1_or_2_True_Buildings);
% NN_Bin_Building_0_or_1_Accuracy = Classification_Accuracy(NN_Bin_Building_0_or_1_prediction, NN_Bin_0_or_1_True_Buildings);
% 
% NN_Bin_Floor_1_or_2_Accuracy = Classification_Accuracy(NN_Bin_Building_0_Floor_1_or_2_prediction, NN_Bin_1_or_2_True_Floor);
% NN_Bin_Floor_0_or_1_Accuracy = Classification_Accuracy( NN_Bin_Building_0_Floor_0_or_1_prediction, NN_Bin_0_or_1_True_Floor);
% NN_Bin_Floor_2_or_3_Accuracy = Classification_Accuracy( NN_Bin_Building_0_Floor_2_or_3_prediction, NN_Bin_2_or_3_True_Floor);
% 
% NN_Bin_Building_0_Section_Accuracy = Classification_Accuracy(NN_Bin_Building_0_section_prediction, NN_Bin_Building_0_True_Section);
% NN_Bin_Building_1_Section_Accuracy = Classification_Accuracy(NN_Bin_Building_1_section_prediction, NN_Bin_Building_1_True_Section);
% NN_Bin_Building_2_Section_Accuracy = Classification_Accuracy(NN_Bin_Building_2_section_prediction, NN_Bin_Building_2_True_Section);
% 
% [NN_Bin_Pos_Mean, NN_Bin_Pos_Median, NN_Bin_Pos_STD, NN_Bin_Pos_Min, NN_Bin_Pos_Max, NN_Bin_Pos_Quartiles] = Regression_Accuracy([NN_Bin_Longitude_prediction NN_Bin_Latitude_prediction], NN_Bin_True_Position);
% [NN_Bin_Floor_2_Pos_Mean, NN_Bin_Floor_2_Pos_Median, NN_Bin_Floor_2_Pos_STD, NN_Bin_Floor_2_Pos_Min, NN_Bin_Floor_2_Pos_Max, NN_Bin_Floor_2_Pos_Quartiles] = Regression_Accuracy([NN_Bin_Floor_2_Longitude_prediction, NN_Bin_Floor_2_Latitude_prediction], NN_Bin_Floor_2_True_Position);
% 
% [NN_Bin_Building_0_Section_0_Pos_Mean, NN_Bin_Building_0_Section_0_Pos_Median, NN_BinBuilding_0_Section_0_Pos_STD, NN_Bin_Building_0_Section_0_Pos_Min, NN_Bin_Building_0_Section_0_Pos_Max, NN_Bin_Building_0_Section_0_Pos_Quartiles] = Regression_Accuracy([NN_Bin_Building_0_Section_0_Longitude_prediction, NN_Bin_Building_0_Section_0_Latitude_prediction], NN_Bin_Building_0_Section_0_True_Position);
% [NN_Bin_Building_0_Section_1_Pos_Mean, NN_Bin_Building_0_Section_1_Pos_Median, NN_BinBuilding_0_Section_1_Pos_STD, NN_Bin_Building_0_Section_1_Pos_Min, NN_Bin_Building_0_Section_1_Pos_Max, NN_Bin_Building_0_Section_1_Pos_Quartiles] = Regression_Accuracy([NN_Bin_Building_0_Section_1_Longitude_prediction, NN_Bin_Building_0_Section_1_Latitude_prediction], NN_Bin_Building_0_Section_1_True_Position);
% [NN_Bin_Building_1_Section_0_Pos_Mean, NN_Bin_Building_1_Section_0_Pos_Median, NN_BinBuilding_1_Section_0_Pos_STD, NN_Bin_Building_1_Section_0_Pos_Min, NN_Bin_Building_1_Section_0_Pos_Max, NN_Bin_Building_1_Section_0_Pos_Quartiles] = Regression_Accuracy([NN_Bin_Building_1_Section_0_Longitude_prediction, NN_Bin_Building_1_Section_0_Latitude_prediction], NN_Bin_Building_1_Section_0_True_Position);
% [NN_Bin_Building_1_Section_1_Pos_Mean, NN_Bin_Building_1_Section_1_Pos_Median, NN_BinBuilding_1_Section_1_Pos_STD, NN_Bin_Building_1_Section_1_Pos_Min, NN_Bin_Building_1_Section_1_Pos_Max, NN_Bin_Building_1_Section_1_Pos_Quartiles] = Regression_Accuracy([NN_Bin_Building_1_Section_1_Longitude_prediction, NN_Bin_Building_1_Section_1_Latitude_prediction], NN_Bin_Building_1_Section_1_True_Position);
% [NN_Bin_Building_2_Section_0_Pos_Mean, NN _Bin_Building_2_Section_0_Pos_Median, NN_BinBuilding_2_Section_0_Pos_STD, NN_Bin_Building_2_Section_0_Pos_Min, NN_Bin_Building_2_Section_0_Pos_Max, NN_Bin_Building_2_Section_0_Pos_Quartiles] = Regression_Accuracy([NN_Bin_Building_2_Section_0_Longitude_prediction, NN_Bin_Building_2_Section_0_Latitude_prediction], NN_Bin_Building_2_Section_0_True_Position);
% [NN_Bin_Building_2_Section_1_Pos_Mean, NN_Bin_Building_2_Section_1_Pos_Median, NN_BinBuilding_2_Section_1_Pos_STD, NN_Bin_Building_2_Section_1_Pos_Min, NN_Bin_Building_2_Section_1_Pos_Max, NN_Bin_Building_2_Section_1_Pos_Quartiles] = Regression_Accuracy([NN_Bin_Building_2_Section_1_Longitude_prediction, NN_Bin_Building_2_Section_1_Latitude_prediction], NN_Bin_Building_2_Section_1_True_Position);

%Error for CNN Prediction
%CNN_Accuracy = Classification_Accuracy(CNN_Floor_Prediction, Floor_Test(:, 149));
%[CNN_Mean, CNN_Median, CNN_STD, CNN_Min, CNN_Max, CNN_Quartiles] = Regression_Accuracy([CNN_Longitude_Prediction CNN_Latitude_Prediction], Loc_Test(:, 313:314));