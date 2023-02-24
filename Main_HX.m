%File Name: Main
%Original Python code: building2binarysearch_IV 
%Section: None
%Research advisor: Brian Evans
%Description: This file calls all methods and functions related to the indoor
%location project as well as calculates all
%Inputs: None
%Outputs: None
%First created: 8/13/21
% %Last Modified: 5/5/22
%File Created By: Nora Agah; modified by hx

 Data1 = Data("trainingData.csv", "validationData.csv");
% 
% %%%%% Step 1 %%%%%
% 
% %Construct Wifi Access Points
% %Pass in a square number for Num_Points
%We are creating 5th floor estimations for buildings 1 and 2 becuase that
%is the form the CNN needs it
Num_Floors = 5;
Num_Points = 100;

%The locations to get RSSI predictions for
%Create grid for each of the floors
%Num_Points points per floor per building grid-Num_Points*4*3
%Also create matrices that can be passed into the heatmap function
Location_Matrix = ones(3*Num_Points*5, 4);

hmap_build0 = ones(sqrt(Num_Points), 2);
hmap_build1 = ones(sqrt(Num_Points), 2);
hmap_build0 = ones(sqrt(Num_Points), 2);
%Building 0
%Longitude from -7700 to -7580
%Latitude from 4864880 to 4865020
Lat_Increms = (-7580-(-7700))/sqrt(Num_Points);
Long_Increms = (4865020-(4864880))/sqrt(Num_Points);

for i = 1:Num_Floors
    Longitude = 4864880;
    for j = 1:sqrt(Num_Points)
        Latitude = -7700;
        for k = 1:sqrt(Num_Points)
            Location_Matrix((i-1)*Num_Points+(j-1)*sqrt(Num_Points)+k, 1) = Latitude;
            Location_Matrix((i-1)*Num_Points+(j-1)*sqrt(Num_Points)+k, 2) = Longitude;
            Location_Matrix((i-1)*Num_Points+(j-1)*sqrt(Num_Points)+k, 3) = i-1;
            Location_Matrix((i-1)*Num_Points+(j-1)*sqrt(Num_Points)+k, 4) = 0;
            hmap_build0(mod(k, sqrt(Num_Points)+1), 1) = Latitude;
            Latitude = Latitude + Lat_Increms;
        end
        hmap_build0(mod(j, sqrt(Num_Points)+1), 2) = Longitude;
        Longitude = Longitude + Long_Increms;
    end
end

%Building 1
%Longitude from -7600 to -7400
%Latitude from 4864800 to 4864980
Lat_Increms = (-7400-(-7600))/sqrt(Num_Points);
Long_Increms = (4864980-(4864800))/sqrt(Num_Points);

for i = 1:Num_Floors
    Longitude = 4864800;
    for j = 1:sqrt(Num_Points)
        Latitude = -7600;
        for k = 1:sqrt(Num_Points)
            Location_Matrix(Num_Floors*Num_Points+(i-1)*Num_Points+(j-1)*sqrt(Num_Points)+k, 1) = Latitude;
            Location_Matrix(Num_Floors*Num_Points+(i-1)*Num_Points+(j-1)*sqrt(Num_Points)+k, 2) = Longitude;
            Location_Matrix(Num_Floors*Num_Points+(i-1)*Num_Points+(j-1)*sqrt(Num_Points)+k, 3) = i-1;
            Location_Matrix(Num_Floors*Num_Points+(i-1)*Num_Points+(j-1)*sqrt(Num_Points)+k, 4) = 1;    
            hmap_build1(mod(k, sqrt(Num_Points)+1), 1) = Latitude;
            Latitude = Latitude + Lat_Increms;
        end
          hmap_build1(mod(j, sqrt(Num_Points)+1), 2) = Longitude;

        Longitude = Longitude + Long_Increms;
    end
end

%Building 2
%Longitude from -7420 to -7300
%Latitude from 4864740 to 4864880
Lat_Increms = (-7300-(-7420))/sqrt(Num_Points);
Long_Increms = (4864880-(4864740))/sqrt(Num_Points);

