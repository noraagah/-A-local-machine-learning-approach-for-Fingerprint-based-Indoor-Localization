%File Name: Linear_Regression
%Description: This function uses linear regression on the WAPs
%in the train data set and predicts the longitude and 
%latitude of the samples in the test data set to create a baseline for
%comparison
%Inputs: The Data object
%Outputs: Arrays containing the predicitons for longitude
%and latitudes for the samples in the test set
%First created: 10/19/21
%Last Modified: 10/19/21
%File Created By: Nora Agah

function [LIN_Longitude_prediction, LIN_Latitude_prediction] = Linear_Regression(LIN_Data)
    %Set up training data
    X = (LIN_Data.location_train_df(:, 1:312));
    
    %Set target for longitude data
    y = (LIN_Data.location_train_df(:, 313));

    %Set validation data to test set
    test = (LIN_Data.location_test_df(:, 1:312));
    
    %Fit a linear regression model for longitude predictions
    long_model = fitlm(X, y);

    %Use the linear regression model for prediction
    LIN_Longitude_prediction = predict(long_model, test);

    %Reet target for latitude data
    y = (LIN_Data.location_train_df(:, 314));

    %Fit a linear regression model for latitude predictions
    lat_model = fitlm(X, y);
    
    %Use the linear regression model for prediction
    LIN_Latitude_prediction = predict(lat_model, test);


end