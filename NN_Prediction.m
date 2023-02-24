%File Name: NN_Prediction
%Description: This function uses feed forward neural networks on the WAPs
%in the train data set and predicts the building, floor, longitude, and 
%latitude of the samples in the test data set 
%Inputs: The Data object
%Outputs: Vectors containing the predicitons for building, floor, longitude,
%and latitudes for the samples in the test set
%First created: 9/14/21
%Last Modified: 10/30/21
%File Created By: Nora Agah

function [NN_Building_prediction, NN_Floor_prediction, NN_Longitude_prediction, NN_Latitude_prediction] = NN_Prediction(NN_Data)
    %Use transpose of matrices to fit formatting
    %Set training data to training set
    x1 = (NN_Data.location_train_df(:, 1:312)).';
    
    %Set target to floor data
    t = (NN_Data.location_train_df(:, 315)).';
    
    %Set validation data to test set
    test = (NN_Data.location_test_df(:, 1:312)).';
    
    %Construct a feedforward network with one hidden layer of size 10
    net = feedforwardnet([5,5,5]);

    %Train the neural network to predict floors
    net = train(net,x1,t);
    
    %Use the network for floor prediction
    NN_Floor_prediction = (nearest(net(test))).';
    
    %Construct another feedforward network with one hidden layer of size 10
    net = feedforwardnet([5,5,5]);
    
    %Reset target for building data
    t = (NN_Data.location_train_df(:, 316)).';
     
    %Train the neural network to predict building
    net = train(net,x1,t);
    
    %Use the network for building prediction
    NN_Building_prediction = (nearest(net(test))).';


    
    %%%%%%%%%%%%
    %This section is the regression code that did not work very well
    %Construct a feedforward network with hidden layers of size [15, 15]
    net = feedforwardnet([15,15]);
    
    %Reset target for longitude data
    t = (NN_Data.location_train_df(:, 313)).';
     
    %Train the neural network to predict longitude
    net = train(net,x1,t);
    
    %Use the network for longitude prediction
    NN_Longitude_prediction = (net(test)).';
    
   %Construct a feedforward network with hidden layers of size [15, 15]
    net = feedforwardnet([15,15]);
    
    %Reset target for latitude data
    t = (NN_Data.location_train_df(:, 314)).';
     
    %Train the neural network to predict latitude
    net = train(net,x1,t);
    
    %Use the network for latitude prediction
    NN_Latitude_prediction = (net(test)).'; 
    
end