
function [CNN_Loc_Prediction] = CNN_Loc_Prediction_1226(Floor_Train, Floor_Test)

    num = size(Floor_Train,2)-4;

%    responses = categorical(Floor_Train(:,size(Floor_Train,2)-3));

  mm =size(Floor_Train,2);

   responses = abs(Floor_Train(:,mm-3:mm-2));
   mean_r = mean(responses);
   std_r  = std(responses);
   
   responses = (responses-mean_r)./std_r;


   RSSI_train_data  = -105*ones(num,1,1,size(Floor_Train, 1));
   RSSI_test_data   = -105*ones(num,1,1,size(Floor_Test, 1));


    for i = 1:size(Floor_Train, 1)
        RSSI_train_data(:,1,1,i) = Floor_Train(i,1:num)'; 
    end

%     for i = 1:size(Floor_Train2, 1)
%         RSSI_train2_data(:,1,1,i) = Floor_Train2(i,2:num)'; 
%     end

    for i = 1:size(Floor_Test, 1)
        RSSI_test_data(:,1,1,i) = Floor_Test(i,1:num)'; 
    end

    imageSize=[num 1];



    layers = [
                %The 1 indicates greyscale and the 5 is the number of floors
                imageInputLayer(imageSize)

                batchNormalizationLayer

                fullyConnectedLayer(256);
                reluLayer

                fullyConnectedLayer(128);
                reluLayer

                fullyConnectedLayer(64);
                reluLayer
% 
%                 fullyConnectedLayer(32);
%                 reluLayer
% % % 
%                 fullyConnectedLayer(16);
%                 reluLayer
% % 
                fullyConnectedLayer(8);
                reluLayer
% 

               fullyConnectedLayer(4);
               reluLayer

     %           dropoutLayer(0.2)
                fullyConnectedLayer(2);
%               reluLayer
%                 fullyConnectedLayer(4);
%             
%                 convolution2dLayer([1,1],50,'Padding','same')
%                 batchNormalizationLayer
%                 reluLayer
%                 averagePooling2dLayer(1,'Stride',1)
                
%                 convolution2dLayer(1,50,'Padding','same')
%                 batchNormalizationLayer
%                 reluLayer
%                 averagePooling2dLayer(1,'Stride',1)
                
%                 convolution2dLayer(1,50,'Padding','same')
%                 batchNormalizationLayer
%                 reluLayer
%                 averagePooling2dLayer(1,'Stride',1)
% 
%                 convolution2dLayer(1,50,'Padding','same')
%                 batchNormalizationLayer
%                 reluLayer
%                 averagePooling2dLayer(1,'Stride',1)
%                 
%                 
%                 convolution2dLayer(1,100,'Padding','same')
%                 batchNormalizationLayer
%                 reluLayer
%                 averagePooling2dLayer(1,'Stride',1)
% 
%                 convolution2dLayer(1,100,'Padding','same')
%                 batchNormalizationLayer
%                 reluLayer
%                  averagePooling2dLayer(1,'Stride',1)
               
                % averagePooling2dLayer(1,'Stride',1)
%                 convolution2dLayer(3,32,'Padding','same')
%                 batchNormalizationLayer
%                 reluLayer
                %dropoutLayer(0.2)
                %fullyConnectedLayer(2)
                regressionLayer];

        
    lgraph = layerGraph(layers);
    figure
    plot(lgraph);
    
    miniBatchSize = 2;
    
    options = trainingOptions('sgdm', ...
    'MaxEpochs',30,...
    'MiniBatchSize',miniBatchSize, ...
    'InitialLearnRate',1e-3, ...
    'GradientThreshold',0.1, ...
    'Verbose',false, ...
    'Plots','training-progress');


    convnet_Longitude = trainNetwork(RSSI_train_data, responses, lgraph, options);

  
    CNN_Loc_Prediction = predict(convnet_Longitude, RSSI_test_data);
    CNN_Loc_Prediction = CNN_Loc_Prediction.*std_r+mean_r;
    CNN_Loc_Prediction(:, 1) = -1*(CNN_Loc_Prediction(:, 1));
    %CNN_Floor_Prediction=CNN_Floor_Prediction-1;

