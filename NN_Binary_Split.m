%%File Name: NN_Binary_Split
%Description: This function uses feed forward neural networks and binary
%split the data in the training data set and test data set and stops splitting when accruacy
%goes below 95% or when the buildings are split by hyperplanes
%Inputs: The Data object
%Outputs: Matrix containing the original test data and predicitons for
%binary split predictions for the samples in the test set concatenated onto
%the test data set
%First created: 3/20/22
%Last Modified: 4/23/22
%File Created By: Nora Agah

function [Test_Data_Split] = NN_Binary_Split(Split_Data)

    %Initialize 
    Test_Data_Split = Split_Data.location_test_df;

    %Split Training data into train and validation data
    Division = nearest(2/3)*size(Split_Data.binary_train_df, 1);
    Training_Data = Split_Data.binary_train_df(1:Division, :);

    %Set validation data to building 0 and 1 or 2 test data
    Validation_Data = Split_Data.binary_train_df((Division+1):end, :);

    %%%Classify as either building 0 and 1 or building 2
    %Labeling 0 and 1 as 1 and 2 as 2
    x1 = (Training_Data(:, 1:312)).';
    
    %Set target to data with buildings in 2 categories
    t = (Training_Data(:, 317)).';
    
    %Set validation data
    valid = (Validation_Data(:, 1:312)).';
    
    %Construct a feedforward network with one hidden layer of size [5,5,5]
    net = feedforwardnet([5,5,5]);

    %Train the neural network to predict floors
    net = train(net,x1,t);
    
    %Use the network for building category prediction
    NN_Bin_Building_0_and_1_or_2_valid = (nearest(net(valid))).';


    %%%Check accuracy and stop if less than 95%
    NN_Bin_0_and_1_or_2_True_Buildings = Validation_Data(:, 317);
    NN_Bin_Building_0_and_1_or_2_Accuracy = Classification_Accuracy(NN_Bin_Building_0_and_1_or_2_valid, NN_Bin_0_and_1_or_2_True_Buildings);

    if NN_Bin_Building_0_and_1_or_2_Accuracy < 0.95
        return
    end
    
    %If accuracy is high enough, perform classification on test data
    input = (Split_Data.location_test_df(:, 1:312)).';
    NN_Bin_Building_0_and_1_or_2_prediction = (nearest(net(input))).';
    Test_Data_Split = [Test_Data_Split NN_Bin_Building_0_and_1_or_2_prediction];



    %%%%Classify in to building 0 or 1

    %Split Training data into train and validation data
    Division = nearest(2/3)*size(Split_Data.building_0_1_train_df, 1);
    Training_Data = Split_Data.building_0_1_train_df(1:Division, :);
    Validation_Data = Split_Data.building_0_1_train_df((Division+1):end, :);

    %Reset validation data to building 0 or 1 test data
    valid = (Validation_Data(:, 1:312)).';
    
    %Reset training data to training for building 0 or 1 classification
    x1 = (Training_Data(:, 1:312)).';
    
    %Construct another feedforward network with one hidden layer of size [5,5,5]
    net = feedforwardnet([5,5,5]);
    
    %Reset target for building 0 or 1 data
    t = (Training_Data(:, 316)).';
     
    %Train the neural network to predict building
    net = train(net,x1,t);
    
    %Use the network for building prediction
    NN_Bin_Building_0_or_1_valid = (nearest(net(valid))).';


    %%%Check accuracy and stop if less than 95%
    NN_Bin_0_or_1_True_Buildings  = Validation_Data(:, 316);
    NN_Bin_Building_0_or_1_Accuracy = Classification_Accuracy(NN_Bin_Building_0_or_1_valid, NN_Bin_0_or_1_True_Buildings);

    if NN_Bin_Building_0_or_1_Accuracy < 0.95
        return
    end

    %If accuracy is high enough, perform classification on test data
    %Initialize with building 2s
    NN_Bin_Building_0_or_1_prediction = ones(size(Test_Data_Split, 1), 1);
    NN_Bin_Building_0_or_1_prediction(:, :) = 2;

    %Find indices of buildings classified as 0 or 1 in order to split them
    %up further
    K = (Test_Data_Split(:, 317) == 1);
    input = (Test_Data_Split(K, 1:312)).';
    NN_Bin_Building_0_or_1_prediction(K) = (nearest(net(input))).';
    Test_Data_Split = [Test_Data_Split NN_Bin_Building_0_or_1_prediction];



    %%%Classify observations using building 0 hyperplane
    
    %Split Training data into train and validation data
    Division = nearest(2/3)*size(Split_Data.building_0_train_df, 1);
    Training_Data = Split_Data.building_0_train_df(1:Division, :);
    Validation_Data = Split_Data.building_0_train_df((Division+1):end, :);

    %Reset validation data to building 0 test data
    valid = (Validation_Data(:, 1:312)).';
    
    %Reset training data to training for building section classification
    x1 = (Training_Data(:, 1:312)).';
    
    %Construct another feedforward network with one hidden layers of size
    %[5,5,5]
    net = feedforwardnet([5,5,5]);
    
    %Reset target for section data
    t = (Training_Data(:, 318)).';
     
    %Train the neural network to predict section
    net = train(net,x1,t);
    
    %Use the network for section prediction
    NN_Bin_Building_0_section_valid = (nearest(net(valid))).';


    %%%Check accuracy and stop if less than 95%
    NN_Bin_Building_0_True_Section = Validation_Data(:, 318);
    NN_Bin_Building_0_Section_Accuracy = Classification_Accuracy(NN_Bin_Building_0_section_valid, NN_Bin_Building_0_True_Section);

    if NN_Bin_Building_0_Section_Accuracy < 0.95
        return
    end

    %If accuracy is high enough, perform classification on test data
    %Initialize with -1s so unused rows are not confused
    NN_Bin_Building_0_Section_prediction = ones(size(Test_Data_Split, 1), 1);
    NN_Bin_Building_0_Section_prediction(:, :) = -1;

    %Find indices of building 0 in order to split
    %up further
    K = (Test_Data_Split(:, 318) == 0);
    input = (Test_Data_Split(K, 1:312)).';
    NN_Bin_Building_0_Section_prediction(K) = (nearest(net(input))).';


    %%%Classify observations using building 1 hyperplane
    
    %Split Training data into train and validation data
    Division = nearest(2/3)*size(Split_Data.building_1_train_df, 1);
    Training_Data = Split_Data.building_1_train_df(1:Division, :);
    Validation_Data = Split_Data.building_1_train_df((Division+1):end, :);

    %Reset validation data to building 1 test data
    valid = (Validation_Data(:, 1:312)).';
    
    %Reset training data to training for building section classification
    x1 = (Training_Data(:, 1:312)).';
    
    %Construct another feedforward network with one hidden layers of size
    %[5,5,5]
    net = feedforwardnet([5,5,5]);
    
    %Reset target for section data
    t = (Training_Data(:, 318)).';
     
    %Train the neural network to predict section
    net = train(net,x1,t);
    
    %Use the network for section prediction
    NN_Bin_Building_1_section_valid = (nearest(net(valid))).';


    %%%Check accuracy and stop if less than 95%
    NN_Bin_Building_1_True_Section = Validation_Data(:, 318);
    NN_Bin_Building_1_Section_Accuracy = Classification_Accuracy(NN_Bin_Building_1_section_valid, NN_Bin_Building_1_True_Section);

    if NN_Bin_Building_1_Section_Accuracy < 0.95
        return
    end

    %If accuracy is high enough, perform classification on test data
    %Initialize with -1s so unused rows are not confused
    NN_Bin_Building_1_Section_prediction = ones(size(Test_Data_Split, 1), 1);
    NN_Bin_Building_1_Section_prediction(:, :) = -1;

    %Find indices of building 1 in order to split
    %up further
    K = (Test_Data_Split(:, 318) == 1);
    input = (Test_Data_Split(K, 1:312)).';
    NN_Bin_Building_1_Section_prediction(K) = (nearest(net(input))).';
   

    %%%Classify observations using building 2 hyperplane
    
    %Split Training data into train and validation data
    Division = nearest(2/3)*size(Split_Data.building_2_train_df, 1);
    Training_Data = Split_Data.building_2_train_df(1:Division, :);
    Validation_Data = Split_Data.building_2_train_df((Division+1):end, :);

    %Reset validation data to building 1 test data
    valid = (Validation_Data(:, 1:312)).';
    
    %Reset training data to training for building section classification
    x1 = (Training_Data(:, 1:312)).';
    
    %Construct another feedforward network with one hidden layers of size
    %[5,5,5]
    net = feedforwardnet([5,5,5]);
    
    %Reset target for section data
    t = (Training_Data(:, 318)).';
     
    %Train the neural network to predict section
    net = train(net,x1,t);
    
    %Use the network for section prediction
    NN_Bin_Building_2_section_valid = (nearest(net(valid))).';


    %%%Check accuracy and stop if less than 95%
    NN_Bin_Building_2_True_Section = Validation_Data(:, 318);
    NN_Bin_Building_2_Section_Accuracy = Classification_Accuracy(NN_Bin_Building_2_section_valid, NN_Bin_Building_2_True_Section);

    if NN_Bin_Building_2_Section_Accuracy < 0.95
        return
    end

    %If accuracy is high enough, perform classification on test data
    %Initialize with -1s so unused rows are not confused
    NN_Bin_Building_2_Section_prediction = ones(size(Test_Data_Split, 1), 1);
    NN_Bin_Building_2_Section_prediction(:, :) = -1;

    %Find indices of building 1 in order to split
    %up further
    K = (Test_Data_Split(:, 318) == 1);
    input = (Test_Data_Split(K, 1:312)).';
    NN_Bin_Building_2_Section_prediction(K) = (nearest(net(input))).';

    %If all hyperplanes have high enough accuracy then add those predictions to the matrix 
    Test_Data_Split = [Test_Data_Split NN_Bin_Building_0_Section_prediction NN_Bin_Building_1_Section_prediction NN_Bin_Building_2_Section_prediction];

end