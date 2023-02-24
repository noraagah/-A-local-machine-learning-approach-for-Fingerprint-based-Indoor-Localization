%%File Name: NN_Binary_Split
%Description: This function uses feed forward neural networks and binary
%split on the WAPs in the train data set and stops splitting when accruacy
%goes below 95% or when 
%Inputs: The Data object
%Outputs: Vectors containing the predicitons for binary building and floor
%predictions for the samples in the test set
%First created: 3/20/22
%Last Modified: 4/3/22
%File Created By: Nora Agah

function [NN_Bin_Building_0_and_1_or_2_prediction, NN_Bin_Building_0_or_1_prediction, NN_Bin_Building_0_section_prediction, NN_Bin_Building_1_section_prediction, ...
            NN_Bin_Building_2_section_prediction] = NN_Binary_Split(Split_Data)

    
    %Initilize the vectors to an unused value
    NN_Bin_Building_0_and_1_or_2_prediction = ones(size((Split_Data.binary_test_df(:, 1)).'));
    NN_Bin_Building_0_and_1_or_2_prediction(:, :) = -1;
    NN_Bin_Building_0_or_1_prediction = ones(size((Split_Data.binary_test_df(:, 1)).'));
    NN_Bin_Building_0_or_1_prediction(:, :) = -1; 
    NN_Bin_Building_0_section_prediction = ones(size((Split_Data.binary_test_df(:, 1)).'));
    NN_Bin_Building_0_section_prediction(:, :) = -1;
    NN_Bin_Building_1_section_prediction = ones(size((Split_Data.binary_test_df(:, 1)).'));
    NN_Bin_Building_1_section_prediction(:, :) = -1;
    NN_Bin_Building_2_section_prediction = ones(size((Split_Data.binary_test_df(:, 1)).'));
    NN_Bin_Building_2_section_prediction(:, :) = -1;

    %%%Classify as either building 0 and 1 or building 2
    %Labeling 0 and 1 as 1 and 2 as 2
    x1 = (Split_Data.binary_train_df(:, 1:312)).';
    
    %Set target to data with buildings in 2 categories
    t = (Split_Data.binary_train_df(:, 317)).';
    
    %Set validation data to binary test set
    test = (Split_Data.binary_test_df(:, 1:312)).';
    
    %Construct a feedforward network with one hidden layer of size [5,5,5]
    net = feedforwardnet([5,5,5]);

    %Train the neural network to predict floors
    net = train(net,x1,t);
    
    %Use the network for building category prediction
    NN_Bin_Building_0_and_1_or_2_prediction = (nearest(net(test))).';


    %%%Check accuracy and stop if less than 95%
  
    NN_Bin_0_and_1_or_2_True_Buildings = Split_Data.binary_test_df(:, 317);
    NN_Bin_Building_0_and_1_or_2_Accuracy = Classification_Accuracy(NN_Bin_Building_0_and_1_or_2_prediction, NN_Bin_0_and_1_or_2_True_Buildings);
    disp(NN_Bin_Building_0_and_1_or_2_Accuracy);

    if NN_Bin_Building_0_and_1_or_2_Accuracy < 0.95
        return
    end
    

    %%%%Classify in to building 0 or 1
    %Reset validation data to building 0 or 1 test data
    test = (Split_Data.building_0_1_test_df(:, 1:312)).';
    
    %Reset training data to training for building 0 or 1 classification
    x1 = (Split_Data.building_0_1_train_df(:, 1:312)).';
    
    %Construct another feedforward network with one hidden layer of size [5,5,5]
    net = feedforwardnet([5,5,5]);
    
    %Reset target for building 0 or 1 data
    t = (Split_Data.building_0_1_train_df(:, 316)).';
     
    %Train the neural network to predict building
    net = train(net,x1,t);
    
    %Use the network for building prediction
    NN_Bin_Building_0_or_1_prediction = (nearest(net(test))).';


    %%%Check accuracy and stop if less than 95%

    NN_Bin_0_or_1_True_Buildings  = Split_Data.building_0_1_test_df(:, 316);
    NN_Bin_Building_0_or_1_Accuracy = Classification_Accuracy(NN_Bin_Building_0_or_1_prediction, NN_Bin_0_or_1_True_Buildings);
    disp(NN_Bin_Building_0_or_1_Accuracy);

    if NN_Bin_Building_0_or_1_Accuracy < 0.95
        return
    end

    %%%Classify observations using building 0 hyperplane
    %Reset validation data to building 0 test data
    test = (Split_Data.building_0_test_df(:, 1:312)).';
    
    %Reset training data to training for building section classification
    x1 = (Split_Data.building_0_train_df(:, 1:312)).';
    
    %Construct another feedforward network with one hidden layers of size
    %[5,5,5]
    net = feedforwardnet([5,5,5]);
    
    %Reset target for section data
    t = (Split_Data.building_0_train_df(:, 318)).';
     
    %Train the neural network to predict section
    net = train(net,x1,t);
    
    %Use the network for section prediction
    NN_Bin_Building_0_section_prediction = (nearest(net(test))).';


    %%%Check accuracy and stop if less than 95%
    NN_Bin_Building_0_True_Section = Split_Data.building_0_test_df(:, 318);
    NN_Bin_Building_0_Section_Accuracy = Classification_Accuracy(NN_Bin_Building_0_section_prediction, NN_Bin_Building_0_True_Section);
    disp(NN_Bin_Building_0_Section_Accuracy);

    if NN_Bin_Building_0_Section_Accuracy < 0.95
        return
    end


    %%%Classify observations using building 1 hyperplane
    %Reset validation data to building 1 test data
    test = (Split_Data.building_1_test_df(:, 1:312)).';
    
    %Reset training data to training for building section classification
    x1 = (Split_Data.building_1_train_df(:, 1:312)).';
    
    %Construct another feedforward network with one hidden layers of size
    %[5,5,5]
    net = feedforwardnet([5,5,5]);
    
    %Reset target for section data
    t = (Split_Data.building_1_train_df(:, 318)).';
     
    %Train the neural network to predict section
    net = train(net,x1,t);
    
    %Use the network for section prediction
    NN_Bin_Building_1_section_prediction = (nearest(net(test))).';

    %%%Check accuracy and stop if less than 95%
    NN_Bin_Building_1_True_Section = Split_Data.building_1_test_df(:, 318);
    NN_Bin_Building_1_Section_Accuracy = Classification_Accuracy(NN_Bin_Building_1_section_prediction, NN_Bin_Building_1_True_Section);
    disp(NN_Bin_Building_1_Section_Accuracy);

    if NN_Bin_Building_1_Section_Accuracy < 0.95
        %Reset so all buildings can be split the same way
        NN_Bin_Building_0_section_prediction(:, :) = -1;
        return
    end


    %%%Classify observations using building 2 hyperplanes
    %Reset validation data to building 2 test data
    test = (Split_Data.building_2_test_df(:, 1:312)).';
    
    %Reset training data to training for building section classification
    x1 = (Split_Data.building_2_train_df(:, 1:312)).';
    
    %Construct another feedforward network with one hidden layers of size
    %[5,5,5]
    net = feedforwardnet([5,5,5]);
    
    %Reset target for section data
    t = (Split_Data.building_2_train_df(:, 318)).';
     
    %Train the neural network to predict section
    net = train(net,x1,t);
    
    %Use the network for section prediction
    NN_Bin_Building_2_section_prediction = (nearest(net(test))).';


    %%%Check accuracy and stop if less than 95%
    NN_Bin_Building_2_True_Section = Split_Data.building_2_test_df(:, 318);
    NN_Bin_Building_2_Section_Accuracy = Classification_Accuracy(NN_Bin_Building_2_section_prediction, NN_Bin_Building_2_True_Section);
    disp(NN_Bin_Building_2_Section_Accuracy);

    if NN_Bin_Building_2_Section_Accuracy < 0.95
         %Reset so all buildings can be split the same way
         NN_Bin_Building_0_section_prediction(:, :) = -1;
         NN_Bin_Building_1_section_prediction(:, :) = -1;
        return
    end

end