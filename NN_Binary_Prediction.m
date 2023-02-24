%File Name: NN_Binary_Prediction
%Description: This function uses feed forward neural networks and binary
%search on the WAPs in the train data set and predicts the building and floor of the samples in the test data set 
%Inputs: The Data object
%Outputs: Vectors containing the predicitons for binary .building and floor
%predictions for the samples in the test set
%First created: 11/13/21
%Last Modified: 12/12/21
%File Created By: Nora Agah


%NN_Bin_Section_prediction
function [NN_Bin_Building_1_or_2_prediction, NN_Bin_Building_0_or_1_prediction, ...
            NN_Bin_Building_0_Floor_1_or_2_prediction, NN_Bin_Building_0_Floor_0_or_1_prediction, ...
            NN_Bin_Building_0_Floor_2_or_3_prediction, NN_Bin_Longitude_prediction,  NN_Bin_Latitude_prediction, ...
            NN_Bin_Floor_2_Longitude_prediction, NN_Bin_Floor_2_Latitude_prediction, ...
            NN_Bin_Building_0_section_prediction, NN_Bin_Building_1_section_prediction, ...
            NN_Bin_Building_2_section_prediction, NN_Bin_Building_0_Section_0_Longitude_prediction, ...
            NN_Bin_Building_0_Section_0_Latitude_prediction, NN_Bin_Building_0_Section_1_Longitude_prediction, ...
            NN_Bin_Building_0_Section_1_Latitude_prediction, NN_Bin_Building_1_Section_0_Longitude_prediction, ...
            NN_Bin_Building_1_Section_0_Latitude_prediction, NN_Bin_Building_1_Section_1_Longitude_prediction, ...
            NN_Bin_Building_1_Section_1_Latitude_prediction, NN_Bin_Building_2_Section_0_Longitude_prediction, ...
            NN_Bin_Building_2_Section_0_Latitude_prediction, NN_Bin_Building_2_Section_1_Longitude_prediction, ...
            NN_Bin_Building_2_Section_1_Latitude_prediction] = NN_Binary_Prediction(NN_Binary_Data)
 

    %%%Classify into subcategories of buildings: Either building 0 and 1 or
    %%%building 2
    %Use transpose of matrices to fit formatting
    %Set training data to binary training set for 2 building
    %groups
    x1 = (NN_Binary_Data.binary_train_df(:, 1:312)).';
    
    %Set target to data with buildings in 2 catefories
    t = (NN_Binary_Data.binary_train_df(:, 317)).';
    
    %Set validation data to binary test set
    test = (NN_Binary_Data.binary_test_df(:, 1:312)).';
    
    %Construct a feedforward network with one hidden layer of size [5,5,5]
    net = feedforwardnet([5,5,5]);

    %Train the neural network to predict floors
    net = train(net,x1,t);
    
    %Use the network for building category prediction
    NN_Bin_Building_1_or_2_prediction = (nearest(net(test))).';


    
    %%%%Classify in to building 0 or 1
    %Reset validation data to building 0 or 1 test data
    test = (NN_Binary_Data.building_0_1_test_df(:, 1:312)).';
    
    %Reset training data to training for building 0 or 1 classification
    x1 = (NN_Binary_Data.building_0_1_train_df(:, 1:312)).';
    
    %Construct another feedforward network with one hidden layer of size [5,5,5]
    net = feedforwardnet([5,5,5]);
    
    %Reset target for building 0 or 1 data
    t = (NN_Binary_Data.building_0_1_train_df(:, 316)).';
     
    %Train the neural network to predict building
    net = train(net,x1,t);
    
    %Use the network for building prediction
    NN_Bin_Building_0_or_1_prediction = (nearest(net(test))).';



    %%%%Classify in to groups of floors
    %Reset validation data to building 0 floor 1 or 2 test data
    test = (NN_Binary_Data.building_0_test_df(:, 1:312)).';
    
    %Reset training data to training for building 0 or 1 classification
    x1 = (NN_Binary_Data.building_0_train_df(:, 1:312)).';
    
    %Construct another feedforward network with one hidden layer of size [5,5,5]
    net = feedforwardnet([5,5,5]);
    
    %Reset target for floor 1 or 2 data
    t = (NN_Binary_Data.building_0_train_df(:, 317)).';
     
    %Train the neural network to predict building
    net = train(net,x1,t);
    
    %Use the network for floor group prediction
    NN_Bin_Building_0_Floor_1_or_2_prediction = (nearest(net(test))).';



    %%%Classify as floor 0 or 1 
    %Reset validation data to building 0 floor 0 or 1 test data
    test = (NN_Binary_Data.floor_0_1_test_df(:, 1:312)).';
    
    %Reset training data to training for floor 0 or 1 classification
    x1 = (NN_Binary_Data.floor_0_1_train_df(:, 1:312)).';
    
    %Construct another feedforward network with one hidden layer of size [5,5,5]
    net = feedforwardnet([5,5,5]);
    
    %Reset target for floor 0 or 1 data
    t = (NN_Binary_Data.floor_0_1_train_df(:, 315)).';
     
    %Train the neural network to predict floor
    net = train(net,x1,t);
    
    %Use the network for floor prediction
    NN_Bin_Building_0_Floor_0_or_1_prediction = (nearest(net(test))).';



    %%%%Classify as floor 2 or 3
    %Reset validation data to building 0 floor 2 or 3 test data
    test = (NN_Binary_Data.floor_2_3_test_df(:, 1:312)).';
    
    %Reset training data to training for floor 2 or 3 classification
    x1 = (NN_Binary_Data.floor_2_3_train_df(:, 1:312)).';
    
    %Construct another feedforward network with one hidden layer of size [5,5,5]
    net = feedforwardnet([5,5,5]);
    
    %Reset target for floor 2 or 3 data
    t = (NN_Binary_Data.floor_2_3_train_df(:, 315)).';
     
    %Train the neural network to predict floor
    net = train(net,x1,t);
    
    %Use the network for floor prediction
    NN_Bin_Building_0_Floor_2_or_3_prediction = (nearest(net(test))).';

     

    %%%Classify observations into building 0 sections
    %Reset validation data to building 0 test data
    test = (NN_Binary_Data.building_0_test_df(:, 1:312)).';
    
    %Reset training data to training for building section classification
    x1 = (NN_Binary_Data.building_0_train_df(:, 1:312)).';
    
    %Construct another feedforward network with one hidden layers of size
    %[5,5,5]
    net = feedforwardnet([5,5,5]);
    
    %Reset target for section data
    t = (NN_Binary_Data.building_0_train_df(:, 318)).';
     
    %Train the neural network to predict section
    net = train(net,x1,t);
    
    %Use the network for section prediction
    NN_Bin_Building_0_section_prediction = (nearest(net(test))).';



    %%%Classify observations into building 1 sections
    %Reset validation data to building 1 test data
    test = (NN_Binary_Data.building_1_test_df(:, 1:312)).';
    
    %Reset training data to training for building section classification
    x1 = (NN_Binary_Data.building_1_train_df(:, 1:312)).';
    
    %Construct another feedforward network with one hidden layers of size
    %[5,5,5]
    net = feedforwardnet([5,5,5]);
    
    %Reset target for section data
    t = (NN_Binary_Data.building_1_train_df(:, 318)).';
     
    %Train the neural network to predict section
    net = train(net,x1,t);
    
    %Use the network for section prediction
    NN_Bin_Building_1_section_prediction = (nearest(net(test))).';


    %%%Classify observations into building 2 sections
    %Reset validation data to building 2 test data
    test = (NN_Binary_Data.building_2_test_df(:, 1:312)).';
    
    %Reset training data to training for building section classification
    x1 = (NN_Binary_Data.building_2_train_df(:, 1:312)).';
    
    %Construct another feedforward network with one hidden layers of size
    %[5,5,5]
    net = feedforwardnet([5,5,5]);
    
    %Reset target for section data
    t = (NN_Binary_Data.building_2_train_df(:, 318)).';
     
    %Train the neural network to predict section
    net = train(net,x1,t);
    
    %Use the network for section prediction
    NN_Bin_Building_2_section_prediction = (nearest(net(test))).';


    

    %%%Try regression on building 0 data
    %Reset training data to training for regression
    x1 = (NN_Binary_Data.building_0_train_df(:, 1:312)).';

    %Set validation data to test set
    test = (NN_Binary_Data.building_0_test_df(:, 1:312)).';

    %Construct a feedforward network with hidden layers of size [15, 15]
    net = feedforwardnet([15,15]);

    %Reset target for longitude data
    t = (NN_Binary_Data.building_0_train_df(:, 313)).';

    %Train the neural network to predict longitude
    net = train(net,x1,t);

    %Use the network for longitude prediction
    NN_Bin_Longitude_prediction = (net(test)).';



    %Construct a feedforward network with hidden layers of size [15, 15]
    net = feedforwardnet([15,15]);

    %Reset target for latitude data
    t = (NN_Binary_Data.building_0_train_df(:, 314)).';

    %Train the neural network to predict latitude
    net = train(net,x1,t);

    %Use the network for latitude prediction
    NN_Bin_Latitude_prediction = (net(test)).';



    %%%Try regression on building 0 floor 2 data

    %Reset training data to training for regression
    x1 = (NN_Binary_Data.floor_2_train_df(:, 1:312)).';

    %Set validation data to test set
    test = (NN_Binary_Data.floor_2_test_df (:, 1:312)).';

    %Construct a feedforward network with hidden layers of size [15, 15]
    net = feedforwardnet([15,15]);

    %Reset target for longitude data
    t = (NN_Binary_Data.floor_2_train_df(:, 313)).';

    %Train the neural network to predict longitude
    net = train(net,x1,t);

    %Use the network for longitude prediction
    NN_Bin_Floor_2_Longitude_prediction = (net(test)).';



    %Construct a feedforward network with hidden layers of size [15, 15]
    net = feedforwardnet([15,15]);

    %Reset target for latitude data
    t = (NN_Binary_Data.floor_2_train_df(:, 314)).';

    %Train the neural network to predict latitude
    net = train(net,x1,t);

    %Use the network for latitude prediction
    NN_Bin_Floor_2_Latitude_prediction = (net(test)).';



    %%%%%%%%%%%%
    %This section is the regressression code for the individual building
    %sections to see if splitting the code in to sections was advantageous
    %for longitude and latitude prediction
    
    %%%%%%Building 0 section 0 regression
    %Reset training data to training for regression
    x1 = (NN_Binary_Data.building_0_section_0_train_df(:, 1:312)).';

    %Set validation data to test set
    test = (NN_Binary_Data.building_0_section_0_test_df(:, 1:312)).';

    %Construct a feedforward network with hidden layers of variabls size
    net = feedforwardnet([10,10]);
    
    %Reset target for longitude data
    t = (NN_Binary_Data.building_0_section_0_train_df(:, 313)).';

    %Train the neural network to predict longitude
    net = train(net,x1,t);

    %Use the network for longitude prediction
    NN_Bin_Building_0_Section_0_Longitude_prediction = (net(test)).';



    %Construct a feedforward network with hidden layers of variabls size
    net = feedforwardnet([10,10]);
    
    %Reset target for latitude data
    t = (NN_Binary_Data.building_0_section_0_train_df(:, 314)).';

    %Train the neural network to predict latitude
    net = train(net,x1,t);

    %Use the network for latitude prediction
    NN_Bin_Building_0_Section_0_Latitude_prediction = (net(test)).';
    
    
    
    %%%%%Building 0 section 1 regression
    x1 = (NN_Binary_Data.building_0_section_1_train_df(:, 1:312)).';

    %Set validation data to test set
    test = (NN_Binary_Data.building_0_section_1_test_df(:, 1:312)).';

    %Construct a feedforward network with hidden layers of variabls size
    net = feedforwardnet([10,10]);

    %Reset target for longitude data
    t = (NN_Binary_Data.building_0_section_1_train_df(:, 313)).';

    %Train the neural network to predict longitude
    net = train(net,x1,t);

    %Use the network for longitude prediction
    NN_Bin_Building_0_Section_1_Longitude_prediction = (net(test)).';



    %Construct a feedforward network with hidden layers of variabls size
    net = feedforwardnet([10,10]);

    %Reset target for latitude data
    t = (NN_Binary_Data.building_0_section_1_train_df(:, 314)).';

    %Train the neural network to predict latitude
    net = train(net,x1,t);

    %Use the network for latitude prediction
    NN_Bin_Building_0_Section_1_Latitude_prediction = (net(test)).';
    
    
    
    
    %%%%%Building 1 section 0 regression
    x1 = (NN_Binary_Data.building_1_section_0_train_df(:, 1:312)).';

    %Set validation data to test set
    test = (NN_Binary_Data.building_1_section_0_test_df(:, 1:312)).';

    %Construct a feedforward network with hidden layers of variabls size
    net = feedforwardnet([10,10]);

    %Reset target for longitude data
    t = (NN_Binary_Data.building_1_section_0_train_df(:, 313)).';

    %Train the neural network to predict longitude
    net = train(net,x1,t);

    %Use the network for longitude prediction
    NN_Bin_Building_1_Section_0_Longitude_prediction = (net(test)).';



    %Construct a feedforward network with hidden layers of variabls size
    net = feedforwardnet([10,10]);

    %Reset target for latitude data
    t = (NN_Binary_Data.building_1_section_0_train_df(:, 314)).';

    %Train the neural network to predict latitude
    net = train(net,x1,t);

    %Use the network for latitude prediction
    NN_Bin_Building_1_Section_0_Latitude_prediction = (net(test)).';
    
    
    
    %%%%%Building 1 section 1 regression
    x1 = (NN_Binary_Data.building_1_section_1_train_df(:, 1:312)).';

    %Set validation data to test set
    test = (NN_Binary_Data.building_1_section_1_test_df(:, 1:312)).';

    %Construct a feedforward network with hidden layers of variabls size
    net = feedforwardnet([10,10]);

    %Reset target for longitude data
    t = (NN_Binary_Data.building_1_section_1_train_df(:, 313)).';

    %Train the neural network to predict longitude
    net = train(net,x1,t);

    %Use the network for longitude prediction
    NN_Bin_Building_1_Section_1_Longitude_prediction = (net(test)).';



    %Construct a feedforward network with hidden layers of variabls size
    net = feedforwardnet([10,10]);

    %Reset target for latitude data
    t = (NN_Binary_Data.building_1_section_1_train_df(:, 314)).';

    %Train the neural network to predict latitude
    net = train(net,x1,t);

    %Use the network for latitude prediction
    NN_Bin_Building_1_Section_1_Latitude_prediction = (net(test)).';
    
    
    
    %%%%%%Building 2 section 0 regression
    x1 = (NN_Binary_Data.building_2_section_0_train_df(:, 1:312)).';

    %Set validation data to test set
    test = (NN_Binary_Data.building_2_section_0_test_df(:, 1:312)).';

    %Construct a feedforward network with hidden layers of variable size
    net = feedforwardnet([10,10]);

    %Reset target for longitude data
    t = (NN_Binary_Data.building_2_section_0_train_df(:, 313)).';

    %Train the neural network to predict longitude
    net = train(net,x1,t);

    %Use the network for longitude prediction
    NN_Bin_Building_2_Section_0_Longitude_prediction = (net(test)).';



    %Construct a feedforward network with hidden layers of variabls size
    net = feedforwardnet([10,10]);

    %Reset target for latitude data
    t = (NN_Binary_Data.building_2_section_0_train_df(:, 314)).';

    %Train the neural network to predict latitude
    net = train(net,x1,t);

    %Use the network for latitude prediction
    NN_Bin_Building_2_Section_0_Latitude_prediction = (net(test)).';
    
    
    
    %%%%%%Building 2 section 1 regression
    x1 = (NN_Binary_Data.building_2_section_1_train_df(:, 1:312)).';

    %Set validation data to test set
    test = (NN_Binary_Data.building_2_section_1_test_df(:, 1:312)).';

    %Construct a feedforward network with hidden layers of variabls size
    net = feedforwardnet([10,10]);

    %Reset target for longitude data
    t = (NN_Binary_Data.building_2_section_1_train_df(:, 313)).';

    %Train the neural network to predict longitude
    net = train(net,x1,t);

    %Use the network for longitude prediction
    NN_Bin_Building_2_Section_1_Longitude_prediction = (net(test)).';



    %Construct a feedforward network with hidden layers of variabls size
    net = feedforwardnet([10,10]);

    %Reset target for latitude data
    t = (NN_Binary_Data.building_2_section_1_train_df(:, 314)).';

    %Train the neural network to predict latitude
    net = train(net,x1,t);

    %Use the network for latitude prediction
    NN_Bin_Building_2_Section_1_Latitude_prediction = (net(test)).';
    
    
end