
%function [CNN_Longitude_Prediction, CNN_Latitude_Prediction, CNN_Floor_Prediction] = CNN_Prediction(Loc_Training_Image_Folder, Loc_Test_Image_Folder, Floor_Training_Image_Folder, Floor_Test_Image_Folder, Loc_Train_Observations, Loc_Test_Observations, Floor_Train_Observations, Floor_Test_Observations, numPoints)


function [CNN_Floor_Prediction] = CNN_Prediction(Loc_Training_Image_Folder, Loc_Test_Image_Folder, Floor_Training_Image_Folder, Floor_Test_Image_Folder, Floor_Train_Observations, Floor_Test_Observations, numPoints)

%function [CNN_Floor_Prediction] = CNN_Prediction(Loc_Training_Image_Folder, Loc_Test_Image_Folder, Floor_Training_Image_Folder, Floor_Test_Image_Folder, Loc_Train_Observations, Loc_Test_Observations, Floor_Train_Observations, Floor_Test_Observations, numPoints)

%Load in longitude and latitude training data
%     filePattern = fullfile (Loc_Training_Image_Folder,'**','*.mat');
%     
%     imageFiles  = dir(filePattern); 
%     
%     loc_data = zeros(sqrt(numPoints),sqrt(numPoints),1,size(Loc_Train_Observations, 1));
%     for i = 1:length(imageFiles)
%         arrds = load(fullfile(imageFiles(i).folder,imageFiles(i).name));
%         loc_data(:,:,1,i) = arrds.RSSI_Image_Matrix;
%     end
%     
% %Load in longitude and latitude test data
%     filePattern = fullfile (Loc_Test_Image_Folder,'**','*.mat');
%     
%     imageFiles  = dir(filePattern); 
%     
%     loc_test_data = zeros(sqrt(numPoints),sqrt(numPoints),1,size(Loc_Test_Observations, 1));
%     %A = arrayDatastore(Training_Image_Folder);
%     for i = 1:length(imageFiles)
%         arrds = load(fullfile(imageFiles(i).folder,imageFiles(i).name));
%         loc_test_data(:,:,1,i) = arrds.RSSI_Image_Matrix;
%     end
    



    responses = categorical(Floor_Train_Observations(:,315));
% Load in floor training data
    filePattern = fullfile (Floor_Training_Image_Folder,'**','*.mat');
    
    imageFiles  = dir(filePattern); 
    
    floor_data = zeros(9,9,4,1,size(Floor_Train_Observations, 1));

    rand_index_train = randsample(length(imageFiles),length(imageFiles)); 
    %A = arrayDatastore(Training_Image_Folder);
    for j = 1:length(imageFiles)
        i = rand_index_train(j);
        
        arrds = load(fullfile(imageFiles(i).folder,imageFiles(i).name));
        floor_data(:,:,:,1,i) = arrds.RSSI_Image_Matrix;
%         if responses(i)=='2';
%             i
% 
%          max(floor_data(:,:,1,i)) 
%          max(floor_data(:,:,2,i))
%          max(floor_data(:,:,3,i))
%          max(floor_data(:,:,4,i))
%        
 %            responses(i) 
%          pause;
%          end
    end


%Load in floor test data
    filePattern = fullfile (Floor_Test_Image_Folder,'**','*.mat');
    
    imageFiles  = dir(filePattern); 
    
    floor_test_data = zeros(9,9,4,1,size(Floor_Test_Observations, 1));
  %  rand_index_test = randsample(length(imageFiles),length(imageFiles)); 

    %A = arrayDatastore(Training_Image_Folder);
    for i = 1:length(imageFiles)
        %i = rand_index_test(j);
        arrds = load(fullfile(imageFiles(i).folder,imageFiles(i).name));
        floor_test_data(:,:,:,1,i) = arrds.RSSI_Image_Matrix;
    end