for i = 1:Num_Floors
    Longitude = 4864800;
    for j = 1:sqrt(Num_Points)
        Latitude = -7600;
        for k = 1:sqrt(Num_Points)
            Location_Matrix(2*Num_Floors*Num_Points+(i-1)*Num_Points+(j-1)*sqrt(Num_Points)+k, 1) = Latitude;
            Location_Matrix(2*Num_Floors*Num_Points+(i-1)*Num_Points+(j-1)*sqrt(Num_Points)+k, 2) = Longitude;
            Location_Matrix(2*Num_Floors*Num_Points+(i-1)*Num_Points+(j-1)*sqrt(Num_Points)+k, 3) = i-1;
            Location_Matrix(2*Num_Floors*Num_Points+(i-1)*Num_Points+(j-1)*sqrt(Num_Points)+k, 4) = 2;    
            hmap_build2(mod(k, sqrt(Num_Points)+1), 1) = Latitude;
            Latitude = Latitude + Lat_Increms;
        end
        hmap_build2(mod(j, sqrt(Num_Points)+1), 2) = Longitude;

        Longitude = Longitude + Long_Increms;
    end
end


% for i = 1:Num_Floors
%     Longitude = 4864740;
%     for j = 1:sqrt(Num_Points)
%         Latitude = -7420;
%         for k = 1:sqrt(Num_Points)
%             Location_Matrix(2*4*Num_Points+(i-1)*Num_Points+(j-1)*sqrt(Num_Points)+k, 1) = Latitude;
%             Location_Matrix(2*4*Num_Points+(i-1)*Num_Points+(j-1)*sqrt(Num_Points)+k, 2) = Longitude;
%             Location_Matrix(2*4*Num_Points+(i-1)*Num_Points+(j-1)*sqrt(Num_Points)+k, 3) = i-1;
%             Location_Matrix(2*4*Num_Points+(i-1)*Num_Points+(j-1)*sqrt(Num_Points)+k, 4) = 2;
%             hmap_build2(mod(k, sqrt(Num_Points)+1), 1) = Latitude;
%             Latitude = Latitude + Lat_Increms;
%         end
%           hmap_build2(mod(j, sqrt(Num_Points)+1), 2) = Longitude;
%         Longitude = Longitude + Long_Increms;
%     end
% end

%Generate Predictions of RSSIs give a cell phone at a give location
[RSSI_Predictions] = RSSI_Prediction_Vectorized(Data1, Location_Matrix);
 
%Give predictions to WAP_Locating in order to get guesses for WAP locations
[WAP_Predictions] = WAP_Locating(RSSI_Predictions);


%Generate WAP image predictions
scatter(WAP_Predictions(:, 1), WAP_Predictions(:, 2), 'r', '+');
hold on;
scatter(Data1.location_train_df(:, 313), Data1.location_train_df(:, 314), 'b');
hold off;


%Create RSSI Images Using a modified KNN
Image_numNeighbors = 7;

[RSSI_Image_Matrix_Temp] = RSSI_Image_Generation(Data1.location_train_df(1:3, 1:312), Location_Matrix, Image_numNeighbors, WAP_Predictions, Num_Points, "Training Images");
% 
RSSI_Image_Generation(Data1.location_test_df(1, 1:312), Location_Matrix, Image_numNeighbors, WAP_Predictions, Num_Points, "Test Images");


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
[Final_Floor_Prediction, Final_Longitude_Prediction, Final_Floor_Prediction] = CNN_Prediction_2(Data1, "Training Images", "Test Images", Data1.location_train_df(1:3, 1:316), Data1.location_test_df(1, 1:312), Num_Points);

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
% [NN_Bin_Building_2_Section_0_Pos_Mean, NN_Bin_Building_2_Section_0_Pos_Median, NN_BinBuilding_2_Section_0_Pos_STD, NN_Bin_Building_2_Section_0_Pos_Min, NN_Bin_Building_2_Section_0_Pos_Max, NN_Bin_Building_2_Section_0_Pos_Quartiles] = Regression_Accuracy([NN_Bin_Building_2_Section_0_Longitude_prediction, NN_Bin_Building_2_Section_0_Latitude_prediction], NN_Bin_Building_2_Section_0_True_Position);
% [NN_Bin_Building_2_Section_1_Pos_Mean, NN_Bin_Building_2_Section_1_Pos_Median, NN_BinBuilding_2_Section_1_Pos_STD, NN_Bin_Building_2_Section_1_Pos_Min, NN_Bin_Building_2_Section_1_Pos_Max, NN_Bin_Building_2_Section_1_Pos_Quartiles] = Regression_Accuracy([NN_Bin_Building_2_Section_1_Longitude_prediction, NN_Bin_Building_2_Section_1_Latitude_prediction], NN_Bin_Building_2_Section_1_True_Position);
