%File Name: CNN_Prediction
%Description: This function uses the RSSI Image information and
%neighborhood information in order to predict the location of the cell
%phones
%Inputs: The Data object, the RSSI image with neighborhoods matrix
%Outputs: Vectors containing the predicitons for floor, building, longitude,
%and latitude for the samples in the test set
%First created: 4/20/22
%Last Modified: 5/10/22
%Last Modified: 7/25/22 by Haiqing
%File Created By: Nora Agah

function [CNN_Longitude_Prediction, CNN_Latitude_Prediction, CNN_Floor_Prediction] = CNN_Prediction(CNN_Data, Training_Image_Folder, Test_Image_Folder, Train_Observations, Test_Observations, numPoints)
    

     %Put data into appropriate form
    numIms = size(Training_Image_Folder, 1);
    A = arrayDatastore(Training_Image_Folder);
    for i = 2:numIms
        arrds = arrayDatastore(Training_Image_Folder);
        A = [A arrds];
    end

    data = combine(A);


    %Put data into appropriate form
%      numIms = 45;
%  %   A = arrayDatastore(Training_Image_Folder);
% 
%      filePattern = fullfile (Training_Image_Folder,'**','*.mat');
%      imageFiles  = dir(filePattern); 
%      temp=load(fullfile(imageFiles(1).folder,imageFiles(1).name));
%     A = arrayDatastore(temp.RSSI_Image_Matrix);
%     for i = 2:numIms
%         temp = load(fullfile(imageFiles(i).folder,imageFiles(1).name));
%         arrds = arrayDatastore(temp.RSSI_Image_Matrix);
%         A = [A arrds];
%     end
% 
%     data = combine(A);
   

    filePattern = fullfile (Training_Image_Folder,'**','*.mat');
    
    imageFiles  = dir(filePattern); 
    

    %A = arrayDatastore(Training_Image_Folder);
    for i = 1:length(imageFiles)
        arrds = load(fullfile(imageFiles(i).folder,imageFiles(i).name));
        data{i}= arrds.RSSI_Image_Matrix;
    end
    
    data = data';

    data3= zeros(2,10,10);
  %  data4 = [data3, data3]




  %  data = reshape(data,[],1);

    %Make response vector that has labels for all three buildings 
    %(that's why we need 3 copies)
%    responses = zeros(3*size(Train_Observations, 1), 1);

%     for i = 1:size(Train_Observations, 1)
%         responses(3*(i-1)+1 : 3*(i-1)+3) = Train_Observations(i, 313);
%     end


    responses = Train_Observations(:,313);

 


    %flip(responses, 1);
%     layers = [
%             %The 1 indicates greyscale and the 5 is the number of floors
%             %image3dInputLayer([sqrt(numPoints) sqrt(numPoints) 1])
%             lstmLayer(128,'OutputMode','last')
%             convolution2dLayer(5,16,'Stride',4)
%             reluLayer
%             maxPooling2dLayer(2,'Stride',4)
%             %fullyConnectedLayer(10)
%             softmaxLayer
%             regressionLayer];

layers = [ ...
    %sequenceInputLayer(10)
    imageInputLayer([2 10 10])
    convolution2dLayer(3,6)
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    fullyConnectedLayer(1)
    softmaxLayer
    regressionLayer];


    miniBatchSize  = 128;
    %validationFrequency = floor(numel(responses)/miniBatchSize);
    options = trainingOptions('sgdm', ...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',30, ...
    'InitialLearnRate',1e-3, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.1, ...
    'LearnRateDropPeriod',20, ...
    'Shuffle','every-epoch', ...
    'Plots','training-progress', ...
    'Verbose',false);

%     options = trainingOptions('sgdm', ...
%     'InitialLearnRate',0.001, ...
%     'Verbose',false, ...
%     'Plots','training-progress');

    
%     lgraph = layerGraph(layers);
%     figure
%     plot(lgraph);
%     options = trainingOptions('sgdm');
    convnet_Longitude = trainNetwork(data3,responses, layers, options);

    %Train for latitude next
%     for i = 1:size(Train_Observations, 1)
%         responses(3*(i-1)+1 : 3*(i-1)+3)  = Train_Observations(i, 314);
%     end


    responses = Train_Observations(:,314);
    flip(responses, 1);
                
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
    convnet_Latitude = trainNetwork(data, responses, lgraph, options);


%     %Train for floor last
%     for i = 1:size(Train_Observations, 1)
%         responses(3*(i-1)+1 : 3*(i-1)+3) = Train_Observations(i, 315);
%     end

    responses = Train_Observations(:,315);

    flip(responses, 1);
%                 
%     layers = [
%           %The 1 indicates greyscale and the 5 is the number of floors
%           imageInputLayer([sqrt(numPoints) sqrt(numPoints) 5 1])
%           convolution3dLayer(5,20)
%           reluLayer
%           maxPooling3dLayer(2,'Stride',2)
%           fullyConnectedLayer(10)
%           softmaxLayer
%           classificationLayer];
%        lgraph = layerGraph(layers);
%        figure
%        plot(lgraph);
%     options = trainingOptions('sgdm');
    convnet_Floor = trainNetwork(data, responses, lgraph, options);

    %Use the convnets to make predictions
end