% 
%     %train for longitude first, make values positive for sdgm
%     responses = abs(Loc_Train_Observations(:,313));
% 
% 
% % 
% %     layers = [ ...
% %         imageInputLayer([sqrt(numPoints),sqrt(numPoints) 1])
% %         convolution2dLayer(12,25)
% %         reluLayer
% %         fullyConnectedLayer(1)
% %         regressionLayer]
% 
%     options = trainingOptions('sgdm', ...
%     'InitialLearnRate',0.0002, ...
%     'Verbose',false, ...
%     'Plots','training-progress');
% 
% 
% %     layers = [
% %                 %The 1 indicates greyscale and the 5 is the number of floors
% %                 imageInputLayer([sqrt(numPoints),sqrt(numPoints) 1])
% %             
% %                 convolution2dLayer(3,8,'Padding','same')
% %                 batchNormalizationLayer
% % 
% %                 reluLayer
% %                 batchNormalizationLayer
% % 
% %                 averagePooling2dLayer(2,'Stride',2)
% %                 batchNormalizationLayer
% % 
% %                 convolution2dLayer(3,16,'Padding','same')
% %                 batchNormalizationLayer
% % 
% %                 reluLayer
% %                 batchNormalizationLayer
% % 
% %                 averagePooling2dLayer(2,'Stride',2)
% % %                 convolution2dLayer(3,32,'Padding','same')
% % %                 batchNormalizationLayer
% % %                 reluLayer
% %                 dropoutLayer(0.1)
% %                 fullyConnectedLayer(1)
% %                 regressionLayer];
% 
%         layers = [
%                 %The 1 indicates greyscale and the 5 is the number of floors
%                 imageInputLayer([sqrt(numPoints),sqrt(numPoints) 1])
%             
%                 convolution2dLayer(3,8,'Padding','same')
%                 batchNormalizationLayer
%                 reluLayer
%                 averagePooling2dLayer(2,'Stride',2)
%                 convolution2dLayer(3,16,'Padding','same')
%                 batchNormalizationLayer
%                 reluLayer
%                 averagePooling2dLayer(2,'Stride',2)
% %                 convolution2dLayer(3,32,'Padding','same')
% %                 batchNormalizationLayer
% %                 reluLayer
%                 dropoutLayer(0.2)
%                 fullyConnectedLayer(1)
%                 regressionLayer];
% 
% 
%      lgraph = layerGraph(layers);
% %     figure
% %     plot(lgraph);
%   %  options = trainingOptions('sgdm');
% 
%     convnet_Longitude = trainNetwork(loc_data, responses, lgraph, options);
% 
%     %Train for latitude next
% %     for i = 1:size(Train_Observations, 1)
% %         responses(3*(i-1)+1 : 3*(i-1)+3)  = Train_Observations(i, 314);
% %     end
%     
%   responses = abs(Loc_Train_Observations(:,314));
% 
% %    layers = [ ...
% %         imageInputLayer([sqrt(numPoints),sqrt(numPoints) 1])
% %         convolution2dLayer(12,25)
% %         reluLayer
% %         fullyConnectedLayer(1)
% %         regressionLayer]
% 
% 
%     %responses = Loc_Train_Observations(:,314);
% 
% %         layers = [
% %                 %The 1 indicates greyscale and the 5 is the number of floors
% %                 imageInputLayer([sqrt(numPoints),sqrt(numPoints) 1])
% %             
% %                 convolution2dLayer(3,8,'Padding','same')
% %                 batchNormalizationLayer
% %                 reluLayer
% %                 averagePooling2dLayer(2,'Stride',2)
% %                 convolution2dLayer(3,16,'Padding','same')
% %                 batchNormalizationLayer
% %                 reluLayer
% %                 averagePooling2dLayer(2,'Stride',2)
% % %                 convolution2dLayer(3,32,'Padding','same')
% % %                 batchNormalizationLayer
% % %                 reluLayer
% %                 dropoutLayer(0.2)
% %                 fullyConnectedLayer(1)
% %                 regressionLayer];
% 
%     lgraph = layerGraph(layers);
%     figure
%     plot(lgraph);
%     options = trainingOptions('sgdm');
%     %Use same NN settings as before
%     convnet_Latitude = trainNetwork(loc_data, responses, lgraph, options);
% 


%    responses =responses';





    layers = [
    image3dInputLayer([9, 9, 4])
    convolution3dLayer(2,20,'Stride',4)
    batchNormalizationLayer
    reluLayer
    maxPooling3dLayer(1,'Stride',4)
    fullyConnectedLayer(4)
    softmaxLayer
    classificationLayer]


    

    
%   %  disp(responses)
%     layers = [
%                 %The 1 indicates greyscale and the 5 is the number of floors
%                 imageInputLayer([50,100,4,1])
%                 
% 
%                 convolution2dLayer(3,20,'Padding','same')
%                 batchNormalizationLayer
%                 reluLayer
%                 
%                 maxPooling2dLayer(2,'Stride',2)
%                 
%                 convolution2dLayer(3,16,'Padding','same')
%                 batchNormalizationLayer
%                 reluLayer
%                 
%               %  maxPooling2dLayer(2,'Stride',2)
%                 
% %                 convolution2dLayer(3,32,'Padding','same')
% %                 batchNormalizationLayer
% %                 reluLayer
%                  dropoutLayer(0.1)
%                 fullyConnectedLayer(4)
%                 softmaxLayer
%                 classificationLayer];
        lgraph = layerGraph(layers);
        figure
        plot(lgraph);


%         options = trainingOptions('adam', ...
%     'MaxEpochs',400,...
%     'InitialLearnRate',0.05, ...
%     'Verbose',false, ...
%     'Plots','training-progress');
% % %     options = trainingOptions('sgdm');
% 
% options = trainingOptions('adam', ...
%     'MaxEpochs',100,...
%     'InitialLearnRate',1e-3, ...
%     'Verbose',false, ...
%     'Plots','training-progress');


maxEpochs = 50;
miniBatchSize = 20;

options = trainingOptions('sgdm', ...
    'ExecutionEnvironment','cpu', ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'InitialLearnRate',1e-4, ...
    'GradientThreshold',0.1, ...
    'Verbose',false, ...
    'Plots','training-progress');
    


    convnet_Floor = trainNetwork(floor_data, responses, lgraph, options);

  
    Floor_prediction_in_sample = predict(convnet_Floor, floor_data);

    [M_in_sample, Floor_in_sample_prediction] = max(double(predict(convnet_Floor, floor_data)), [], 2);

    

    [M_out_sample, Floor_out_sample_prediction] = max(double(predict(convnet_Floor, floor_test_data)), [], 2);


%     CNN_Longitude_Prediction = predict(convnet_Longitude, loc_test_data);
% 
%     CNN_Latitude_Prediction = predict(convnet_Latitude, loc_test_data);



    [M, CNN_Floor_Prediction] = max(double(predict(convnet_Floor, floor_test_data)), [], 2);
    CNN_Floor_Prediction=CNN_Floor_Prediction-1;

