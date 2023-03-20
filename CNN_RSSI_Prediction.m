function [CNN_RSSI_Prediction] = CNN_RSSI_Prediction(Floor_Train1, Floor_Train2, Floor_Test, num)

    

   % responses = categorical(Floor_Train_Observations(:,size(Floor_Train_Observations,2)-1));
   responses = Floor_Train1(:,1)/100;
   RSSI_train1_data = -105*ones(num-1,1,1,size(Floor_Train1, 1));
   RSSI_train2_data = -105*ones(num-1,1,1,size(Floor_Train2, 1));
   RSSI_test_data   = -105*ones(num-1,1,1,size(Floor_Test, 1));
    for i = 1:size(Floor_Train1, 1)
        RSSI_train1_data(:,1,1,i) = Floor_Train1(i,2:num)'; 
    end

    for i = 1:size(Floor_Train2, 1)
        RSSI_train2_data(:,1,1,i) = Floor_Train2(i,2:num)'; 
    end

    for i = 1:size(Floor_Test, 1)
        RSSI_test_data(:,1,1,i) = Floor_Test(i,2:num)'; 
    end

    imageSize=[num-1 1 1];

layers = [
    imageInputLayer(imageSize)

                   convolution2dLayer(3,8,'Padding','same')
                batchNormalizationLayer
                reluLayer
                averagePooling2dLayer(1,'Stride',1)
                convolution2dLayer(3,16,'Padding','same')
                batchNormalizationLayer
                reluLayer
                averagePooling2dLayer(1,'Stride',1)
%                 convolution2dLayer(3,32,'Padding','same')
%                 batchNormalizationLayer
%                 reluLayer
                dropoutLayer(0.2)
                fullyConnectedLayer(1)
                regressionLayer];
    
%     convolution2dLayer(5,8,'Padding','same')
%     batchNormalizationLayer
%     reluLayer   
%     
%     maxPooling2dLayer(1,'Stride',1)
%     
%     convolution2dLayer(5,16,'Padding','same')
%     batchNormalizationLayer
%     reluLayer   
%     
%     maxPooling2dLayer(1,'Stride',1)
%     
%     convolution2dLayer(5,32,'Padding','same')
%     batchNormalizationLayer
%     reluLayer   
%     
%     fullyConnectedLayer(1)
%     softmaxLayer
%     regressionLayer];

% %% This 2D layer works fine with 89% accuracy
% layers = [ ...
%     imageInputLayer([312 1])
%     %fullyConnectedLayer(312)
%     %convolution2dLayer(1,5,'Padding','same')
%     convolution2dLayer(1,7)
%     %batchNormalizationLayer
%     reluLayer
%     %maxPooling2dLayer(1,'Stride',1)
%     %dropoutLayer(0.1)
%     fullyConnectedLayer(4)
%     softmaxLayer
%     classificationLayer];





        lgraph = layerGraph(layers);
        figure
        plot(lgraph);

        miniBatchSize = 10;

   options = trainingOptions('sgdm', ...
    'MaxEpochs',50,...
    'MiniBatchSize',miniBatchSize, ...
    'InitialLearnRate',1e-1, ...
    'GradientThreshold',1, ...
    'Verbose',false, ...
    'Plots','training-progress');



%current accuracy 79%
% 
% layers = [ ...
%     image3dInputLayer([9 9 4 1])
%     convolution3dLayer(4,50,'Stride',4)
%     batchNormalizationLayer
%     reluLayer
%     maxPooling3dLayer(1,'Stride',1)
%     fullyConnectedLayer(4)
%     softmaxLayer
%     classificationLayer]




% 
% maxEpochs = 100;
% miniBatchSize = 15;
% 
% options = trainingOptions('sgdm', ...
%     'ExecutionEnvironment','cpu', ...
%     'MaxEpochs',maxEpochs, ...
%     'MiniBatchSize',miniBatchSize, ...
%     'InitialLearnRate',5e-5, ...
%     'GradientThreshold',1, ...
%     'Verbose',false, ...
%     'Plots','training-progress');


    convnet_RSSI = trainNetwork(RSSI_train1_data, responses, lgraph, options);

    mean(responses)

    mean(RSSI_train1_data(:,1,1,10))

  
   % Floor_prediction_in_sample = predict(convnet_Floor, floor_data);

    %[M_in_sample, Floor_in_sample_prediction] = max(double(predict(convnet_Floor, floor_data)), [], 2);
    %Floor_in_sample_prediction

    

    %[M_out_sample, Floor_out_sample_prediction] = max(double(predict(convnet_Floor, floor_test_data)), [], 2);


%     CNN_Longitude_Prediction = predict(convnet_Longitude, loc_test_data);
% 
%     CNN_Latitude_Prediction = predict(convnet_Latitude, loc_test_data);

    CNN_RSSI_Prediction =predict(convnet_RSSI, RSSI_train1_data)


