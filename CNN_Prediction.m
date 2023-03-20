%File Name: CNN_Prediction
%Description: This function uses the RSSI Image information and
%neighborhood information in order to predict the location of the cell
%phones
%Inputs: The Data object, the RSSI image with neighborhoods matrix
%Outputs: Vectors containing the predicitons for floor, building, longitude,
%and latitude for the samples in the test set
%First created: 4/20/22
%Last Modified: 10/6/22
%File Created By: Nora Agah

%function [CNN_Longitude_Prediction, CNN_Latitude_Prediction, CNN_Floor_Prediction] = CNN_Prediction(Training_Image_Folder, Test_Image_Folder, Train_Observations, Test_Observations, numPoints)
function [CNN_Longitude_Prediction, CNN_Latitude_Prediction, CNN_Floor_Prediction] = CNN_Prediction(Loc_Training_Image_Folder, Loc_Test_Image_Folder, Floor_Training_Image_Folder, Floor_Test_Image_Folder, Loc_Train_Observations, Loc_Test_Observations, Floor_Train_Observations, Floor_Test_Observations, numPoints)
    

%%% HX: something wrong in the following block. I'll look at them today. 

    %Put data into appropriate form
%     numIms = size(Training_Image_Folder, 1);
% 
%     numIms = 45;
%     A = arrayDatastore(Training_Image_Folder);
%     for i = 2:numIms
%         arrds = arrayDatastore(Training_Image_Folder);
%         A = [A arrds];
%     end
% 
%     data = combine(A);

% Load in longitude and latitude training data
    filePattern = fullfile (Loc_Training_Image_Folder,'**','*.mat');
    
    imageFiles  = dir(filePattern); 
    
    loc_data = zeros(sqrt(numPoints),sqrt(numPoints),1,size(Loc_Train_Observations, 1));
    %A = arrayDatastore(Training_Image_Folder);
    for i = 1:length(imageFiles)
        arrds = load(fullfile(imageFiles(i).folder,imageFiles(i).name));
        loc_data(:,:,1,i) = arrds.RSSI_Image_Matrix;
    end
    
%Load in longitude and latitude test data
    filePattern = fullfile (Loc_Test_Image_Folder,'**','*.mat');
    
    imageFiles  = dir(filePattern); 
    
    loc_test_data = zeros(sqrt(numPoints),sqrt(numPoints),1,size(Loc_Test_Observations, 1));
    %A = arrayDatastore(Training_Image_Folder);
    for i = 1:length(imageFiles)
        arrds = load(fullfile(imageFiles(i).folder,imageFiles(i).name));
        loc_test_data(:,:,1,i) = arrds.RSSI_Image_Matrix;
    end
    
% Load in floor training data
    filePattern = fullfile (Floor_Training_Image_Folder,'**','*.mat');
    
    imageFiles  = dir(filePattern); 
    
    floor_data = zeros(sqrt(numPoints),sqrt(numPoints),1,size(Floor_Train_Observations, 1));
    %A = arrayDatastore(Training_Image_Folder);
    for i = 1:length(imageFiles)
        arrds = load(fullfile(imageFiles(i).folder,imageFiles(i).name));
        floor_data(:,:,1,i) = arrds.RSSI_Image_Matrix;
    end
    
%Load in floor test data
    filePattern = fullfile (Floor_Test_Image_Folder,'**','*.mat');
    
    imageFiles  = dir(filePattern); 
    
    floor_test_data = zeros(sqrt(numPoints),sqrt(numPoints),1,size(Floor_Test_Observations, 1));
    %A = arrayDatastore(Training_Image_Folder);
    for i = 1:length(imageFiles)
        arrds = load(fullfile(imageFiles(i).folder,imageFiles(i).name));
        floor_test_data(:,:,1,i) = arrds.RSSI_Image_Matrix;
    end

