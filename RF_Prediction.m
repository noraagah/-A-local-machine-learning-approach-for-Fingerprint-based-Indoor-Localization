%File Name: RF_Prediction
%Description: This function uses Random Forest on the WAPs in the train data set and
%predicts the building, floor, longitude, and latitude of the samples in
%the test data set
%Inputs: The data object, the number of bags to be used in random forest
%Outputs: Arrays containing the predicitons for building, floor, longitude,
%and latitude for the samples in the test set
%First created: 9/7/21
%Last Modified: 9/24/21
%File Created By: Nora Agah

function [RF_Building_prediction, RF_Floor_prediction, RF_Longitude_prediction, RF_Latitude_prediction] = RF_Prediction(RF_Data, numBags)
        
    %Create the Random Forest Model to predict longitutdes
    model = fitensemble(RF_Data.location_train_df(:, 1:312), RF_Data.location_train_df(:, 313),'Bag',numBags,'Tree','Type','regression');
    
    %Predict longitudes using Random Forest Model
    RF_Longitude_prediction = predict(model, RF_Data.location_test_df(:, 1:312)); 
    
    %Create the Random Forest Model to predict latitudes
    model = fitensemble(RF_Data.location_train_df(:, 1:312), RF_Data.location_train_df(:, 314),'Bag',numBags,'Tree','Type','regression');
    
    %Predict latitudes using Random Forest Model
    RF_Latitude_prediction = predict(model, RF_Data.location_test_df(:, 1:312));
    
    %Create the Random Forest Model to predict floors
    model = fitensemble(RF_Data.location_train_df(:, 1:312), RF_Data.location_train_df(:, 315),'Bag',numBags,'Tree','Type','classification');
    
    %Predict floors using Random Forest Model and round to nearest integer
    RF_Floor_prediction = nearest(predict(model, RF_Data.location_test_df(:, 1:312)));
    
    %Create the Random Forest Model to predict buildings
    model = fitensemble(RF_Data.location_train_df(:, 1:312), RF_Data.location_train_df(:, 316),'Bag',numBags,'Tree','Type','classification');
    
    %Predict buildings using Random Forest Model and round to nearest integer
    RF_Building_prediction = nearest(predict(model, RF_Data.location_test_df(:, 1:312)));
    
end