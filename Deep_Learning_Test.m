%File Name: Deep_Learning_Test
%Description: This function uses deep learning networks on the WAPs
%in the train data set and predicts the longitude and 
%latitude of the samples in the test data set 
%Inputs: The Data object
%Outputs: Vectors containing the predicitons for longitude
%and latitudes
%for the samples in the test set
%First created: 10/26/21
%Last Modified: 10/30/21
%File Created By: Nora Agah

function [Train_NN_Longitude_prediction, Train_NN_Latitude_prediction, Test_NN_Longitude_prediction, Test_NN_Latitude_prediction] = Deep_Learning_Test(NN_Data)  

%Specify the layer configurations
    layers = [
    featureInputLayer(312)
    tanhLayer
    scalingLayer
    fullyConnectedLayer(50)
    tanhLayer
    scalingLayer 
    fullyConnectedLayer(50)
    tanhLayer
    scalingLayer 
    fullyConnectedLayer(1)
    regressionLayer];

    %Specify the gradient descent type (Stochastic) and details
    options = trainingOptions('sgdm', ...
    'MaxEpochs',200,...
    'LearnRateSchedule','piecewise', ...
    'InitialLearnRate',1e-3, ...
    'LearnRateDropFactor',5E-4, ...
    'LearnRateDropPeriod',10, ...
    'Verbose',false, ...
    'MiniBatchSize',256, ...
    'Plots','training-progress');

    %Set training data to train set
    x1 = (NN_Data.location_train_df(:, 1:312));

    %Set validation data to test set
    test = (NN_Data.location_test_df(:, 1:312));

    %Set target for longitude data
    y1 = (NN_Data.location_train_df(:, 313));

    %Train network for longitude prediction
    net = trainNetwork(x1, y1, layers, options);
    
    %Use network for longitude prediction
    Test_NN_Longitude_prediction = predict(net, test);

    %Use network for longitude prediction
    Train_NN_Longitude_prediction = predict(net, x1);

    %Set target for latitude data
    y1 = (NN_Data.location_train_df(:, 314));

    %Train network for latitude prediction
    net = trainNetwork(x1, y1, layers, options);
    
    %Use network for latitude prediction
    Test_NN_Latitude_prediction = predict(net, test);
    
    %Use network for longitude prediction
    Train_NN_Latitude_prediction = predict(net, x1);