%     filePattern = fullfile (Training_Image_Folder,'**','*.mat');
%     
%     imageFiles  = dir(filePattern); 
%     
% 
%     %A = arrayDatastore(Training_Image_Folder);
%     for i = 1:length(imageFiles)
%         arrds = load(fullfile(imageFiles(i).folder,imageFiles(i).name));
%         data{i}= arrds.RSSI_Image_Matrix;
%     end
%     
%     data = data';
% 
%     size(data)





    %Make response vector that has labels for all three buildings 
    %(that's why we need 3 copies)
%     responses = zeros(3*size(Train_Observations, 1), 1);
%     
%     for i = 1:size(Train_Observations, 1)
%         responses(3*(i-1)+1 : 3*(i-1)+3) = Train_Observations(i, 313);
%     end
% 
%     flip(responses, 1);

    %train for longitude first, make values positive for sdgm
    responses = Loc_Train_Observations(:,313);


    layers = [
                %The 1 indicates greyscale and the 5 is the number of floors
                imageInputLayer([sqrt(numPoints),sqrt(numPoints) 1])
            
                convolution2dLayer(3,8,'Padding','same')
                batchNormalizationLayer
                reluLayer
                averagePooling2dLayer(2,'Stride',2)
                convolution2dLayer(3,16,'Padding','same')
                batchNormalizationLayer
                reluLayer
                averagePooling2dLayer(2,'Stride',2)
%                 convolution2dLayer(3,32,'Padding','same')
%                 batchNormalizationLayer
%                 reluLayer
                dropoutLayer(0.2)
                fullyConnectedLayer(1)
                regressionLayer];

    lgraph = layerGraph(layers);
    figure
    plot(lgraph);
    options = trainingOptions('sgdm');
    disp(responses);
    convnet_Longitude = trainNetwork(loc_data, responses, lgraph, options);

    %Train for latitude next
%     for i = 1:size(Train_Observations, 1)
%         responses(3*(i-1)+1 : 3*(i-1)+3)  = Train_Observations(i, 314);
%     end
    
    responses = Loc_Train_Observations(:,314);

        layers = [
                %The 1 indicates greyscale and the 5 is the number of floors
                imageInputLayer([sqrt(numPoints),sqrt(numPoints) 1])
            
                convolution2dLayer(3,8,'Padding','same')
                batchNormalizationLayer
                reluLayer
                averagePooling2dLayer(2,'Stride',2)
                convolution2dLayer(3,16,'Padding','same')
                batchNormalizationLayer
                reluLayer
                averagePooling2dLayer(2,'Stride',2)
%                 convolution2dLayer(3,32,'Padding','same')
%                 batchNormalizationLayer
%                 reluLayer
                dropoutLayer(0.2)
                fullyConnectedLayer(1)
                regressionLayer];

%     flip(responses, 1);
                
%     layers = [
%           %The 1 indicates greyscale and the 5 is the number of floors
%           imageInputLayer([sqrt(numPoints) sqrt(numPoints) 5 1])
%           convolution3dLayer(5,20)
%           reluLayer
%           maxPooling3dLayer(2,'Stride',2)
%           fullyConnectedLayer(10)
%           softmaxLayer
%           regressionLayer];
%     lgraph = layerGraph(layers);
%     figure
%     plot(lgraph);
%     options = trainingOptions('sgdm');

    disp(responses)
    lgraph = layerGraph(layers);
    figure
    plot(lgraph);
    options = trainingOptions('sgdm');
    %Use same NN settings as before
    convnet_Latitude = trainNetwork(loc_data, responses, lgraph, options);


    %Train for floor last
%     for i = 1:size(Train_Observations, 1)
%         responses(3*(i-1)+1 : 3*(i-1)+3) = Train_Observations(i, 315);
%     end
% 
%     flip(responses, 1);
%                 

    responses = categorical(Floor_Train_Observations(:,315));
    
    disp(responses)
    layers = [
                %The 1 indicates greyscale and the 5 is the number of floors
                imageInputLayer([sqrt(numPoints),sqrt(numPoints) 1])

                convolution2dLayer(3,8,'Padding','same')
                batchNormalizationLayer
                reluLayer
                
                maxPooling2dLayer(2,'Stride',2)
                
                convolution2dLayer(3,16,'Padding','same')
                batchNormalizationLayer
                reluLayer
                
                maxPooling2dLayer(2,'Stride',2)
                
%                 convolution2dLayer(3,32,'Padding','same')
%                 batchNormalizationLayer
%                 reluLayer
                %Change this to 5 when you add in building 2 which has 5
                %floors
                fullyConnectedLayer(4)
                softmaxLayer
                classificationLayer];
        lgraph = layerGraph(layers);
        figure
        plot(lgraph);
     options = trainingOptions('sgdm');

    convnet_Floor = trainNetwork(floor_data, responses, lgraph, options);

    %Use the convnets to make predictions
    CNN_Longitude_Prediction = predict(convnet_Longitude, loc_test_data);

    CNN_Latitude_Prediction = predict(convnet_Latitude, loc_test_data);

    %Predict the one with the least loss
    %[M, CNN_Floor_Prediction] = min(double(predict(convnet_Floor, floor_test_data)), [], 2);

    %CNN_Floor_Prediction = CNN_Floor_Prediction - 1;

    CNN_Floor_Prediction = double(classify(convnet_Floor, floor_test_data));

end